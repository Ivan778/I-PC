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
            [_timeLeftLabel setStringValue:@"Идёт подсчёт оставшегося времени работы"];
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

-(int)getConsoleOutput: (char*)command {
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
        printf("%s", path);
    }
    
    // Закрываем файл
    pclose(fp);
    
    int i, j;
    for (i = 0; path[i] != '\n'; i++) {
        if (path[i] == '=') {
            break;
        }
    }
    
    i += 2;

    char number[4];
    for (j = 0; path[i] != '\n'; i++, j++) {
        number[j] = path[i];
    }
    
    j--;
    
    int k = 10, ret = 0;
    
    i = 0;
    while (i <= j) {
        ret = k * ret + (number[i] - '0');
        i++;
    }
    
    return ret;
}

// Вывести процент заряда
- (void)setBatteryLevelLabel {
    int currentLevel = [self getConsoleOutput:"ioreg -w0 -l | grep CurrentCapacity"];
    int maxLevel = [self getConsoleOutput:"ioreg -w0 -l | grep MaxCapacity"];
    
    int level = (int)(((double)currentLevel / (double)maxLevel) * 100);
    
    NSString *info = [NSString stringWithFormat:@"%d %%", level];
    [_chargingLevelLabel setStringValue:info];
    
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
