//
//  AppDelegate.m
//  BatteryChecker
//
//  Created by Иван on 26.09.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//  Запускать приложение нужно через sudo, иначе не будет работать изменение затемнения экрана от батареи

#import "AppDelegate.h"
#import "DisplaySleepController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    DisplaySleepController *displaySleep = [[DisplaySleepController alloc] init];
    // Восстанавливаем системную настройку времени затемнения
    [displaySleep resetDisplaySleep];
}


@end
