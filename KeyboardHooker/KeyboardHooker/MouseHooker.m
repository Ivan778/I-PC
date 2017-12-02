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
    NSLog(@"Left: (%f;%f) at %@", mouseLoc.x, mouseLoc.y, [Time currentTime]);
    
    [FileManager writeToFile:@"buttons" file:[NSString stringWithFormat:@"Left: (%f;%f) - %@\n", mouseLoc.x, mouseLoc.y, [Time currentTime]]];
}

- (void)rightClick {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    NSLog(@"Right: (%f;%f) at %@", mouseLoc.x, mouseLoc.y, [Time currentTime]);
    
    [FileManager writeToFile:@"buttons" file:[NSString stringWithFormat:@"Right: (%f;%f) - %@\n", mouseLoc.x, mouseLoc.y, [Time currentTime]]];
}

- (void)otherClick {
    NSPoint mouseLoc = [NSEvent mouseLocation];
    NSLog(@"Other: (%f;%f) at %@", mouseLoc.x, mouseLoc.y, [Time currentTime]);
    
    [FileManager writeToFile:@"buttons" file:[NSString stringWithFormat:@"Other: (%f;%f) - %@\n", mouseLoc.x, mouseLoc.y, [Time currentTime]]];
}

@end
