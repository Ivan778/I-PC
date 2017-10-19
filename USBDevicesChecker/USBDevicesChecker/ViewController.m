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
- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"DeviceCell" owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"DeviceCell"]) {
        cellView = [tableView makeViewWithIdentifier:@"Device" owner:self];
        [[cellView textField] setStringValue:@"Hello1"];
        //NSLog(@"%ld", (long)row);
    } else if ([tableColumn.identifier isEqualToString:@"DeviceTypeCell"]) {
        cellView = [tableView makeViewWithIdentifier:@"Type" owner:self];
        [[cellView textField] setStringValue:@"Hello2"];
        //NSLog(@"%ld", (long)row);
    }
        
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [notification.object selectedRow];
    if (row == 0) {
        [_EjectDeviceButton setEnabled:false];
    }
    if (row == 1) {
        [_EjectDeviceButton setEnabled:true];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 2;
}

- (IBAction)clickedEjectButton:(id)sender {
    NSLog(@"Клац)");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Настройка таблицы
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    USBDevicesModel *model = [[USBDevicesModel alloc] init];
    NSMutableArray *devices = [model getDevicesInfo];
    
    
}



@end
