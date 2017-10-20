//
//  DeviceDescription.h
//  USBDevicesChecker
//
//  Created by Иван on 19.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiskVolume.h"

@interface DeviceDescription : NSObject

{
@private
    NSString *deviceName;
    NSString *serialNumber;
    
    BOOL isItDisk;
    BOOL wasItEjected;
    NSString *ejectPath;
    NSString *fullCapacity;
    NSString *ejectStatus;
    
    NSMutableArray *volumes;
}

- (void) setDeviceName: (NSString*)name;
- (void) setDeviceSerialNumber: (NSString*)serialNumberS;
- (void) setDeviceType: (BOOL)type;
- (void) setWasItEjected: (BOOL)answer;
- (void) setDeviceEjectPath: (NSString*)path;
- (void) setDeviceFullCapacity: (NSString*)capacity;
- (void) setEjectStatus: (NSString*)status;
- (void) setVolumeInfo: (NSMutableArray*)volumeS;

- (NSString*) getDeviceName;
- (BOOL) getDeviceType;
- (BOOL) getWasItEjected;
- (NSString*) getDeviceEjectPath;
- (NSString*) getDeviceFullCapacity;
- (NSString*) getEjectStatus;
- (NSMutableArray*) getVolumeInfo;
- (NSString*) getDeviceSerialNumber;

@end
