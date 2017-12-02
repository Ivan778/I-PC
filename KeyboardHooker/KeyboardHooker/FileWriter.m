//
//  FileWriter.m
//  KeyboardHooker
//
//  Created by Иван on 01.12.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "FileWriter.h"

@implementation FileWriter

+ (NSString*)pathToDesktop {
    return [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString*)pathToFile {
    return [NSString stringWithFormat:@"%@/Documents/keyHooks", [[[NSProcessInfo processInfo] environment] objectForKey:@"HOME"]];
}

+ (void)createFile: (NSString*)name {
    NSLog(@"%@", [self pathToFile]);
    [[NSFileManager defaultManager] createFileAtPath:[self pathToFile] contents:nil attributes:nil];
}

@end
