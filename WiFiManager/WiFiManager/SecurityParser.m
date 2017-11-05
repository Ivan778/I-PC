//
//  SecurityParser.m
//  WiFiManager
//
//  Created by Иван on 05.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "SecurityParser.h"

@implementation SecurityParser

+ (NSString*)getSecurity:(CWNetwork*)network {
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

@end
