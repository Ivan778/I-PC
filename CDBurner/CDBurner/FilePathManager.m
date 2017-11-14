//
//  FilePathManager.m
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "FilePathManager.h"

@implementation FilePathManager

+(NSString*)pathToCDImage: (NSString*)fileName {
    return [NSString stringWithFormat:@"/%@/%@/%@", [[[NSFileManager alloc] init] currentDirectoryPath], @"to_burn",fileName];
}

@end
