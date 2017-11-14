//
//  FilePathManager.m
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "FilePathManager.h"

@implementation FilePathManager

+(NSString*)pathToDesktop {
    return [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(NSString*)pathToCDImage: (NSString*)fileName {
    return [NSString stringWithFormat:@"/%@/%@/%@", [self pathToDesktop], @"to_burn", fileName];
}

+(NSString*)pathToFolder {
    return [NSString stringWithFormat:@"/%@/%@", [self pathToDesktop], @"to_burn"];
}

@end
