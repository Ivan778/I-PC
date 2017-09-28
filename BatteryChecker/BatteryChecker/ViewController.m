//
//  ViewController.m
//  BatteryChecker
//
//  Created by Иван on 26.09.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import <IOKit/ps/IOPowerSources.h>

@implementation ViewController

// Вывести оставшееся время работы от аккумулятора
- (void)setTimeLeftLabel {
    CFTimeInterval timeRemaining = IOPSGetTimeRemainingEstimate();
    
    if (timeRemaining == kIOPSTimeRemainingUnlimited) {
        [_timeLeftLabel setStringValue:@"Заряжается"];
    } else {
        double time = (double)(timeRemaining) / 60 / 60;
        int hours = (int)time;
        int minutes = ((double)time - (int)time) * 60;
        
        NSString *info = [NSString stringWithFormat:@"%d:%d", hours, minutes];
        NSLog(@"%@", info);
        
        [_timeLeftLabel setStringValue:info];
    }
}

// Вывести тип подключения в Label
- (void)setPowerSourceTypeLabel {
    CFStringRef info;
    
    info = IOPSGetProvidingPowerSourceType(IOPSCopyPowerSourcesInfo());
    NSString *powerSourceType = (__bridge NSString *) info;
    [_powerSourceTypeLabel setStringValue:powerSourceType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setTimeLeftLabel];
    [self setPowerSourceTypeLabel];
    
    [self initializePowerSourceChanges];
}

void PowerSourcesHaveChanged(void *context) {
    [(__bridge ViewController*)context setTimeLeftLabel];
    [(__bridge ViewController*)context setPowerSourceTypeLabel];
}

-(void)initializePowerSourceChanges {
    CFRunLoopSourceRef CFrls;
    
    CFrls = IOPSNotificationCreateRunLoopSource(PowerSourcesHaveChanged, (__bridge void *)(self));
    if(CFrls) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), CFrls, kCFRunLoopDefaultMode);
        CFRelease(CFrls);
    }
    
}

@end
