//
//  VolumeSheetViewController.h
//  USBDevicesChecker
//
//  Created by Иван on 20.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DiskVolume.h"

@interface VolumeSheetViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, assign) NSMutableArray *volumes;
@property (nonatomic, strong) IBOutlet NSTableView *tableView;

@end
