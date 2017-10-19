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
    deviceName = name;
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

- (void) setDeviceFreeSpace: (NSString*)fS {
    freeSpace = fS;
}

- (void) addVolumeInfo: (DiskVolume*)volume {
    [volumes addObject:volume];
}

//---------------------------------------------------------



@end
