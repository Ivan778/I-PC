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

{
    bool flag;
    int fl;
}

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    //0x0b is the virtual keycode for "b"
    //0x09 is the virtual keycode for "v"
    //NSPoint mouseLoc = [NSEvent mouseLocation]; //get current mouse position
    //NSLog(@"Mouse location: %f %f", mouseLoc.x, mouseLoc.y);
    
    
    
    NSLog(@"%lld", CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode));//kCGKeyboardEventKeycode
    if (CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 0x0B) {
        //CGEventSetIntegerValueField(event, kCGKeyboardEventKeycode, 0x09);
        [(__bridge ViewController*)refcon reset];
    }
    
    return event;
}

- (void)reset {
    fl++;
    if (fl % 2 == 0) {
        flag = !flag;
        
        ProcessSerialNumber psn = { 0, kCurrentProcess };
        
        if (flag == true) {
            TransformProcessType(&psn, kProcessTransformToForegroundApplication);
        } else {
            TransformProcessType(&psn, kProcessTransformToUIElementApplication);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    flag = true;
    fl = 0;
    
    // Code benefitting from a local autorelease pool.
    CFRunLoopSourceRef runLoopSource;
    
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, kCGEventMaskForAllEvents, myCGEventCallback, (__bridge void *)(self));
    
    if (!eventTap) {
        NSLog(@"Couldn't create event tap!");
        exit(1);
    }
    
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    
    CGEventTapEnable(eventTap, true);
    
    CFRelease(eventTap);
    CFRelease(runLoopSource);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
