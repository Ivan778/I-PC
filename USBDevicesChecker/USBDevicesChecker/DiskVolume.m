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

@end
