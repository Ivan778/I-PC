//
//  DeviceDescription.h
//  USBDevicesChecker
//
//  Created by Иван on 19.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDescription : NSObject

{
@private
    NSString *deviceName;
    
    BOOL isItDisk;
    NSString *ejectPath;
    NSString *fullCapacity;
    NSString *freeSpace;
    
    NSMutableArray *volumes;
}

- (void) setDeviceName: (NSString*)name;
- (void) setDeviceType: (BOOL)type;
- (void) setDeviceEjectPath: (NSString*)path;

- (void) setDeviceFullCapacity: (NSString*)capacity;
- (void) setDeviceFreeSpace: (NSString*)freeSpace;

- (void) addVolumeInfo: (NSMutableDictionary*)volume;

@end
