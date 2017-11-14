//
//  FilePathManager.h
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePathManager : NSObject

+(NSString*)pathToCDImage: (NSString*)fileName;
+(NSString*)pathToFolder;

@end
