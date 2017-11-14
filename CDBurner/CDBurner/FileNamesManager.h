//
//  FileNamesManager.h
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileNamesManager : NSObject

+(NSMutableArray*)addFileNames: (NSMutableArray*)finalArray : (NSArray*)newFilesArray;

@end
