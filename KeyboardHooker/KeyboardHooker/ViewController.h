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
#import "FileWriter.h"

@interface ViewController : NSViewController<NSSharingServiceDelegate>

@property KeyHooker *key;
@property MouseHooker *mouse;

@end

