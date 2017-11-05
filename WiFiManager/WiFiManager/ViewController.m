//
//  ViewController.m
//  WiFiManager
//
//  Created by Иван on 04.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import <CoreWLAN/CoreWLAN.h>

@implementation ViewController

{
    CWWiFiClient *wfc;
    CWInterface *wif;
    NSSet *scanset;
}

- (NSString*)getSecurity:(CWNetwork*)network {
    NSMutableString* result = [[NSMutableString alloc] initWithString:@""];
    
    if ([network supportsSecurity:kCWSecurityNone]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"None"];
    }
    
    if ([network supportsSecurity:kCWSecurityWEP]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"WEP"];
    }
    
    if ([network supportsSecurity:kCWSecurityWPAPersonal]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"WPAPersonal"];
    }
    
    if ([network supportsSecurity:kCWSecurityWPAPersonalMixed]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"WPAPersonalMixed"];
    }
    
    if ([network supportsSecurity:kCWSecurityWPA2Personal]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"WPA2Personal"];
    }
    
    if ([network supportsSecurity:kCWSecurityPersonal]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"Personal"];
    }
    
    if ([network supportsSecurity:kCWSecurityDynamicWEP]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"DynamicWEP"];
    }
    
    if ([network supportsSecurity:kCWSecurityWPAEnterprise]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"WPAEnterprise"];
    }
    
    if ([network supportsSecurity:kCWSecurityWPAEnterpriseMixed]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"WPAEnterpriseMixed"];
    }
    
    if ([network supportsSecurity:kCWSecurityWPA2Enterprise]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"WPA2Enterprise"];
    }
    
    if ([network supportsSecurity:kCWSecurityEnterprise]) {
        if ([result length] > 0) {
            [result appendString:@" / "];
        }
        
        [result appendString:@"Enterprise"];
    }
    
    return result;
}

- (void)scanCacheUpdatedForWiFiInterfaceWithName:(NSTimer*)theTimer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CWInterface *tempWif = wfc.interface;
        
        NSError *err;
        NSSet *tempScanset = [tempWif scanForNetworksWithSSID:Nil error:&err];
        
        if ([scanset count] == [tempScanset count]) {
            NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[scanset allObjects]];
            NSMutableArray *arr2 = [NSMutableArray arrayWithArray:[tempScanset allObjects]];
            
            [arr2 removeObjectsInArray:arr1];
            
            if ([arr2 count] > 0) {
                scanset = tempScanset;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }
            
        } else {
            scanset = tempScanset;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
    });
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"WiFiName" owner:self];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[scanset allObjects]];
    
    if ([tableColumn.identifier isEqualToString:@"WiFiName"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        [[cellView textField] setStringValue:[arr[row] ssid]];
        
    } else if ([tableColumn.identifier isEqualToString:@"MAC"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        [[cellView textField] setStringValue:[arr[row] bssid]];
        
    } else if ([tableColumn.identifier isEqualToString:@"SignalPower"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        [[cellView textField] setStringValue:[[NSString alloc] initWithFormat:@"%ld", (long)[arr[row] rssiValue]]];
        
    } else if ([tableColumn.identifier isEqualToString:@"Security"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        [[cellView textField] setStringValue:[self getSecurity:arr[row]]];
        
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [scanset count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        wfc = [CWWiFiClient sharedWiFiClient];
        wif = wfc.interface;
        
        NSError *err;
        scanset = [wif scanForNetworksWithSSID:Nil error:&err];
    //});
    
    [_tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanCacheUpdatedForWiFiInterfaceWithName:) userInfo:nil repeats:YES];
    
}

@end
