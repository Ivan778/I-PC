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
#import "FileNamesManager.h"
#import "CDFolderManager.h"
#import "InsertedDiscManager.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (weak) IBOutlet NSButton *writeToDiscButton;
@property (weak) IBOutlet NSButton *addFilesButton;
@property (weak) IBOutlet NSButton *eraseDiscButton;
@property (weak) IBOutlet NSButton *deleteButton;

@end

