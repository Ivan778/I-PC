//
//  ConsoleOutputViewController.h
//  WiFiManager
//
//  Created by Иван on 05.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConsoleOutputViewController : NSViewController

@property (nonatomic, assign) NSString *address;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end
