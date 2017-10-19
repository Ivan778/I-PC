//
//  DiskVolume.h
//  USBDevicesChecker
//
//  Created by Иван on 19.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskVolume : NSObject

{
@private
    NSString *name;
    
    NSString *capacity;
    NSString *freeSpace;
}

- (id) init: (NSString*)nameS : (NSString*)capacityS : (NSString*)freeSpaceS;

- (NSString*) getName;
- (NSString*) getCapacity;
- (NSString*) getFreeSpace;

- (void) setName: (NSString*)nameS;
- (void) setCapacity: (NSString*)capacityS;
- (void) setFreeSpace: (NSString*)freeSpaceS;

@end
