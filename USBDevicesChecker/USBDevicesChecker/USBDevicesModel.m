//
//  USBDevicesModel.m
//  USBDevicesChecker
//
//  Created by Иван on 19.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "USBDevicesModel.h"

@implementation USBDevicesModel

- (NSMutableString*) removeSpacesInTheBeginning:(NSMutableString*)str {
    int i = 0;
    while (true) {
        if ([str characterAtIndex:0] == ' ') {
            [str deleteCharactersInRange:NSMakeRange(0, 1)];
            i++;
        } else {
            break;
        }
    }
    
    if (i == 12) {
        [str insertString:@"getMyVolumeBaby" atIndex:0];
    }
    
    return str;
}

- (NSMutableArray*) systemProfiler {
    FILE *fp;
    char path[1035];
    
    int attempt = 5;
    
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSMutableString *device = [[NSMutableString alloc] init];
    
    while (attempt > 0) {
        // Команда для чтения
        fp = popen("system_profiler SPUSBDataType -detailLevel full", "r");
        if (fp == NULL) {
            printf("Failed to run command\n" );
            exit(1);
        }
        
        // Читаем вывод команды
        while (fgets(path, sizeof(path)-1, fp) != NULL) {
            device = [NSMutableString stringWithUTF8String:path];
            device = [self removeSpacesInTheBeginning:device];
            
            [devices addObject:device];
        }
        
        // Закрываем файл
        pclose(fp);
        
        if ([devices count] == 0) {
            attempt--;
        } else {
            attempt = -1;
        }
    }
    
    
    //NSLog(@"Got it)");
    
    return devices;
}

- (NSMutableArray*) ioreg {
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen("ioreg -p IOUSB -w0 | sed 's/[^o]*o //; s/@.*$//' | grep -v '^Root.*'", "r");
    if (fp == NULL) {
        printf("Failed to run command\n" );
        exit(1);
    }
    
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSMutableString *device = [[NSMutableString alloc] init];
    
    // Читаем вывод команды
    while (fgets(path, sizeof(path)-1, fp) != NULL) {
        device = [NSMutableString stringWithUTF8String:path];
        [devices addObject:device];
    }
    
    // Закрываем файл
    pclose(fp);
    
    [devices removeObjectAtIndex:0];
    [devices removeObjectAtIndex:0];
    
    return devices;
}

- (NSMutableArray*) diskutil {
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen("diskutil list", "r");
    if (fp == NULL) {
        printf("Failed to run command\n" );
        exit(1);
    }
    
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSMutableString *device = [[NSMutableString alloc] init];
    
    // Читаем вывод команды
    while (fgets(path, sizeof(path)-1, fp) != NULL) {
        device = [NSMutableString stringWithUTF8String:path];
        [devices addObject:device];
    }
    
    for (int i = 0; i < 12; i++) {
        [devices removeObjectAtIndex:0];
    }
    
    // Закрываем файл
    pclose(fp);
    
    return devices;
}

// Возвращает полное описание устройства
- (NSMutableArray*) getDeviceDescription: (NSMutableArray*)array: (NSMutableString*)name {
    NSMutableArray *description = [[NSMutableArray alloc] init];
    
    [name insertString:@":" atIndex:[name length] - 1];
    
    BOOL foundDevice = NO;
    
    int i;
    for (i = 0; i < [array count]; i++) {
        if ([name compare:array[i]] == NSOrderedSame) {
            foundDevice = YES;
            break;
        }
    }
    
    if (foundDevice == YES) {
        i += 2;
        
        for (; i < [array count]; i++) {
            if ([array[i] compare:@"\n"] == NSOrderedSame) {
                break;
            }
            [description addObject:array[i]];
        }
    }
    
    return description;
}

// Возвращает основное имя диска (не разделов)
- (NSMutableString*) rightStringName: (NSMutableString*)str {
    int i = 3;
    for (; i < [str length]; i++) {
        if ([str characterAtIndex:i] == 's') {
            break;
        }
    }
    
    NSMutableString *ret = [[NSMutableString alloc] init];
    [ret setString:[str substringToIndex:i - 1]];
    
    return ret;
}

