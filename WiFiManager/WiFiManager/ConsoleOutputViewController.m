//
//  ConsoleOutputViewController.m
//  WiFiManager
//
//  Created by Иван on 05.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ConsoleOutputViewController.h"

@interface ConsoleOutputViewController ()

@end

@implementation ConsoleOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_textView setEditable:NO];
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"ping -c 5 "];
    [str appendString:[self address]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FILE *fp;
        char path[1035];
        
        // Команда для чтения
        fp = popen([str UTF8String], "r");
        if (fp == NULL) {
            printf("Failed to run command\n" );
            exit(1);
        }
        
        // Читаем вывод команды
        while (fgets(path, sizeof(path)-1, fp) != NULL) {
            NSAttributedString* attr = [[NSAttributedString alloc] initWithString:[NSString stringWithUTF8String:path]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[_textView textStorage] appendAttributedString:attr];
            });
            
        }
        
        // Закрываем файл
        pclose(fp);
    });
    
}

@end
