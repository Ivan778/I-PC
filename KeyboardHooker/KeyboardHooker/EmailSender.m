//
//  EmailSender.m
//  KeyboardHooker
//
//  Created by Иван on 01.12.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "EmailSender.h"

@implementation EmailSender

+ (void)sendEmailWithMail: (NSString *) toAddress withSubject: (NSString *) subject Attachments: (NSArray *) attachments {
    NSString *bodyText = @"Your body text \n\r";
    NSString *emailString = [NSString stringWithFormat:@"\
                             tell application \"Mail\"\n\
                             set newMessage to make new outgoing message with properties {subject:\"%@\", content:\"%@\" & return} \n\
                             tell newMessage\n\
                             set visible to false\n\
                             set sender to \"%@\"\n\
                             make new to recipient at end of to recipients with properties {name:\"%@\", address:\"%@\"}\n\
                             tell content\n\
                             ",subject, bodyText, @"McAlarm alert", @"McAlarm User", toAddress ];
    
    //add attachments to script
    for (NSString *alarmPhoto in attachments) {
        emailString = [emailString stringByAppendingFormat:@"make new attachment with properties {file name:\"%@\"} at after the last paragraph\n\
                       ",alarmPhoto];
        
    }
    //finish script
    emailString = [emailString stringByAppendingFormat:@"\
                   end tell\n\
                   send\n\
                   end tell\n\
                   end tell"];
    
    
    
    //NSLog(@"%@",emailString);
    NSAppleScript *emailScript = [[NSAppleScript alloc] initWithSource:emailString];
    [emailScript executeAndReturnError:nil];
    
    /* send the message */
    NSLog(@"Message passed to Mail");
}

@end
