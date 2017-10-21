//
//  VolumeSheetViewController.m
//  USBDevicesChecker
//
//  Created by Иван on 20.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "VolumeSheetViewController.h"

@interface VolumeSheetViewController ()

@end

@implementation VolumeSheetViewController

- (IBAction)pressedOK:(id)sender {
    [self dismissController:nil];
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"VolumeCell" owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"VolumeCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Volume" owner:self];
        [[cellView textField] setStringValue:[[self volumes][row] getName]];
        
    } else if ([tableColumn.identifier isEqualToString:@"FullCapacityCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Capacity" owner:self];
        [[cellView textField] setStringValue:[[self volumes][row] getCapacity]];
        
    } else if ([tableColumn.identifier isEqualToString:@"FreeSpaceCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Free" owner:self];
        [[cellView textField] setStringValue:[[self volumes][row] getFreeSpace]];
        
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self volumes] count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // Настройка таблицы
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

@end
