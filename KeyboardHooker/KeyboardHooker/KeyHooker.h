//
//  KeyboardHooker.h
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Time.h"
#import <SystemConfiguration/SystemConfiguration.h>

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
