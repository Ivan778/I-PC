//
//  InsertedDiscManager.m
//  CDBurner
//
//  Created by Иван on 14.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "InsertedDiscManager.h"

@implementation InsertedDiscManager

+ (int)getAmountOfBlocks {
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen("drutil status", "r");
    if (fp == NULL) {
        printf("Failed to run command\n" );
        exit(1);
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *str = [[NSString alloc] init];
    
    // Читаем вывод команды
    while (fgets(path, sizeof(path)-1, fp) != NULL) {
        str = [NSString stringWithUTF8String:path];
        [data addObject:str];
    }
    
    // Закрываем файл
    pclose(fp);
    
    NSMutableString *blocks = [NSMutableString stringWithFormat:@""];
    
    BOOL flag = NO;
    for (NSString *temp in data) {
        if ([temp containsString:@"Space Free:"] == YES) {
            NSRange range1 = [temp rangeOfString:@"blocks:"];
            int beg = (int)range1.location + (int)range1.length;
            
            NSRange range2 = [temp rangeOfString:@"/"];
            int fin = (int)range2.location;
            
            for (int i = beg; i < fin; i++) {
                if ([temp characterAtIndex:i] >= '0' && [temp characterAtIndex:i] <= '9') {
                    [blocks appendString:[NSString stringWithFormat:@"%c", [temp characterAtIndex:i]]];
                }
            }
        }
        
        if ([temp containsString:@"Space Used:"] == YES && [temp containsString:@"0.00MB"] == YES) {
            flag = YES;
        }
    }
    
    if (flag == YES) {
        return [blocks intValue];
    } else {
        return -1;
    }
}

+ (int)getFileBlocksAmount {
    FILE *fp;
    char path[1035];
    
    // Команда для чтения
    fp = popen("drutil size -allfs ~/Desktop/to_burn", "r");
    if (fp == NULL) {
        printf("Failed to run command\n" );
        exit(1);
    }
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *str = [[NSString alloc] init];
    
    // Читаем вывод команды
    while (fgets(path, sizeof(path)-1, fp) != NULL) {
        str = [NSString stringWithUTF8String:path];
        [data addObject:str];
    }
    
    // Закрываем файл
    pclose(fp);
    
    NSMutableString *blocks = [NSMutableString stringWithFormat:@""];
    
    BOOL flag = NO;
    for (NSString *temp in data) {
        if ([temp containsString:@"Blocks needed:"] == YES) {
            NSRange range1 = [temp rangeOfString:@":"];
            int beg = (int)range1.location + (int)range1.length;
            
            NSRange range2 = [temp rangeOfString:@"/"];
            int fin = (int)range2.location;
            
            for (int i = beg; i < fin; i++) {
                if ([temp characterAtIndex:i] >= '0' && [temp characterAtIndex:i] <= '9') {
                    [blocks appendString:[NSString stringWithFormat:@"%c", [temp characterAtIndex:i]]];
                }
            }
        }
    }
    
    return [blocks intValue];
}

@end
