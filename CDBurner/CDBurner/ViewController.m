//
//  ViewController.m
//  CDBurner
//
//  Created by Иван on 06.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSWindowDelegate, NSOpenSavePanelDelegate, NSUserNotificationCenterDelegate>
@end

@implementation ViewController

{
    BOOL burnInProgress;
}

- (DRTrack *)createTrack
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    // Ask the user for the files to burn.
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setResolvesAliases:YES];
    [openPanel setDelegate:self];
    [openPanel setTitle:@"Select a folder for your CD content."];
    [openPanel setPrompt:@"Select"];
    
    if ([openPanel runModal] == NSModalResponseOK)
    {
        DRFolder *rootFolder = [DRFolder folderWithPath:[((NSURL *)[[openPanel URLs] objectAtIndex:0]) path]];
        
        return [DRTrack trackForRootFolder:rootFolder];
    }
    
    return nil;
}

- (BOOL)setupPanel:(DRSetupPanel*)aPanel deviceCouldBeTarget:(DRDevice*)device
{
    if (/* DISABLES CODE */ (NO)) {
        /*
         This path shows how to filter devices bases on the properties of the device. For example, it's possible to limit the drives displayed to only those hooked up over FireWire, or converesely, you could NOT show drives if there was some reason to.
         */
        NSDictionary *deviceInfo = [device info];
        if ([[deviceInfo objectForKey:DRDevicePhysicalInterconnectKey] isEqualToString:DRDevicePhysicalInterconnectFireWire])
        {
            return YES;
        }
        else
        {
            return NO;
        }
        
    }
    return YES;
}

- (BOOL)setupPanel:(DRSetupPanel*)aPanel deviceContainsSuitableMedia:(DRDevice*)device promptString:(NSString**)prompt
{
    if (/* DISABLES CODE */ (NO)) {
        /*
         This path shows how to check to see what sort of media there is present in the drive. If it's not a CDR or CDRW we reject it. This prevents us from burning to a DVD.
         */
        NSString *mediaType = [[[device status] objectForKey:DRDeviceMediaInfoKey] objectForKey:DRDeviceMediaTypeKey];
        if ([mediaType isEqualToString:DRDeviceMediaTypeCDR] == NO && [mediaType isEqualToString:DRDeviceMediaTypeCDRW] == NO)
        {
            *prompt = @"That's not a writable CD!";
            return NO;
        }
    }
    /*
     OK everyone agrees that this disc is OK to be burned in this drive.
     We could also return our own OK, prompt string here, but we'll let the default all ready string do its job.
     */
    // *prompt = [NSString stringWithCString:"Let's roll!"];
    
    return YES;
}

- (void)runSelection {
    DRTrack *track = [self createTrack];
    
    if (track)
    {
        
        DRBurnSetupPanel *setupPanel = [DRBurnSetupPanel setupPanel];
        
        /*
         We'll be the delegate for the setup panel. This allows us to show off some of the customization you can do.
         */
        [setupPanel setDelegate:self];
        
        if ([setupPanel runSetupPanel] == NSModalResponseOK)
        {
            DRBurnProgressPanel *progressPanel = [DRBurnProgressPanel progressPanel];
            
            [progressPanel setDelegate:self];
            
            /*
             Start the burn itself. This will put up the progress dialog and do all the nice pretty things that a happy app does.
             */
            [progressPanel beginProgressPanelForBurn:[setupPanel burnObject] layout:track];
            
            /*
             If you wanted to run this as a sheet you would have sent:
             [progressPanel beginProgressSheetForBurn:[bsp burnObject] layout:tracks modalForWindow:aWindow];
             */
        }
        else
        {
            [NSApp terminate:self];
        }
    }
    else
    {
        [NSApp terminate:self];
    }
}

- (BOOL) validateMenuItem:(id)sender {
    if ([sender action] == @selector(terminate:)) {
        return (burnInProgress == NO);        // No quitting while a burn is in progress.
    }
    else {
        return [super validateMenuItem:sender];
    }
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserNotificationCenter *userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    userNotificationCenter.delegate = self;
    
    DREraseSetupPanel *setupPanel = [DREraseSetupPanel setupPanel];
    [setupPanel setDelegate:self];
    
    if ([setupPanel runSetupPanel] == NSModalResponseOK) {
        DREraseProgressPanel *progressPanel = [DREraseProgressPanel progressPanel];
        [progressPanel setDelegate:self];
        
        [progressPanel beginProgressPanelForErase:[setupPanel eraseObject]];
    } else {
        [NSApp terminate:self];
    }
    
}

- (void)eraseProgressPanelWillBegin:(NSNotification *)aNotification {
    burnInProgress = YES;
}

- (void)eraseProgressPanelDidFinish:(NSNotification *)aNotification {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Success!";
    notification.informativeText = [NSString stringWithFormat:@"Disc was erased successfully."];
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    burnInProgress = NO;
}

@end
