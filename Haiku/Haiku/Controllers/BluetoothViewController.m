//
//  BluetoothViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/23/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "BluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "HaikuCommunication.h"
#import "CentralManager.h"

@interface BluetoothViewController () <CentralManagerProtocol>

@property (nonatomic, strong) NSMutableArray *devices;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.devices = [[NSMutableArray alloc] init];

	[HaikuCommunication scanBluetoothDevicesWithCentralDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLE_CELL" forIndexPath:indexPath];
	
	CBPeripheral *peripheral = [self.devices objectAtIndex:indexPath.row];

	cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", [peripheral name], peripheral.identifier.UUIDString];
	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CBPeripheral *peripheral = [self.devices objectAtIndex:indexPath.row];
	[HaikuCommunication connectOnPeripheral:peripheral];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CentralManagerProtocol

- (void)central:(CentralManager *)central didConnectOn:(CBPeripheral *)device {
	NSLog(@"ON EST CONNECTEY: %@", device);
}

- (void)central:(CentralManager *)central didDiscoverPeripheral:(CBPeripheral *)device {
	if ([self.devices containsObject:device]) {
		[self.devices removeObject:device];
	}
	[self.devices addObject:device];
	[self.tableView reloadData];
}

- (void)central:(CentralManager *)central didFailConnectOn:(CBPeripheral *)device {
	NSLog(@"ON A FAIL DE SE CONNECTEY: %@", device);

}

- (void)central:(CentralManager *)central didDisconnectOn:(CBPeripheral *)device {
	NSLog(@"ON EST DECONNECTEY DE : %@", device);
}

@end
