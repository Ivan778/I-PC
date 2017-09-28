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
        [_timeLeftLabel setStringValue:@"∞"];
    } else {
        if (timeRemaining == kIOPSTimeRemainingUnknown) {
            [_timeLeftLabel setStringValue:@"Считаю..."];
        } else {
            double time = (double)(timeRemaining) / 60 / 60;
            int hours = (int)time;
            int minutes = ((double)time - (int)time) * 60;
            
            NSString *info = [NSString stringWithFormat:@"%d:%d", hours, minutes];
            [_timeLeftLabel setStringValue:info];
        }
    }
}

// Вывести тип подключения в Label
- (void)setPowerSourceTypeLabel {
    CFStringRef info;
    
    info = IOPSGetProvidingPowerSourceType(IOPSCopyPowerSourcesInfo());
    NSString *powerSourceType = (__bridge NSString *) info;
    [_powerSourceTypeLabel setStringValue:powerSourceType];
}

-(NSMutableString*)getConsoleOutput: (char*)command {
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen(command, "r");
    if (fp == NULL) {
        printf("Failed to run command\n" );
        exit(1);
    }
    
    // Читаем вывод команды
    while (fgets(path, sizeof(path)-1, fp) != NULL) {
        //printf("%s", path);
    }
    
    // Закрываем файл
    pclose(fp);
    
    NSMutableString *ret;
    char number[3];
    
    for (int i = 19, j = 0; path[i] != '%'; i++) {
        if (path[i] >= '0' && path[i] <= '9') {
            number[j] = path[i];
            j++;
        }
    }
    
    ret = [NSMutableString stringWithUTF8String:number];
    
    return ret;
}

// Вывести процент заряда
- (void)setBatteryLevelLabel {
    NSMutableString *level = [self getConsoleOutput:"pmset -g batt"];
    [level insertString:@" %" atIndex:level.length];
    
    [_chargingLevelLabel setStringValue:level];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setTimeLeftLabel];
    [self setPowerSourceTypeLabel];
    [self setBatteryLevelLabel];
    
    [self initializePowerSourceChanges];
}

void PowerSourcesHaveChanged(void *context) {
    [(__bridge ViewController*)context setTimeLeftLabel];
    [(__bridge ViewController*)context setPowerSourceTypeLabel];
    [(__bridge ViewController*)context setBatteryLevelLabel];
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
