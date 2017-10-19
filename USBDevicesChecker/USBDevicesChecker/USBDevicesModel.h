//
//  USBDevicesModel.h
//  USBDevicesChecker
//
//  Created by Иван on 19.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceDescription.h"

@interface USBDevicesModel : NSObject

- (NSMutableString*) removeSpacesInTheBeginning:(NSMutableString*)str;

// Получение вывода команд
- (NSMutableArray*) systemProfiler;
- (NSMutableArray*) ioreg;
- (NSMutableArray*) diskutil;

// Методы для парсинга вывода команд
- (NSMutableArray*) getDeviceDescription: (NSMutableArray*)array: (NSMutableString*)name;
- (NSMutableString*) rightStringName: (NSMutableString*)str;
- (NSMutableString*) giveDiskPath: (NSMutableArray*)description;

- (NSMutableArray*) getDevicesInfo;

@end
