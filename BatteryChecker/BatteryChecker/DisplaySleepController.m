//
//  DisplaySleepController.m
//  BatteryChecker
//
//  Created by Иван on 04.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "DisplaySleepController.h"

@implementation DisplaySleepController

// Записывает время до затемнения экрана
- (void)rememberDisplaySleep {
    // Получаем задержку до затемнения экрана
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen("pmset -g | grep displaysleep", "r");
    if (fp == NULL) {
        printf("Failed to run command\n" );
        exit(1);
    }
    
    // Читаем вывод команды
    while (fgets(path, sizeof(path)-1, fp) != NULL);
    
    // Закрываем файл
    pclose(fp);
    
    int displaySleep;
    char number[3];
    
    for (int i = 13, j = 0; path[i] != '\n'; i++) {
        if (path[i] >= '0' && path[i] <= '9') {
            number[j] = path[i];
            j++;
        }
    }
    
    displaySleep = (int)[[NSMutableString stringWithUTF8String:number] integerValue];
    
    // Запоминаем её
    [[NSUserDefaults standardUserDefaults] setInteger:displaySleep forKey:@"defaultDisplaySleep"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) resetDisplaySleep {
    // Возвращаем задержку назад
    int defaultSystemSleep = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"defaultDisplaySleep"];
    
    // Формируем команду для выполнения
    NSMutableString *command = [@"sudo pmset -b displaysleep " mutableCopy];
    [command appendString:[NSString stringWithFormat:@"%d", defaultSystemSleep]];
    
    // Выполняем команду
    system([command cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
