//
//  MouseHooker.m
//  KeyboardHooker
//
//  Created by Иван on 24.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "MouseHooker.h"

@implementation MouseHooker

- (void)setMouseNotifications {
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^(NSEvent *event) { [self leftClick]; }];
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSRightMouseDownMask handler:^(NSEvent *event) { [self rightClick]; }];
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSOtherMouseDownMask handler:^(NSEvent *event) { [self otherClick]; }];
    
    [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^NSEvent* (NSEvent* event){ [self leftClick]; return event; }];
    [NSEvent addLocalMonitorForEventsMatchingMask:NSRightMouseDownMask handler:^NSEvent* (NSEvent* event){ [self rightClick]; return event; }];
    [NSEvent addLocalMonitorForEventsMatchingMask:NSOtherMouseDownMask handler:^NSEvent* (NSEvent* event){ [self otherClick]; return event; }];
}

- (void)leftClick {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    
    NSString *x = [NSString stringWithFormat:@"%.0f", mouseLoc.x];
    NSString *y = [NSString stringWithFormat:@"%.0f", mouseLoc.y];
    
    [FileManager writeToFile:@"buttons" file:[NSString stringWithFormat:@"L: (%-5s; %-4s) at %@\n", [x UTF8String], [y UTF8String], [Time currentTime]]];
}

- (void)rightClick {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    
    NSString *x = [NSString stringWithFormat:@"%.0f", mouseLoc.x];
    NSString *y = [NSString stringWithFormat:@"%.0f", mouseLoc.y];
    
    [FileManager writeToFile:@"buttons" file:[NSString stringWithFormat:@"R: (%-5s; %-4s) at %@\n", [x UTF8String], [y UTF8String], [Time currentTime]]];
}

- (void)otherClick {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    
    NSString *x = [NSString stringWithFormat:@"%.0f", mouseLoc.x];
    NSString *y = [NSString stringWithFormat:@"%.0f", mouseLoc.y];
    
    [FileManager writeToFile:@"buttons" file:[NSString stringWithFormat:@"O: (%-5s; %-4s) at %@\n", [x UTF8String], [y UTF8String], [Time currentTime]]];
}

@end
