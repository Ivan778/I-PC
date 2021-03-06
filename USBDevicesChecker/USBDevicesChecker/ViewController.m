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

{
    USBDevicesModel *model;
    NSMutableArray *devices;
    
    BOOL ejecting;
    NSTimer *updates;
}

/*:(NSTimer*)theTimer*/

// Заносит данные в таблицу
- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"DeviceCell" owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"DeviceCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Device" owner:self];
        [[cellView textField] setStringValue:[devices[row] getDeviceName]];
        
    } else if ([tableColumn.identifier isEqualToString:@"DeviceTypeCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Type" owner:self];
        
        if ([devices[row] getDeviceType] == YES) {
            [[cellView textField] setStringValue:[devices[row] getDeviceEjectPath]];
        } else {
            if ([devices[row] getWasItEjected] == YES) {
                [[cellView textField] setStringValue:[devices[row] getDeviceEjectPath]];
            } else {
                [[cellView textField] setStringValue:@"⊗"];
            }
        }
        
    } else if ([tableColumn.identifier isEqualToString:@"DeviceSizeCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Size" owner:self];
        
        if ([devices[row] getDeviceType] == YES) {
            [[cellView textField] setStringValue:[devices[row] getDeviceFullCapacity]];
        } else {
            if ([devices[row] getWasItEjected] == YES) {
                [[cellView textField] setStringValue:[devices[row] getDeviceFullCapacity]];
            } else {
                [[cellView textField] setStringValue:@"⊗"];
            }
        }
        
    } else if ([tableColumn.identifier isEqualToString:@"DeviceEjectCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Eject" owner:self];
        [[cellView textField] setStringValue:[devices[row] getEjectStatus]];
        
    }
        
    return cellView;
}

// Отслеживает выбранные строки в таблице и активирует/деактивирует кнопки в соответствие с параметрами выбранного устройства
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [notification.object selectedRow];
    
    if (ejecting == NO) {
        if (row >= 0) {
            if ([devices[row] getDeviceType] == YES) {
                if ([devices[row] getWasItEjected] == NO) {
                    [_EjectDeviceButton setEnabled:true];
                    [_moreInfoButton setEnabled:true];
                } else {
                    [_EjectDeviceButton setEnabled:false];
                    [_moreInfoButton setEnabled:false];
                }
            } else {
                [_EjectDeviceButton setEnabled:false];
                [_moreInfoButton setEnabled:false];
            }
        }
        
        if (row < 0) {
            [_EjectDeviceButton setEnabled:false];
            [_moreInfoButton setEnabled:false];
        }
    }
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [devices count];
}

- (IBAction)clickedEjectButton:(id)sender {
    NSInteger row = [_tableView selectedRow];
    if (row >= 0 && ejecting == NO) {
        ejecting = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_EjectDeviceButton setEnabled: false];
                [_moreInfoButton setEnabled: false];
            });
            
            NSMutableString *command = [[NSMutableString alloc] init];
            
            [command setString:@"diskutil unmountDisk "];
            [command insertString: [devices[row] getDeviceEjectPath] atIndex: [command length]];
            
            NSMutableString *output = [[NSMutableString alloc] init];
            
            FILE *fp;
            char path[1035];
            
            // Команда для чтения
            fp = popen([command cStringUsingEncoding: NSASCIIStringEncoding], "r");
            if (fp == NULL) {
                printf("Failed to run command\n" );
                exit(1);
            }
            
            // Читаем вывод команды
            while (fgets(path, sizeof(path)-1, fp) != NULL) {
                output = [NSMutableString stringWithUTF8String:path];
            }
            
            // Закрываем файл
            pclose(fp);
            
            //system([command cStringUsingEncoding: NSASCIIStringEncoding]);
            
            if ([output containsString:@"successful"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [self createAlert:@"Готово!" :@"Устройство было успешно извлечено."];
                    
                    if ([alert runModal] == NSAlertFirstButtonReturn) {
                        [devices[row] setEjectStatus: @"√"];
                        [devices[row] setWasItEjected:YES];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Get row at specified index
                            NSTableCellView *selectedRow = [_tableView viewAtColumn:3 row:row makeIfNecessary: YES];
                            
                            // Get row's text field
                            NSTextField *selectedRowTextField = [selectedRow textField];
                            [selectedRowTextField setStringValue: @"√"];
                            
                            [_EjectDeviceButton setEnabled: false];
                            [_moreInfoButton setEnabled: false];
                        });
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [self createAlert:@"Ошибка!" :@"Устройство в данный момент занято. Попробуйте позже."];
                    
                    if ([alert runModal] == NSAlertFirstButtonReturn) {
                        [_EjectDeviceButton setEnabled: true];
                        [_moreInfoButton setEnabled: true];
                    }
                });
            }
            
            ejecting = NO;
        });
    }
}

