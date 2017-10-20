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
    NSMutableString *command = [[NSMutableString alloc] init];
    
    [command setString:@"diskutil unmountDisk "];
    [command insertString:[devices[row] getDeviceEjectPath] atIndex:[command length]];
    NSLog(@"%@", command);
    
    [devices removeObjectAtIndex:row];
    system([command cStringUsingEncoding:NSASCIIStringEncoding]);
    [_tableView reloadData];
    
    [_EjectDeviceButton setEnabled:false];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Настройка таблицы
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    model = [[USBDevicesModel alloc] init];
    devices = [model getDevicesInfo];
    [_tableView reloadData];
}



@end
