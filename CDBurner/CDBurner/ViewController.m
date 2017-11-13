//
//  ViewController.m
//  CDBurner
//
//  Created by Иван on 06.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSWindowDelegate, NSOpenSavePanelDelegate, NSUserNotificationCenterDelegate, NSDraggingDestination>
@end

@implementation ViewController

{
    BOOL inProgress;
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

- (void)filePicker {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles: YES];
    [panel setCanChooseDirectories: NO];
    [panel setAllowsMultipleSelection: YES];
    
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        NSMutableDictionary *dict = [FilePicker addFiles:[panel URLs]];
        
        for (id key in dict) {
            NSLog(@"%@", [dict objectForKey:key]);
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserNotificationCenter *userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    userNotificationCenter.delegate = self;
    
    [self filePicker];
    
    /*
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    //[fileManager copyItemAtPath:@"/users/ivan/Desktop/08\ If\ You\ Want\ Blood.wav" toPath:@"/users/ivan/Documents/08\ If\ You\ Want\ Blood.wav" error:&error];
    
    [fileManager copyItemAtPath:@"/users/ivan/Documents/Музыка/Градусы - Голая.mp3" toPath:@"/users/ivan/Desktop/Градусы - Голая.mp3" error:&error];
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
