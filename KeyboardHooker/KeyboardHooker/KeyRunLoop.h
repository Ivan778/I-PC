//
//  KeyRunLoop.h
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface KeyRunLoop : NSObject

+ (void)setRunLoop: (CGEventTapCallBack)callback : (void*)userInfo;

@end
