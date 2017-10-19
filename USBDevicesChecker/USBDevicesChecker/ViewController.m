//
//  ViewController.m
//  USBDevicesChecker
//
//  Created by Иван on 05.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import <IOKit/IOKitLib.h>
#import <IOKit/usb/IOUSBLib.h>
#include <IOKit/serial/IOSerialKeys.h>

@implementation ViewController

/*:(NSTimer*)theTimer*/

- (NSMutableString*) removeSpacesInTheBeginning:(NSMutableString*)str {
    while (true) {
        if ([str characterAtIndex:0] == ' ') {
            [str deleteCharactersInRange:NSMakeRange(0, 1)];
        } else {
            break;
        }
    }
    
    return str;
}

- (NSMutableArray*) systemProfiler {
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen("system_profiler SPUSBDataType", "r");
    if (fp == NULL) {
        printf("Failed to run command\n" );
        exit(1);
    }
    
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    NSMutableString *device = [[NSMutableString alloc] init];
    
    // Читаем вывод команды
    while (fgets(path, sizeof(path)-1, fp) != NULL) {
        device = [NSMutableString stringWithUTF8String:path];
        device = [self removeSpacesInTheBeginning:device];
        
        [devices addObject:device];
    }
    
    // Закрываем файл
    pclose(fp);
    
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
    
    int i;
    for (i = 0; [array count]; i++) {
        if ([name compare:array[i]] == NSOrderedSame) {
            break;
        }
    }
    
    i += 2;
    
    for (; [array count]; i++) {
        if ([array[i] compare:@"\n"] == NSOrderedSame) {
            break;
        }
        [description addObject:array[i]];
    }
    
    return description;
}

// Возвращает основное имя диска (не разделов)
-(NSMutableString*) rightStringName: (NSMutableString*)str {
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
    [returnValue setString:@"NOPE"];
    
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

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"DeviceCellID" owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"DeviceC"]) {
        cellView = [tableView makeViewWithIdentifier:@"DeviceCellID" owner:self];
        [[cellView textField] setStringValue:@"Hello1"];
    } else if ([tableColumn.identifier isEqualToString:@"TypeC"]) {
        cellView = [tableView makeViewWithIdentifier:@"TypeCellID" owner:self];
        [[cellView textField] setStringValue:@"Hello2"];
    } else if ([tableColumn.identifier isEqualToString:@"EjectC"]) {
        cellView = [tableView makeViewWithIdentifier:@"EjectCellID" owner:self];
        
        NSButton *button = [cellView viewWithTag:1000];
        [button setStringValue:@"Hello"];
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Настройка таблицы
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    NSMutableArray *sp = [self systemProfiler];
    NSMutableArray *io = [self ioreg];
    NSMutableArray *du = [self diskutil];
    
    
    for (int i = 0; i < [du count]; i++) {
        NSLog(@"%@", du[i]);
    }
    
    // Вывести список подключённых устройств
    for (int i = 0; i < [io count]; i++) {
        NSLog(@"%@", io[i]);
    }
    
    NSMutableArray *devices = [[NSMutableArray alloc] init];
    for (int i = 0; i < [io count]; i++) {
        [devices addObject:[self getDeviceDescription:sp :io[i]]];
    }
    
    
    for (int i = 0; i < [devices count]; i++) {
        NSLog(@"%@", [self giveDiskPath:devices[i]]);
    }
    
    
    
    //NSRange range = [du[1] rangeOfString:@"NAME"];
    
    
    /*
    int i = (int)range.location;
    for (; i < [du[3] length]; i++) {
        if ([du[3] characterAtIndex:i] == ' ') break;
    }
    NSString *s = [du[3] substringWithRange:NSMakeRange(range.location, i - range.location)];
    NSLog(@"%@", s);
    */
}



@end