- (NSAlert*)createAlert:(NSString*)message : (NSString*)moreInfo {
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setInformativeText:moreInfo];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    return alert;
}

- (void)updateData:(NSTimer*)theTimer {
    USBDevicesModel *m = [[USBDevicesModel alloc] init];
    NSMutableArray *d = [m getDevicesInfo];
    
    model = m;
    
    if ([d count] != [devices count]) {
        
        if ([d count] > [devices count]) {
            for (int i = 0; i < [d count]; i++) {
                
                BOOL flag = NO;
                for (int j = 0; j < [devices count]; j++) {
                    if ([[devices[j] getDeviceSerialNumber] compare:[d[i] getDeviceSerialNumber]] == NSOrderedSame) {
                        flag = YES;
                    }
                }
                
                if (flag == NO) {
                    [devices addObject:d[i]];
                }
            }
        } else {
            for (int i = 0; i < [devices count]; i++) {
                
                BOOL flag = NO;
                for (int j = 0; j < [d count]; j++) {
                    if ([[devices[i] getDeviceSerialNumber] compare:[d[j] getDeviceSerialNumber]] == NSOrderedSame) {
                        flag = YES;
                    }
                }
                
                if (flag == NO) {
                    [devices removeObjectAtIndex:i];
                }
            }
        }
        
        [_tableView reloadData];
    } else {
        
        for (int i = 0; i < [d count]; i++) {
            if ([[devices[i] getDeviceSerialNumber] compare:[d[i] getDeviceSerialNumber]] == NSOrderedSame) {
                
                if ([devices[i] getDeviceType] == NO && [d[i] getDeviceType] == YES) {
                    devices[i] = d[i];
                    [_tableView reloadData];
                } else if ([devices[i] getDeviceType] == YES && [d[i] getDeviceType] == YES) {
                    
                    NSMutableArray *cD = [devices[i] getVolumeInfo];
                    NSMutableArray *tD = [d[i] getVolumeInfo];
                    
                    BOOL volumeChanges = NO;
                    
                    for (int j = 0; j < [cD count]; j++) {
                        if (j < [tD count]) {// Добавил
                            if ([[cD[j] getName] compare:[tD[j] getName]] == NSOrderedSame) {
                                if ([[cD[j] getFreeSpace] compare:[tD[j] getFreeSpace]] != NSOrderedSame) {
                                    volumeChanges = YES;
                                }
                            }
                        }
                    }
                    
                    if (volumeChanges == YES) {
                        [devices[i] setVolumeInfo:[d[i] getVolumeInfo]];
                    }
                    
                }
                
            }
        }
        
    }
}

-(void) volumesChanged: (NSNotification*) notification {
    USBDevicesModel *m = [[USBDevicesModel alloc] init];
    NSMutableArray *d = [m getDevicesInfo];
    
    model = m;
    
    for (int i = 0; i < [d count]; i++) {
        
        for (int j = 0; j < [devices count]; j++) {
            
            if ([[devices[j] getDeviceSerialNumber] compare:[d[i] getDeviceSerialNumber]] == NSOrderedSame) {
                [d[i] setEjectStatus:[devices[j] getEjectStatus]];
                [d[i] setWasItEjected:[devices[j] getWasItEjected]];
                devices[j] = d[i];
            }
            
        }
        
    }
    
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ejecting = NO;
    
    model = [[USBDevicesModel alloc] init];
    devices = [model getDevicesInfo];
    
    // Настройка таблицы
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    updates = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self selector: @selector(volumesChanged:) name: NSWorkspaceDidMountNotification object: nil];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([_tableView selectedRow] >= 0) {
        if ([[segue identifier] compare:@"DiskVolumeInfo"] == NSOrderedSame) {
            VolumeSheetViewController *vc = [segue destinationController];
            vc.volumes = [devices[[_tableView selectedRow]] getVolumeInfo];
        }
    }
}


@end
