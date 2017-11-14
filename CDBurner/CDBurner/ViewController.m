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

- (void)callNotification:(NSString*)title : (NSString*)text {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = text;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
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

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    filesName = [[NSMutableArray alloc] init];
    filesPath = [[NSMutableArray alloc] init];
    
    NSUserNotificationCenter *userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    userNotificationCenter.delegate = self;
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    /*
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    [manager copyItemAtPath:@"/users/ivan/Documents/Музыка/Градусы - Голая.mp3" toPath:@"/users/ivan/Desktop/Градусы - Голая.mp3" error:&error];
    if (error) NSLog(@"%@", error);
    */
}

- (IBAction)eraseClick:(id)sender {
    DREraseSetupPanel *setupPanel = [DREraseSetupPanel setupPanel];
    [setupPanel setDelegate:self];
    
    if ([setupPanel runSetupPanel] == NSModalResponseOK) {
        DREraseProgressPanel *progressPanel = [DREraseProgressPanel progressPanel];
        [progressPanel setDelegate:self];
        
        [progressPanel beginProgressPanelForErase:[setupPanel eraseObject]];
    }
}

- (IBAction)addFilesClick:(id)sender {
    [self filePicker];
}


- (IBAction)writeDiscClick:(id)sender {
    
}

- (void)eraseProgressPanelWillBegin:(NSNotification *)aNotification {
    inProgress = YES;
}

- (void)eraseProgressPanelDidFinish:(NSNotification *)aNotification {
    [self callNotification:@"Success" :@"Disc was erased successfully."];
    inProgress = NO;
}

@end
