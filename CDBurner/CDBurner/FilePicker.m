//
//  FilePicker.m
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "FilePicker.h"

@implementation FilePicker

+ (NSMutableArray*)getFilesPath: (NSArray<NSURL*>*)array {
    NSMutableArray *elems = [[NSMutableArray alloc] init];
    
    for (NSURL *url in array) {
        NSArray *arr = [url pathComponents];
        NSMutableString *filePath = [[NSMutableString alloc] init];
        
        for (NSString *str in arr) {
            [filePath appendString:str];
            [filePath appendString:@"/"];
        }
        
        [filePath deleteCharactersInRange:NSMakeRange(0, 1)];
        [filePath deleteCharactersInRange:NSMakeRange([filePath length] - 1, 1)];
        
        [elems addObject:filePath];
    }
    
    return elems;
}

+ (NSMutableArray*)getFilesName: (NSArray<NSURL*>*)array {
    NSMutableArray *elems = [[NSMutableArray alloc] init];
    
    for (NSURL *url in array) {
        [elems addObject:[url lastPathComponent]];
    }
    
    return elems;
}

@end
