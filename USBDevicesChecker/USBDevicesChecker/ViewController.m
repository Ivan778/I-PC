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
        }
        
    }
        
    return cellView;
}

// Отслеживает выбранные строки в таблице
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [notification.object selectedRow];
    
    if (row >= 0) {
        if ([devices[row] getDeviceType] == YES) {
            [_EjectDeviceButton setEnabled:true];
        } else {
            [_EjectDeviceButton setEnabled:false];
        }
    }
    
    if (row < 0) {
        [_EjectDeviceButton setEnabled:false];
    }
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [devices count];
}

- (IBAction)clickedEjectButton:(id)sender {
    NSInteger row = [_tableView selectedRow];
    if (row >= 0) {
        NSMutableString *command = [[NSMutableString alloc] init];
        
        [command setString:@"diskutil unmountDisk "];
        [command insertString:[devices[row] getDeviceEjectPath] atIndex:[command length]];
        NSLog(@"%@", command);
        
        [devices removeObjectAtIndex:row];
        system([command cStringUsingEncoding:NSASCIIStringEncoding]);
        [_tableView reloadData];
        
        [_EjectDeviceButton setEnabled:false];
    }
}

- (void)updateData:(NSTimer*)theTimer {
    USBDevicesModel *m = [[USBDevicesModel alloc] init];
    NSMutableArray *d = [model getDevicesInfo];
    
    if ([d count] != [devices count]) {
        model = m;
        devices = d;
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model = [[USBDevicesModel alloc] init];
    devices = [model getDevicesInfo];
    
    // Настройка таблицы
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}



@end
