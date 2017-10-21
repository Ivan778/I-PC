//
//  DiskVolume.m
//  USBDevicesChecker
//
//  Created by Иван on 19.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "DiskVolume.h"

@implementation DiskVolume

- (id) init: (NSString*)nameS : (NSString*)capacityS : (NSString*) freeSpaceS {
    self = [super init];
    if(self) {
        name = nameS;
        capacity = capacityS;
        freeSpace = freeSpaceS;
    }
    
    return self;
}

- (NSString*) getName {
    return name;
}

- (NSString*) getCapacity {
    return capacity;
}

- (NSString*) getFreeSpace {
    return freeSpace;
}

- (NSString*) getUsedSpace {
    return usedSpace;
}

- (void) setName: (NSString*)nameS {
    name = nameS;
}

- (void) setCapacity: (NSString*)capacityS {
    capacity = capacityS;
}

- (void) setFreeSpace: (NSString*)freeSpaceS {
    freeSpace = freeSpaceS;
}

- (void) setUsedSpace: (NSString*)UsedSpaceS {
    usedSpace = UsedSpaceS;
}

@end
