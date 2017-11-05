//
//  ViewController.h
//  WiFiManager
//
//  Created by Иван on 04.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreWLAN/CoreWLAN.h>

@interface ViewController : NSViewController<CWEventDelegate>

- (void)scanCacheUpdatedForWiFiInterfaceWithName:(NSString *)interfaceName;

@end

