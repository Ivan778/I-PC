//
//  ViewController.h
//  BatteryChecker
//
//  Created by Иван on 26.09.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "BatteryStatus.h"

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *powerSourceTypeLabel;
@property (weak) IBOutlet NSTextField *timeLeftLabel;
@property (weak) IBOutlet NSTextField *chargingLevelLabel;
@property (weak) IBOutlet NSLevelIndicator *BatteryLevelIndicatorCell;
@property (weak) IBOutlet NSTextField *TimeTillDecreaseBrightness;
@property (weak) IBOutlet NSSlider *SelectTillDecreaseBrightnessSlider;

@end

