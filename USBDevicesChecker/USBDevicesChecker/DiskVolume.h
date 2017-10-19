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

- (id) init: (NSString*)name : (NSString*)capacity : (NSString*) freeSpace;

- (NSString*) getName;
- (NSString*) getCapacity;
- (NSString*) getFreeSpace;

@end
