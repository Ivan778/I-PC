//
//  ViewController.m
//  CDBurner
//
//  Created by Иван on 06.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSWindowDelegate, NSOpenSavePanelDelegate, NSUserNotificationCenterDelegate, NSTableViewDelegate, NSTableViewDataSource>
@end

@implementation ViewController

{
    BOOL inProgress;
    NSMutableArray *filesName, * filesPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    filesName = [[NSMutableArray alloc] init];
    filesPath = [[NSMutableArray alloc] init];
    
    NSUserNotificationCenter *userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    userNotificationCenter.delegate = self;
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
}

- (NSAlert*)createAlert:(NSString*)message : (NSString*)moreInfo {
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setInformativeText:moreInfo];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    return alert;
}


// Чтобы не закрыться во время выполнения записи/стирания
- (BOOL) validateMenuItem:(id)sender {
    if ([sender action] == @selector(terminate:)) {
        return (inProgress == NO);
    }
    else {
        return [super validateMenuItem:sender];
    }
}

#pragma mark Notifications

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)callNotification:(NSString*)title : (NSString*)text {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = text;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

#pragma mark Table view

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"NameCell" owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"NameCell"]) {
        cellView = [tableView makeViewWithIdentifier:@"Name" owner:self];
        [[cellView textField] setStringValue:filesName[row]];
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [filesName count];
}

- (IBAction)deleteFileFromTable:(id)sender {
    int row = (int)[_tableView selectedRow];
    
    if (row >= 0) {
        if ([filesName count] > row) {
            [filesName removeObjectAtIndex:row];
        }
        
        if ([filesPath count] > row) {
            [filesPath removeObjectAtIndex:row];
        }
        
        [_tableView reloadData];
    }
}

- (IBAction)deleteAllFilesFromTable:(id)sender {
    [filesName removeAllObjects];
    [filesPath removeAllObjects];
    
    [_tableView reloadData];
}


#pragma mark Erase methods

- (IBAction)eraseClick:(id)sender {
    DREraseSetupPanel *setupPanel = [DREraseSetupPanel setupPanel];
    [setupPanel setDelegate:self];
    
    if ([setupPanel runSetupPanel] == NSModalResponseOK) {
        DREraseProgressPanel *progressPanel = [DREraseProgressPanel progressPanel];
        [progressPanel setDelegate:self];
        
        [progressPanel beginProgressPanelForErase:[setupPanel eraseObject]];
    }
}

- (void)eraseProgressPanelWillBegin:(NSNotification *)aNotification {
    inProgress = YES;
}

- (void)eraseProgressPanelDidFinish:(NSNotification *)aNotification {
    [self callNotification:@"Success" :@"Disc was erased successfully."];
    inProgress = NO;
}

#pragma mark File picker

- (IBAction)addFilesClick:(id)sender {
    [self filePicker];
}

// Добавляет файлы в словарь файлов
- (void)filePicker {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles: YES];
    [panel setCanChooseDirectories: NO];
    [panel setAllowsMultipleSelection: YES];
    
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        // Добавили новые файлы в список
        filesName = [FileNamesManager addFileNames:filesName :[FilePicker getFilesName:[panel URLs]]];
        //[filesName addObjectsFromArray:[FilePicker getFilesName:[panel URLs]]];
        [filesPath addObjectsFromArray:[FilePicker getFilesPath:[panel URLs]]];
        
        [_tableView reloadData];
    }
}

#pragma mark Burn methods

- (void)buttonsEnabled: (BOOL)param {
    [_writeToDiscButton setEnabled:param];
    [_eraseDiscButton setEnabled:param];
    [_addFilesButton setEnabled:param];
    [_deleteButton setEnabled:param];
}

- (IBAction)burnDiscClick:(id)sender {
    [self buttonsEnabled:NO];
    [_progressIndicator setHidden:NO];
    [_progressIndicator startAnimation:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([InsertedDiscManager getAmountOfBlocks] != -1) {
            if ([filesName count] > 0) {
                [CDFolderManager createFolderToBurn:filesName :filesPath];
                
                if ([InsertedDiscManager getAmountOfBlocks] >= [InsertedDiscManager getFileBlocksAmount]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self burnSetup];
                        [self buttonsEnabled:YES];
                        
                        [_progressIndicator setHidden:YES];
                        [_progressIndicator stopAnimation:self];
                    });
                } else {
                    [CDFolderManager eraseBurnFolder];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSAlert *alert = [self createAlert:@"Error!" :@"There is not enough space on disk. Create new list of files to write."];
                        [alert runModal];
                        [self buttonsEnabled:YES];
                        
                        [_progressIndicator setHidden:YES];
                        [_progressIndicator stopAnimation:self];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [self createAlert:@"Error!" :@"No folder to write."];
                    [alert runModal];
                    [self buttonsEnabled:YES];
                    
                    [_progressIndicator setHidden:YES];
                    [_progressIndicator stopAnimation:self];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [self createAlert:@"Error!" :@"Need blank CD."];
                [alert runModal];
                [self buttonsEnabled:YES];
                
                [_progressIndicator setHidden:YES];
                [_progressIndicator stopAnimation:self];
            });
        }
    });
}

- (void)burnSetup {
    DRFolder *rootFolder = [DRFolder folderWithPath:[FilePathManager pathToFolder]];
    DRTrack *track = [DRTrack trackForRootFolder:rootFolder];
    
    if (track) {
        DRBurnSetupPanel *setupPanel = [DRBurnSetupPanel setupPanel];
        [setupPanel setDelegate:self];
        if ([setupPanel runSetupPanel] == NSModalResponseOK) {
            DRBurnProgressPanel *progressPanel = [DRBurnProgressPanel progressPanel];
            
            [progressPanel setDelegate:self];
            [progressPanel beginProgressPanelForBurn:[setupPanel burnObject] layout:track];
        } else {
            [CDFolderManager eraseBurnFolder];
        }
    }
}

- (void)burnProgressPanelWillBegin:(NSNotification*)aNotification {
    inProgress = YES;
}


- (void)burnProgressPanelDidFinish:(NSNotification*)aNotification {
    inProgress = NO;
}

- (BOOL)burnProgressPanel:(DRBurnProgressPanel*)theBurnPanel burnDidFinish:(DRBurn*)burn {
    NSDictionary *burnStatus = [burn status];
    NSString *state = [burnStatus objectForKey:DRStatusStateKey];
    
    if ([state isEqualToString:DRStatusStateFailed]) {
        NSDictionary *errorStatus = [burnStatus objectForKey:DRErrorStatusKey];
        NSString *errorString = [errorStatus objectForKey:DRErrorStatusErrorStringKey];
        
        NSLog(@"The burn failed (%@)!", errorString);
        [self callNotification:@"Failure" :@"The burn failed!"];
        
        [CDFolderManager eraseBurnFolder];
    }
    else {
        NSLog(@"The burn finished correctly.");
        [self callNotification:@"Success" :@"The burn finished correctly."];
        
        [CDFolderManager eraseBurnFolder];
    }
    
    return YES;
}

@end
