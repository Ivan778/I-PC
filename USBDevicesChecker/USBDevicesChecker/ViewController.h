//
//  ViewController.h
//  USBDevicesChecker
//
//  Created by Иван on 05.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "USBDevicesModel.h"
#import "VolumeSheetViewController.h"

@interface ViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *EjectDeviceButton;
@property (weak) IBOutlet NSButton *moreInfoButton;

@end

