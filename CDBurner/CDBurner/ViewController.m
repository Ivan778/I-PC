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

- (IBAction)burnDiscClick:(id)sender {
    if ([filesName count] > 0) {
        [CDFolderManager createFolderToBurn:filesName :filesPath];
        
        [self burnSetup];
    }
}

- (void)burnSetup {
    DRFolder *track = [DRFolder folderWithPath:[FilePathManager pathToFolder]];
    if (track) {
        DRBurnSetupPanel *setupPanel = [DRBurnSetupPanel setupPanel];
        [setupPanel setDelegate:self];
        if ([setupPanel runSetupPanel] == NSModalResponseOK) {
            DRBurnProgressPanel *progressPanel = [DRBurnProgressPanel progressPanel];
            
            [progressPanel setDelegate:self];
            [progressPanel beginProgressPanelForBurn:[setupPanel burnObject] layout:track];
        }
    }
}

@end
