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
    CWInterface *tempWif = wfc.interface;
    
    NSError *err;
    NSSet *tempScanset = [tempWif scanForNetworksWithSSID:Nil error:&err];
    
    if ([scanset count] == [tempScanset count]) {
        NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[scanset allObjects]];
        NSMutableArray *arr2 = [NSMutableArray arrayWithArray:[tempScanset allObjects]];
        
        [arr2 removeObjectsInArray:arr1];
        
        if ([arr2 count] > 0) {
            scanset = tempScanset;
            for (CWNetwork *nw in tempScanset) {
                NSLog(@"%@", [nw ssid]);
                NSLog(@"%@", [nw bssid]);
                NSLog(@"%ld", (long)[nw rssiValue]);
                NSLog(@"%@\n\n", [self getSecurity:nw]);
            }
        }
        
    } else {
        scanset = tempScanset;
        for (CWNetwork *nw in tempScanset) {
            NSLog(@"%@", [nw ssid]);
            NSLog(@"%@", [nw bssid]);
            NSLog(@"%ld", (long)[nw rssiValue]);
            NSLog(@"%@\n\n", [self getSecurity:nw]);
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    wfc = [CWWiFiClient sharedWiFiClient];
    wif = wfc.interface;
    
    NSError *err;
    scanset = [wif scanForNetworksWithSSID:Nil error:&err];
    
    for (CWNetwork *nw in scanset) {
        NSLog(@"%@", [nw ssid]);
        NSLog(@"%@", [nw bssid]);
        NSLog(@"%ld", (long)[nw rssiValue]);
        NSLog(@"%@\n\n", [self getSecurity:nw]);
    }
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanCacheUpdatedForWiFiInterfaceWithName:) userInfo:nil repeats:YES];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
