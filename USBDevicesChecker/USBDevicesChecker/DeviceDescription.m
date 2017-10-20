//
//  DeviceDescription.m
//  USBDevicesChecker
//
//  Created by Иван on 19.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "DeviceDescription.h"

@implementation DeviceDescription

- (void) setDeviceName: (NSString*)name {
    deviceName = [name substringToIndex:[name length] - 2];
}

- (void) setDeviceType: (BOOL)type {
    isItDisk = type;
}

- (void) setDeviceEjectPath: (NSString*)path {
    ejectPath = path;
}

- (void) setDeviceFullCapacity: (NSString*)capacity {
    fullCapacity = capacity;
}

- (void) setVolumeInfo: (NSMutableArray*)volumesS {
    volumes = volumesS;
}

//---------------------------------------------------------

- (NSString*) getDeviceName {
    return deviceName;
}

- (BOOL) getDeviceType {
    return isItDisk;
}

- (NSString*) getDeviceEjectPath {
    return ejectPath;
}

@end
