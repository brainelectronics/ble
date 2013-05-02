//
//  ViewController.h
//  BLE
//
//  Created by Jonas Scharpf on 25.04.13.
//  Copyright (c) 2013 Jonas Scharpf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

@interface ViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    UIImageView *tableImage;
    
    NSArray *arrayOfDiscoveredDevices;
    NSString *deviceName;
    NSString *serviceName;
    
    int connectedPeripheral;
}
@property (strong, nonatomic) CBCentralManager *CM;
@property (strong, nonatomic) CBPeripheral *activePeripheral;

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) UIImageView *tableImage;

@property (retain, nonatomic) IBOutlet UILabel *connectedToLabel;
@property (retain, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *withServiceLabel;
@property (retain, nonatomic) IBOutlet UILabel *receivedDataLabel;
@property (retain, nonatomic) IBOutlet UILabel *errorLabel;
@property (retain, nonatomic) IBOutlet UIButton *sendHelloButton;

- (IBAction)searchBTDevices:(id)sender;
- (IBAction)sendHello:(id)sender;


@end
