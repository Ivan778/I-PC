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

- (void) setDeviceSerialNumber: (NSString*)serialNumberS {
    serialNumber = serialNumberS;
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

- (void) setEjectStatus: (NSString*)status {
    ejectStatus = status;
}

- (void) setWasItEjected: (BOOL)answer {
    wasItEjected = answer;
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

- (NSString*) getDeviceSerialNumber {
    return serialNumber;
}

- (NSString*) getDeviceFullCapacity {
    return fullCapacity;
}

- (NSMutableArray*) getVolumeInfo {
    return volumes;
}

- (NSString*) getEjectStatus {
    return ejectStatus;
}

- (BOOL) getWasItEjected {
    return wasItEjected;
}

@end