// Возвращает путь для демонтажа диска
- (NSMutableString*) giveDiskPath: (NSMutableArray*)description {
    NSMutableString *returnValue = [[NSMutableString alloc] init];
    [returnValue setString:@"Нет"];
    
    for (int i = 0; i < [description count]; i++) {
        if ([description[i] containsString:@"BSD Name"] == YES) {
            [returnValue setString:[description[i] substringFromIndex:10]];
            
            returnValue = [self rightStringName:returnValue];
            [returnValue insertString:@"/dev/" atIndex:0];
            
            return returnValue;
        }
    }
    
    return returnValue;
}

- (NSMutableArray*) getDiskVolumes: (NSMutableArray*)description {
    NSMutableArray *volumes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [description count]; i++) {
        if ([description[i] containsString:@"getMyVolumeBaby"] == YES) {
            DiskVolume *volume = [[DiskVolume alloc] init];
            
            [description[i] deleteCharactersInRange:NSMakeRange([description[i] length] - 2, 1)];
            
            [volume setName:[description[i] substringFromIndex:15]];
            [volume setCapacity:[description[i + 1] substringFromIndex:10]];
            if ([description[i + 2] containsString:@"Available"] == YES) {
                [volume setFreeSpace:[description[i + 2] substringFromIndex:11]];
            } else {
                [volume setFreeSpace:@"Неизвестно"];
            }
            
            [volumes addObject:volume];
            
            i += 3;
        }
    }
    
    return volumes;
}

- (NSString*) getDiskFullCapacity: (NSMutableArray*)description {
    for (int i = 0; i < [description count]; i++) {
        if ([description[i] containsString:@"Capacity"] == YES) {
            return [description[i] substringFromIndex:10];
        }
    }
    
    return @"Неизвестно";
}

- (NSString*) getDeviceSerialNumber: (NSMutableArray*)description {
    for (int i = 0; i < [description count]; i++) {
        if ([description[i] containsString:@"Serial Number:"] == YES) {
            return [description[i] substringFromIndex:15];
        }
    }
    
    return @"Неизвестно";
}

- (NSMutableArray*) getDevicesInfo {
    // Массив для хранения информации об устройствах
    NSMutableArray *devicesInfo = [[NSMutableArray alloc] init];
    
    NSMutableArray *sp = [self systemProfiler];
    NSMutableArray *io = [self ioreg];
    
    for (int i = 0; i < [io count]; i++) {
        DeviceDescription *device = [[DeviceDescription alloc] init];
        NSMutableArray *description = [self getDeviceDescription:sp :io[i]];
        
        [device setDeviceName:io[i]];
        [device setEjectStatus:@"⊗"];
        [device setDeviceSerialNumber:[self getDeviceSerialNumber:description]];
        
        NSMutableString *diskPath = [self giveDiskPath:description];
        if ([diskPath compare:@"Нет"] == NSOrderedSame) {
            [device setDeviceType:NO];
            [device setWasItEjected:NO];
        } else {
            [device setDeviceType:YES];
            [device setWasItEjected:NO];
            [device setDeviceEjectPath:diskPath];
            [device setDeviceFullCapacity:[self getDiskFullCapacity:description]];
            [device setVolumeInfo:[self getDiskVolumes:description]];
        }
        
        [devicesInfo addObject:device];
    }
    
    for (int i = 0; i < [devicesInfo count]; i++) {
        if ([[devicesInfo[i] getDeviceSerialNumber] compare:@"000000000820\n"] == NSOrderedSame) {
            [devicesInfo removeObjectAtIndex:i];
            i--;
        }
    }
    
    return devicesInfo;
}

- (NSMutableArray*) getDevicesInfoShort {
    // Массив для хранения информации об устройствах
    NSMutableArray *devicesInfo = [[NSMutableArray alloc] init];
    
    NSMutableArray *sp = [self systemProfiler];
    NSMutableArray *io = [self ioreg];
    
    for (int i = 0; i < [io count]; i++) {
        DeviceDescription *device = [[DeviceDescription alloc] init];
        NSMutableArray *description = [self getDeviceDescription:sp :io[i]];
        
        [device setDeviceName:io[i]];
        [device setDeviceSerialNumber:[self getDeviceSerialNumber:description]];
        [device setEjectStatus:@"⊗"];
        
        NSMutableString *diskPath = [self giveDiskPath:description];
        [device setDeviceType:NO];
        [device setDeviceEjectPath:@"-//-"];
        [device setDeviceFullCapacity:@"-//-"];
        
        [devicesInfo addObject:device];
    }
    
    return devicesInfo;
}

@end
