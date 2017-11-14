//
//  CDFolderManager.m
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "CDFolderManager.h"

@implementation CDFolderManager

+(void)eraseBurnFolder {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    
    [manager removeItemAtPath:[FilePathManager pathToFolder] error:&error];
    if (error) NSLog(@"%@", error);
}

+(void)createFolderToBurn: (NSMutableArray*)filesName : (NSMutableArray*)filesPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    
    [manager createDirectoryAtPath:[FilePathManager pathToFolder] withIntermediateDirectories:NO attributes:nil error:&error];
    if (error) NSLog(@"%@", error);
    
    for (int i = 0; i < [filesName count]; i++) {
        [manager copyItemAtPath:filesPath[i] toPath:[FilePathManager pathToCDImage:filesName[i]] error:&error];
        if (error) NSLog(@"%@", error);
    }
}

@end
