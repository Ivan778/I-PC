//
//  KeyboardHooker.m
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "KeyHooker.h"

@implementation KeyHooker

- (id)init {
    self = [super init];
    
    cmd = false;
    
    anyKeyPressed = YES;
    flag = YES;
    combination = [NSMutableArray array];
    
    return self;
}

- (void)doFullCycle: (int)key {
    //anyKeyPressed = !anyKeyPressed;
    
    //if (key == 55) cmd = !cmd;
    //if (cmd == true && key == 4) [self reset];
    
    NSLog(@"%d at %@", key, [Time currentTime]);
        
    if (key == 55) [combination removeAllObjects];
    [combination addObject:[NSNumber numberWithInt:key]];
    if (key == 15 && [self checkCombination] == YES) [self reset];
}

- (BOOL)checkCombination {
    return [combination isEqualToArray:@[@55, @54, @54, @4, @31, @31, @40, @14, @15]];
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

@end
