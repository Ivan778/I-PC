//
//  FileWriter.h
//  KeyboardHooker
//
//  Created by Иван on 01.12.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileWriter : NSObject

+ (void)createFile: (NSString*)name;
+ (void)writeToFile: (NSString*)name file:(NSString*)stringToWrite;
+ (void)clearFile: (NSString*)name;

@end
