//
//  KeycodeEncrypter.h
//  KeyboardHooker
//
//  Created by Иван on 03.12.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeycodeEncrypter : NSObject

+ (NSString *)keyStringFormKeyCode:(unsigned long long)keyCode;

@end
