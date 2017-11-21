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
    
    BOOL flag;
    BOOL anyKeyPressed;
    
    NSMutableArray *combination;
}

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    //0x0b is the virtual keycode for "b"
    //0x09 is the virtual keycode for "v"
    //NSPoint mouseLoc = [NSEvent mouseLocation]; //get current mouse position
    //NSLog(@"Mouse location: %f %f", mouseLoc.x, mouseLoc.y);
    
    [(__bridge ViewController*)refcon invertAnyKeyPressed];
    
    if ([(__bridge ViewController*)refcon getAnyKeyPressed] == YES) {
        
        
        NSLog(@"%lld", CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode));//kCGKeyboardEventKeycode
        if (CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 0x0B) {
            //[(__bridge ViewController*)refcon reset];
        }
        
        if (CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 55) {
            [(__bridge ViewController*)refcon freeSet];
        }
        
        [(__bridge ViewController*)refcon addToSet:(int)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode)];
        
        if (CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 15) {
            if ([(__bridge ViewController*)refcon checkCombination] == YES) {
                
                [(__bridge ViewController*)refcon reset];
            }
        }
    }
    
    return event;
}

- (void)invertAnyKeyPressed {
    anyKeyPressed = !anyKeyPressed;
}

- (BOOL)checkCombination {
    return [combination isEqualToArray:@[@55, @4, @31, @31, @40, @14, @15]];
}

- (BOOL)getAnyKeyPressed {
    return anyKeyPressed;
}

- (void)addToSet: (int)keyCode {
    [combination addObject:[NSNumber numberWithInt:keyCode]];
}

- (void)freeSet {
    [combination removeAllObjects];
}

- (void)reset {
    flag = !flag;
    ProcessSerialNumber psn = { 0, kCurrentProcess };
    
    if (flag == true) {
        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    } else {
        TransformProcessType(&psn, kProcessTransformToUIElementApplication);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    flag = YES;
    anyKeyPressed = NO;
    
    combination = [NSMutableArray array];
    
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
