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

- (IBAction)pressedOK: (id)sender {
    [self dismissController:nil];
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn: (NSTableColumn *)tableColumn row:(NSInteger)row {
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
        
    } else if ([tableColumn.identifier isEqualToString:@"UsedSpaceCell"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"Used" owner:self];
        [[cellView textField] setStringValue:[[self volumes][row] getUsedSpace]];
        
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView: (NSTableView *)tableView {
    return [[self volumes] count];
}

- (NSInteger)getNumber: (NSString*)str {
    long int beg = [str rangeOfString:@"("].location + 1;
    long int fin = [str rangeOfString:@")"].location - 5;
    
    NSMutableString *temp = [[NSMutableString alloc] initWithString:[str substringWithRange:NSMakeRange(beg, fin - beg)]];
    
    for (int i = 0; i < [temp length]; i++) {
        //NSLog(@"%hu", [temp characterAtIndex:i]);
        if ([temp characterAtIndex:i] == 160) {
            [temp deleteCharactersInRange:NSMakeRange(i, 1)];
            i--;
        }
    }
    
    return [temp integerValue];
}

- (NSString*)getUsedSpaceString: (NSString*)full : (NSString*)free {
    NSInteger fu = [self getNumber:full];
    NSInteger fr = [self getNumber:free];
    
    NSInteger usB = fu - fr;
    double usGB = (double)usB / (double)1000000000;
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGroupingSeparator:@" "];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setMaximumFractionDigits:2];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:[NSString stringWithFormat:@"%@ GB (%@ bytes)", [formatter stringFromNumber:[NSNumber numberWithDouble:usGB]], [formatter stringFromNumber:[NSNumber numberWithInteger:usB]]]];
    
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    for (int i = 0; i < [[self volumes] count]; i++) {
        if ([[[self volumes][i] getCapacity] rangeOfString:@"("].length != 0 && [[[self volumes][i] getFreeSpace] rangeOfString:@"("].length != 0) {
            [[self volumes][i] setUsedSpace:[self getUsedSpaceString:[[self volumes][i] getCapacity] :[[self volumes][i] getFreeSpace]]];
        } else {
            [[self volumes][i] setUsedSpace:@"Неизвестно"];
        }
        
    }
    
    // Настройка таблицы
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
}

@end
