//
//  ViewController.m
//  BLE
//
//  Created by Jonas Scharpf on 25.04.13.
//  Copyright (c) 2013 Jonas Scharpf. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize CM;
@synthesize activePeripheral;
@synthesize myTableView;
@synthesize tableImage;
@synthesize connectedToLabel;
@synthesize deviceNameLabel;
@synthesize withServiceLabel;
@synthesize receivedDataLabel;
@synthesize errorLabel;
@synthesize sendHelloButton;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [sendHelloButton setHidden:YES];
    /*
    connectedToLabel.text = nil;
    deviceNameLabel.text = nil;
    withServiceLabel.text = nil;
    receivedDataLabel.text = nil;
    errorLabel.text = nil;
     */
    /*
    CGRect tablePosition = CGRectMake(0.0, 0.0, self.view.frame.size.width, 100.0);
    UITableView *discoveredBLEDevices = [[UITableView alloc] initWithFrame:tablePosition style:UITableViewStylePlain];
    self.myTableView = discoveredBLEDevices;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //CGRect button = CGRectMake(20.0, 110.0, 73.0, 43.0);
    [self.view addSubview:discoveredBLEDevices];
    
    [discoveredBLEDevices release];
    */
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfDiscoveredDevices count];
    //return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    //UIImage *btImage = [[UIImage imageNamed:@"Bluetooth-1.png"]autorelease];
    //UIImage	 *btImage = [[UIImage imageNamed:@"stop-32.png"]autorelease];
    
    UIImage	 *lostImage = [[UIImage imageNamed:@"stop-32.png"]autorelease];
		
	CGRect imageFrame = CGRectMake(2, 8, 40, 40);
	self.tableImage = [[[UIImageView alloc] initWithFrame:imageFrame] autorelease];
	self.tableImage.image = lostImage;
	[cell.contentView addSubview:self.tableImage];
    /*
    CGRect imageFrame = CGRectMake(2, 8, 40, 40);
    tableImage = [[[UIImageView alloc] initWithFrame:imageFrame]autorelease];
    tableImage.image = btImage;
    [cell.contentView addSubview:tableImage];
    */
    CGRect nameFrame = CGRectMake(45, 7, 265, 20);
    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:nameFrame] autorelease];
    nameLabel.numberOfLines = 2;
    nameLabel.font = [UIFont boldSystemFontOfSize:12];
    nameLabel.text = deviceName;
    [cell.contentView addSubview:nameLabel];
    
    CGRect serviceFrame = CGRectMake(115.0, 7.0, 195.0, 20.0);
    UILabel *serviceLabel = [[[UILabel alloc] initWithFrame:serviceFrame] autorelease];
    serviceLabel.numberOfLines = 2;
    serviceLabel.font = [UIFont boldSystemFontOfSize:12];
    serviceLabel.text = serviceName;
    [cell.contentView addSubview:serviceLabel];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    connectedPeripheral = indexPath.row;
    NSLog(@"did select row: %d", connectedPeripheral);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [CM connectPeripheral:[arrayOfDiscoveredDevices objectAtIndex:connectedPeripheral] options:nil];
    NSLog(@"Connect to Peripheral %d", connectedPeripheral);
}



/*
-(id)init
{
    if (self = [super init])
    {
        CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}
*/
#pragma mark - CentralManager
//List all Dicovered Periperals
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Received peripheral: %@", peripheral);
    NSLog(@"Ad data: %@", advertisementData);
    
    /*
     NSMutableArray *peripherals = [self mutableArrayValueForKey:@"heartRateMonitors"];
     if( ![self.heartRateMonitors containsObject:aPeripheral] )
     [peripherals addObject:aPeripheral];
     
     // Retreive already known devices
     if(autoConnect)
     {
     [manager retrievePeripherals:[NSArray arrayWithObject:(id)aPeripheral.UUID]];
     }
     */
}

