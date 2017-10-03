//
//  BatteryStatus.m
//  BatteryChecker
//
//  Created by Иван on 28.09.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "BatteryStatus.h"

@implementation BatteryStatus

// Возвращает тип питания (Battery/AC)
- (NSString*)getPowerSourceType {
    CFStringRef info;
    
    info = IOPSGetProvidingPowerSourceType(IOPSCopyPowerSourcesInfo());
    NSString *powerSourceType = (__bridge NSString *) info;
    
    return powerSourceType;
}

// Возвращает уровень заряда батареи
- (NSMutableString*)getBatteryLevel {
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen("pmset -g batt", "r");
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
    
    NSMutableString *level;
    char number[3];
    
    for (int i = 19, j = 0; path[i] != '%'; i++) {
        if (path[i] >= '0' && path[i] <= '9') {
            number[j] = path[i];
            j++;
        }
    }
    
    level = [NSMutableString stringWithUTF8String:number];
    [level insertString:@" %" atIndex:level.length];
    
    return level;
}

// Возвращает оставшееся время работы
- (NSString*)getTimeLeft {
    CFTimeInterval timeRemaining = IOPSGetTimeRemainingEstimate();
    
    if (timeRemaining == kIOPSTimeRemainingUnlimited) {
        return @"∞";
    } else {
        if (timeRemaining == kIOPSTimeRemainingUnknown) {
            return @"Считаю...";
        } else {
            double time = (double)(timeRemaining) / 60 / 60;
            int hours = (int)time;
            int minutes = ((double)time - (int)time) * 60;
            
            if (minutes < 10) {
                return [NSString stringWithFormat:@"%d:0%d", hours, minutes];
            } else {
                return [NSString stringWithFormat:@"%d:%d", hours, minutes];
            }
        }
    }
}

@end
