//
//  ViewController.m
//  WiFiManager
//
//  Created by Иван on 04.11.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

#import "ViewController.h"
#import <CoreWLAN/CoreWLAN.h>
#import "SecurityParser.h"

@implementation ViewController

{
    CWWiFiClient *wfc;
    CWInterface *wif;
    NSSet *scanset;
    NSArray *items;
    
    CWNetwork *networkToConnect;
}

- (NSString*)currentConnection {
    CWInterface *cur = [CWInterface interface];
    return [cur ssid];
}

- (void)scanCacheUpdatedForWiFiInterfaceWithName:(NSTimer*)theTimer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *network = [self currentConnection];
            if (network != nil) {
                [_currentConnectionLabel setStringValue: network];
            } else {
                [_currentConnectionLabel setStringValue: @"-//-"];
            }
        });
        
        CWInterface *tempWif = wfc.interface;
        
        NSError *err;
        NSSet *tempScanset = [tempWif scanForNetworksWithSSID:Nil error:&err];
        
        if (err != nil) {
            NSLog(@"%@", err);
        }
        
        if ([scanset count] == [tempScanset count]) {
            NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[scanset allObjects]];
            NSMutableArray *arr2 = [NSMutableArray arrayWithArray:[tempScanset allObjects]];
            
            [arr2 removeObjectsInArray:arr1];
            
            if ([arr2 count] > 0) {
                scanset = tempScanset;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }
            
        } else {
            scanset = tempScanset;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
    });
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"WiFiName" owner:self];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[scanset allObjects]];
    
    if ([tableColumn.identifier isEqualToString:@"WiFiName"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        NSString *str = [arr[row] ssid];
        if (str != nil) {
            [[cellView textField] setStringValue:str];
        } else {
            [[cellView textField] setStringValue:@"-"];
        }
        
        
    } else if ([tableColumn.identifier isEqualToString:@"MAC"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        NSString *str = [arr[row] bssid];
        if (str != nil) {
            [[cellView textField] setStringValue:str];
        } else {
            [[cellView textField] setStringValue:@"-"];
        }
        
    } else if ([tableColumn.identifier isEqualToString:@"SignalPower"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%ld", (long)[arr[row] rssiValue]];
        if (str != nil) {
            [str appendString:@" dBm"];
            [[cellView textField] setStringValue:str];
        } else {
            [[cellView textField] setStringValue:@"-"];
        }
        
    } else if ([tableColumn.identifier isEqualToString:@"Security"]) {
        
        cellView = [tableView makeViewWithIdentifier:@"str" owner:self];
        [[cellView textField] setStringValue:[SecurityParser getSecurity:arr[row]]];
        
    }
    
    return cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [scanset count];
}

// Отслеживает выбранные строки в таблице и активирует/деактивирует кнопки в соответствие с параметрами выбранного устройства
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [notification.object selectedRow];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[scanset allObjects]];
    
    if (row >= 0) {
        networkToConnect = arr[row];
        [_nameTextField setStringValue:[networkToConnect ssid]];
        [_MACAdressTextField setStringValue:[networkToConnect bssid]];
    }
}

// Создаёт Alert
- (NSAlert*)createAlert:(NSString*)message : (NSString*)moreInfo {
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setInformativeText:moreInfo];
    [alert setAlertStyle:NSWarningAlertStyle];
    
    return alert;
}

- (IBAction)clickedConnectButton:(id)sender {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[scanset allObjects]];
    BOOL foundNetwork = NO;
    
    [_connectButton setEnabled:NO];
    
    // Если на сети стоит какая-либо защита и нет введённого в поле пароля
    if ([networkToConnect supportsSecurity:0] == NO && [[_passwordTextField stringValue] length] < 8) {
        // Выводим пользователю соответствующее сообщение
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAlert *alert = [self createAlert:@"Введите пароль" :@"Для данной сети требуется пароль."];
            [alert runModal];
            
            [_connectButton setEnabled:YES];
        });
    }
    
    // Если на сети нет защиты
    if ([networkToConnect supportsSecurity:0] == YES) {
        for (CWNetwork *net in arr) {
            if ([net.bssid isEqualToString:[networkToConnect bssid]]) {
                foundNetwork = YES;
                break;
            }
        }
        
        if (foundNetwork == YES) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *err;
                [wif associateToNetwork:networkToConnect password:@"" error:&err];
                if (err != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSAlert *alert = [self createAlert:@"Фиаско" :@"Во время подключения к сети пошло что-то не так."];
                        [alert runModal];
                        
                        [_connectButton setEnabled:YES];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSAlert *alert = [self createAlert:@"Успех" :@"Аутентификация прошла успешно."];
                        [alert runModal];
                        
                        [_connectButton setEnabled:YES];
                    });
                }
            });
        }
    }
    
    if ([networkToConnect supportsSecurity:0] == NO && [[_passwordTextField stringValue] length] >= 8) {
        for (CWNetwork *net in arr) {
            if ([net.bssid isEqualToString:[networkToConnect bssid]]) {
                foundNetwork = YES;
                break;
            }
        }
        
        if (foundNetwork == YES) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *err;
                [wif associateToNetwork:networkToConnect password:[_passwordTextField stringValue] error:&err];
                if (err != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSAlert *alert = [self createAlert:@"Фиаско" :@"Во время подключения к сети пошло что-то не так."];
                        [alert runModal];
                        
                        [_connectButton setEnabled:YES];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSAlert *alert = [self createAlert:@"Успех" :@"Аутентификация прошла успешно."];
                        [alert runModal];
                        
                        [_connectButton setEnabled:YES];
                    });
                }
            });
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkToConnect = [[CWNetwork alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        wfc = [CWWiFiClient sharedWiFiClient];
        wif = wfc.interface;
        
        NSError *err;
        scanset = [wif scanForNetworksWithSSID:Nil error:&err];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
    [_tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    items = @[@"5", @"10", @"15"];
    
    [_amountComboBox addItemsWithObjectValues:items];
    [_amountComboBox selectItemAtIndex:0];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanCacheUpdatedForWiFiInterfaceWithName:) userInfo:nil repeats:YES];
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] compare:@"ConsoleOutput"] == NSOrderedSame) {
        ConsoleOutputViewController *vc = [segue destinationController];
        vc.address = [_addressTextField stringValue];
        vc.amount = items[[_amountComboBox indexOfSelectedItem]];
    }
}

@end
