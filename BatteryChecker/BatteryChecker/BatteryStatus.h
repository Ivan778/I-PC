//
//  BatteryStatus.h
//  BatteryChecker
//
//  Created by Иван on 28.09.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/ps/IOPowerSources.h>

@interface BatteryStatus : NSObject

- (NSString*)getPowerSourceType;
- (NSMutableString*)getBatteryLevel;
- (NSString*)getTimeLeft;

@end
