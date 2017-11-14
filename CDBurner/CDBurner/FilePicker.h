//
//  FilePicker.h
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilePicker : NSObject

+(NSMutableArray*)getFilesPath: (NSArray<NSURL*>*)array;
+(NSMutableArray*)getFilesName: (NSArray<NSURL*>*)array;

@end
