//
//  SecurityParser.h
//  WiFiManager
//
//  Created by Иван on 05.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

@interface SecurityParser : NSObject

+ (NSString*)getSecurity:(CWNetwork*)network;

@end
