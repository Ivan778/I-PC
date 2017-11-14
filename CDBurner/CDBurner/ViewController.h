//
//  ViewController.h
//  CDBurner
//
//  Created by Иван on 06.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DiscRecording/DiscRecording.h>
#import <DiscRecordingUI/DiscRecordingUI.h>
#import "FilePicker.h"
#import "FilePathManager.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTableView *tableView;

@end

