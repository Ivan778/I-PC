//
//  CDFolderManager.h
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilePathManager.h"

@interface CDFolderManager : NSObject

+ (void)eraseBurnFolder;
+ (void)createFolderToBurn: (NSMutableArray*)filesName : (NSMutableArray*)filesPath;

@end