//Connectet to a peripheral
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"BLE Device %@ connected", peripheral);
    connectedToLabel.text = [NSString stringWithFormat:@"%@", peripheral];
    [sendHelloButton setHidden:NO];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"BLE Device %@ disconnected", peripheral);
    UIAlertView *bleDisconnected = [[UIAlertView alloc]initWithTitle:@"Device disconnected" message:@"The connected device has been disconnected" delegate:nil cancelButtonTitle:@"Shit" otherButtonTitles: nil];
    [bleDisconnected show]; //Zeigt den UIAlert
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did fail to connect with %@ because of %@", peripheral, error);
    connectedToLabel.text = [NSString stringWithFormat:@"%@", peripheral];
    errorLabel.text = [NSString stringWithFormat:@"%@", error];
}

/*
-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
     //[CB connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}
*/

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved %d peripherals: %@", [peripherals count], peripherals);
    arrayOfDiscoveredDevices = peripherals;
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self doesSupportLowEnergy];
    //NSLog(@"Central Manager Did Update State");
}

//Peripheral Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *aService in peripheral.services)
    {
        serviceName = [[NSString alloc] initWithFormat:@"%@",aService.UUID];
        //NSLog(@"Service found with UUID: %@", aService.UUID);
        NSLog(@"Service found with UUID: %@", serviceName);
        withServiceLabel.text = serviceName;
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

//Received Data
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Received Data: %@",characteristic.value);
    NSLog(@"As UTF8 string: %@", [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
    NSLog(@"As ASCII: %@", [[NSString alloc]initWithData:characteristic.value encoding:NSASCIIStringEncoding]);
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
    {
        deviceName = [[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"Device Name: %@", deviceName);
        deviceNameLabel.text = deviceName;
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Did write value for CHARACTERISTIC %@ with error: %@", characteristic, error);
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"Did write Value for DESCRIPTOR");
}

-(BOOL) doesSupportLowEnergy
{
    NSString *state = [[NSString alloc] init];
    
    switch ([CM state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"No support for Bluetooth 4.0";
            errorLabel.text = state;
            break;
        
        case CBCentralManagerStateUnauthorized:
            state = @"Not allowed to use Bluetooth";
            errorLabel.text = state;
            break;
        
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is off";
            errorLabel.text = state;
            break;
            
        case CBCentralManagerStatePoweredOn:
            return TRUE;
            
        case CBCentralManagerStateUnknown:
            state = @"Unknown state";
            errorLabel.text = state;
            return FALSE;
            
        default:
            return FALSE;
    }
    
    NSLog(@"Central manager state: %@", state);
    
    return FALSE;
}
/*
-(int)scanForPeripherals
{
    if (self->CM.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"CoreBluetooth is %d", CM.state);//[self centralManagerStateToString:self.CM.state]);
        return -1;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.CM scanForPeripheralsWithServices:nil options:options];
    return 0;
}
*/

- (IBAction)searchBTDevices:(id)sender
{
    if (CM.state != CBCentralManagerStatePoweredOn)
    {
        NSLog(@"Bluetooth is off");
    }
    else
    {
        NSLog(@"Bluetooth is %d", CM.state);
    }
    
    [self.CM scanForPeripheralsWithServices:nil options:nil];
    
    CGRect tablePosition = CGRectMake(0.0, 0.0, self.view.frame.size.width, 100.0);
    UITableView *discoveredBLEDevices = [[UITableView alloc] initWithFrame:tablePosition style:UITableViewStylePlain];
    self.myTableView = discoveredBLEDevices;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //CGRect button = CGRectMake(20.0, 110.0, 73.0, 43.0);
    [self.view addSubview:discoveredBLEDevices];
    
    [discoveredBLEDevices release];
    
}

- (IBAction)sendHello:(id)sender
{
    NSString *stringToSend = @"Hello";
    NSData *data = [stringToSend dataUsingEncoding:NSUTF8StringEncoding];
    [[arrayOfDiscoveredDevices objectAtIndex:connectedPeripheral] updateValue:data forCharacteristic:[arrayOfDiscoveredDevices objectAtIndex:connectedPeripheral] onSubscribedCentrals:nil];
}

- (void)dealloc
{
    [connectedToLabel release];
    [withServiceLabel release];
    [receivedDataLabel release];
    [errorLabel release];
    [deviceNameLabel release];
    [sendHelloButton release];
    [super dealloc];
}
@end
