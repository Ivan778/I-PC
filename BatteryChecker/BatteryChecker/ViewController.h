//
//  ViewController.h
//  BatteryChecker
//
//  Created by Иван on 26.09.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *powerSourceTypeLabel;
@property (weak) IBOutlet NSTextField *timeLeftLabel;
@property (weak) IBOutlet NSTextField *chargingLevelLabel;

@end

