//
//  ViewController.m
//  USBDevicesChecker
//
//  Created by Иван on 05.10.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import <IOKit/IOKitLib.h>
#import <IOKit/usb/IOUSBLib.h>
#include <IOKit/serial/IOSerialKeys.h>

@implementation ViewController

void SerialDeviceWasAddedFunction(void *refcon, io_iterator_t iterator) {
    NSLog(@"Hello");
}

void SerialPortWasRemovedFunction(void *refcon, io_iterator_t iterator) {
    NSLog(@"Bye");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    IONotificationPortRef notificationPort = IONotificationPortCreate(kIOMasterPortDefault);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(notificationPort), kCFRunLoopDefaultMode);
    
    CFMutableDictionaryRef matchingDict = IOServiceMatching(kIOSerialBSDServiceValue);
    CFRetain(matchingDict); // Need to use it twice and IOServiceAddMatchingNotification() consumes a reference
    
    CFDictionaryAddValue(matchingDict, CFSTR(kIOSerialBSDTypeKey), CFSTR(kIOSerialBSDRS232Type));
    
    io_iterator_t portIterator = 0;
    // Register for notifications when a serial port is added to the system
    kern_return_t result = IOServiceAddMatchingNotification(notificationPort, kIOPublishNotification, matchingDict, SerialDeviceWasAddedFunction, (__bridge void *)(self), &portIterator);
    while (IOIteratorNext(portIterator)) {}; // Run out the iterator or notifications won't start (you can also use it to iterate the available devices).
    
    // Also register for removal notifications
    IONotificationPortRef terminationNotificationPort = IONotificationPortCreate(kIOMasterPortDefault);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), IONotificationPortGetRunLoopSource(terminationNotificationPort), kCFRunLoopDefaultMode);
    result = IOServiceAddMatchingNotification(terminationNotificationPort, kIOTerminatedNotification, matchingDict, SerialPortWasRemovedFunction, (__bridge void *)(self), &portIterator);
    CFRelease(IONotificationPortGetRunLoopSource(terminationNotificationPort));
    
    while (IOIteratorNext(portIterator)) {}; // Run out the iterator or notifications won't start (you can also use it to iterate the available devices).
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
