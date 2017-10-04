//
//  ViewController.m
//  BatteryChecker
//
//  Created by Иван on 26.09.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import "DisplaySleepController.h"
#import <IOKit/ps/IOPowerSources.h>

@implementation ViewController

{
    BatteryStatus *status;
    DisplaySleepController *displaySleepController;
}

// Вывести оставшееся время работы от аккумулятора
- (void)setTimeLeftLabel {
    [_timeLeftLabel setStringValue:[status getTimeLeft]];
}

// Вывести процент заряда
- (void)setBatteryLevelLabel {
    // Создаём строку для вывода процентов
    NSMutableString *level = [status getBatteryLevel];
    [level insertString:@" %" atIndex:level.length];
    
    // Отображаем строку на экран
    [_chargingLevelLabel setStringValue:level];
    
    // Получаем заряд батареи в int
    int chargingLevel = (int)[level integerValue];
    // Устанавливаем значение индикаторной полоски
    [_BatteryLevelIndicatorCell setIntValue:chargingLevel];

}

// Вывести тип подключения в Label
- (void)setPowerSourceTypeLabel {
    NSString *info = status.getPowerSourceType;
    
    if (info != nil) {
        [_powerSourceTypeLabel setStringValue:info];
        // Если питание от батареи
        if ([info compare:@"Battery Power"] == NSOrderedSame) {
            // Не даём возможность изменить задержку до затемнения экрана
            [_SelectTillDecreaseBrightnessSlider setEnabled:false];
        } else {
            // При питании от батареи изменить время до затемнения можно
            [_SelectTillDecreaseBrightnessSlider setEnabled:true];
        }
    }
    
    // Если питание было от сети и стало от батареи
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PowerSupplyType"] == 1 && [info compare:@"Battery Power"] == NSOrderedSame) {
        // Устанавливаем новое предыдущее значение
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PowerSupplyType"];
        
        // Формируем команду для отправки в Терминал
        NSMutableString *command = [@"sudo pmset -b displaysleep " mutableCopy];
        [command appendString:[NSString stringWithFormat:@"%i", [_SelectTillDecreaseBrightnessSlider intValue]]];
        
        // Показываем время, которое мы выставили в настройки
        [_TimeTillDecreaseBrightness setStringValue:[NSString stringWithFormat:@"%i мин", [_SelectTillDecreaseBrightnessSlider intValue]]];
        
        // Отправили команду в Терминал
        system([command cStringUsingEncoding:NSUTF8StringEncoding]);
    }
    // Если питание было от батареи и стало от сети
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PowerSupplyType"] == 0 && [info compare:@"AC Power"] == NSOrderedSame) {
        // Устанавливаем новое предыдущее значение
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PowerSupplyType"];
    }
}

// Настройка Listener для батареи
-(void)initializePowerSourceChanges {
    CFRunLoopSourceRef CFrls;
    
    CFrls = IOPSNotificationCreateRunLoopSource(PowerSourcesHaveChanged, (__bridge void *)(self));
    if(CFrls) {
        CFRunLoopAddSource(CFRunLoopGetCurrent(), CFrls, kCFRunLoopDefaultMode);
        CFRelease(CFrls);
    }
    
}

// Прописываем здесь, методы которые будем вызывать
void PowerSourcesHaveChanged(void *context) {
    [(__bridge ViewController*)context setTimeLeftLabel];
    [(__bridge ViewController*)context setPowerSourceTypeLabel];
    [(__bridge ViewController*)context setBatteryLevelLabel];
}

// Будет изменять время до затемнения экрана при работе от батареи (сам метод не изменяет занчение, оно изменится в том случае, если работа будет не от батареи)
- (IBAction)changedValueSlider:(id)sender {
    // Показываем время, которое мы выставили в настройки
    [_TimeTillDecreaseBrightness setStringValue:[NSString stringWithFormat:@"%i мин", [sender intValue]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Инициализируем объект типа BatteryStatus, который выдаёт нам информацию о батарее
    status = [[BatteryStatus alloc] init];
    
    if ([[status getPowerSourceType] compare:@"Battery Power"] == NSOrderedSame) {
        // 0 - признак питания от батареи при запуске приложения
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PowerSupplyType"];
    } else {
        // 1 - признак питания от сети при запуске приложения
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PowerSupplyType"];
    }
    
    // Инициализируем объект типа DisplaySleepController
    displaySleepController = [[DisplaySleepController alloc] init];
    // Записываем текущую системную задержку
    [displaySleepController rememberDisplaySleep];
    
    // Выводим стартовые значения параметров батареи
    [self setTimeLeftLabel];
    [self setPowerSourceTypeLabel];
    [self setBatteryLevelLabel];
    [_TimeTillDecreaseBrightness setStringValue:@"3 мин"];
    
    // Устанавливаем Listener для батареи
    [self initializePowerSourceChanges];
}

@end
