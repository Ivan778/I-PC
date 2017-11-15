//
//  FileNamesManager.m
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "FileNamesManager.h"

@implementation FileNamesManager

+ (NSMutableArray*)addFileNames: (NSMutableArray*)final : (NSArray*)newFiles {
    for (NSString *str in newFiles) {
        if ([final containsObject:str] == NO) {
            [final addObject:str];
        } else {
            BOOL flag = YES;
            NSString *fileName = [NSString stringWithString:str];
            
            while (flag) {
                int i;
                for (i = (int)[fileName length] - 1; i >= 0; i--) {
                    if ([fileName characterAtIndex:i] == '.') {
                        break;
                    }
                }
                
                NSString *name = [fileName substringToIndex:i];
                NSString *extension = [fileName substringFromIndex:i+1];
                
                name = [name stringByAppendingString:@" (new)"];
                
                fileName = [[name stringByAppendingString:@"."] stringByAppendingString:extension];
                
                if ([final containsObject:fileName] == NO) {
                    [final addObject:fileName];
                    flag = NO;
                }
            }
        }
    }
    
    return final;
}

@end
