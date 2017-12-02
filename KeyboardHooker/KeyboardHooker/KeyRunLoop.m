//
//  KeyRunLoop.m
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "KeyRunLoop.h"

@implementation KeyRunLoop

+ (void)setRunLoop: (CGEventTapCallBack)callback : (void*)userInfo {
    CFRunLoopSourceRef runLoopSource;
    
    //CGEventMask eventMask;
    //eventMask = ((1 << kCGEventKeyDown) | (1 << kCGEventKeyUp));
    
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap,
                                              kCGEventTapOptionDefault, CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventFlagsChanged),
                                              callback, userInfo);
    
    if (!eventTap) NSLog(@"Couldn't create event tap!");
    
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
}

@end
