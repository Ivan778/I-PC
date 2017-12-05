//
//  KeyRunLoop.m
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "KeyRunLoop.h"

@implementation KeyRunLoop

/*
CGEventRef pressedSomeKeyDown(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    int key = (int)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    
 
    if ([((__bridge ViewController*)refcon).keyBlocker blockCycle:key]) {
        return nil;
    }
    
    [[(__bridge ViewController*)refcon key] doFullCycle:key];
 
    return event;
}
*/

+ (void)setRunLoop: (CGEventTapCallBack)callback : (void*)userInfo {
    CFRunLoopSourceRef runLoopSource;
    
    
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,
                                              kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventFlagsChanged),
                                              callback, userInfo);
    
    /*
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,
                                              kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventFlagsChanged),
                                              pressedSomeKeyDown, (__bridge void*)(self));
    */
    
    if (!eventTap) NSLog(@"Couldn't create event tap!");
    
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
}

@end
