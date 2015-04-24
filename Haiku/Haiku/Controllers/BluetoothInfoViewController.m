//
//  BluetoothInfoViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/23/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "BluetoothInfoViewController.h"
#import "HaikuCommunication.h"

@interface BluetoothInfoViewController () <CentralManagerProtocol>

@property (nonatomic, retain) NSDictionary *characteristics;
@property (nonatomic, strong) UILabel *label;

@end

@implementation BluetoothInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Characteristics";
	self.characteristics = [HaikuCommunication characteristics];
	
	
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	self.label.backgroundColor = [HaikuCommunication isConnected] ? [UIColor blueColor] : [UIColor redColor];
	UIBarButtonItem *isConnected = [[UIBarButtonItem alloc] initWithCustomView:self.label];
	self.navigationItem.rightBarButtonItem = isConnected;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[HaikuCommunication setCentralDelegate:self];
}

- (NSString *)descriptionForUUID:(NSString *)uuid {
	
	NSString *res = @"";
	
	if ([uuid isEqualToString:SETTINGS_LEFTBASIC_CHAR]) {
		res = @"LEFT BASIC CHARACTERISTIC";
	} else if ([uuid isEqualToString:SETTINGS_RIGHTBASIC_CHAR]) {
		res = @"RIGHT BASIC CHARACTERISTIC";
	} else if ([uuid isEqualToString:SETTINGS_LEFTDETAIL_CHAR]) {
		res = @"LEFT DETAIL CHARACTERISTIC";
	} else if ([uuid isEqualToString:SETTINGS_RIGHTDETAIL_CHAR]) {
		res = @"RIGHT DETAIL CHARACTERISTIC";
	} else if ([uuid isEqualToString:DATA_DISTANCE_CHAR]) {
		res = @"DISTANCE CHARACTERISTIC";
	} else if ([uuid isEqualToString:DATA_SPEED_CHAR]) {
		res = @"SPEED CHARACTERISTIC";
	} else if ([uuid isEqualToString:DATA_TIME_CHAR]) {
		res = @"TIME CHARACTERISTIC";
	} else if ([uuid isEqualToString:DATA_AVGSPEED_CHAR]) {
		res = @"AVG SPEED CHARACTERISTIC";
	} else if ([uuid isEqualToString:DATA_SENSOR_CHAR]) {
		res = @"SENSOR CHARACTERISTIC";
	} else if ([uuid isEqualToString:SETTINGS_SERVICE]) {
		res = @"SETTINGS SERVICE";
	} else if ([uuid isEqualToString:DATA_SERVICE]) {
		res = @"DATA SERVICE";
	}

	return res;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.characteristics.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSArray *rows = [[self.characteristics allValues] objectAtIndex:section];
    return rows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *uuid = [[self.characteristics allKeys] objectAtIndex:section];
	NSString *title = [self descriptionForUUID:uuid];
	return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLE_INFO_CELL" forIndexPath:indexPath];
	NSArray *rows = [[self.characteristics allValues] objectAtIndex:indexPath.section];

	CBUUID *uuid = [rows objectAtIndex:indexPath.row];
	CBCharacteristic *characteristics = [HaikuCommunication characteristicByUUID:uuid.UUIDString];
	
	cell.textLabel.text = [self descriptionForUUID:uuid.UUIDString];
	if (!characteristics) {
		// Characteristics not implemented by the device
		cell.backgroundColor = [UIColor lightGrayColor];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Not implemented: %@", uuid.UUIDString];
		cell.detailTextLabel.textColor = [UIColor redColor];
	} else {
		cell.backgroundColor = [UIColor whiteColor];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Value: %@ UUID: %@", characteristics.value, uuid.UUIDString];
		cell.detailTextLabel.textColor = [UIColor darkGrayColor];
	}
	
    return cell;
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

#warning REPLACE WITH NOTIFICATION -> Instead of delegates

- (void)central:(CentralManager *)central didConnectOn:(CBPeripheral *)device {
	NSLog(@"ON EST CONNECTEY: %@", device);
	self.label.backgroundColor = [UIColor blueColor];
}

- (void)central:(CentralManager *)central didDisconnectOn:(CBPeripheral *)device {
	NSLog(@"ON EST DECONNECTEY DE : %@", device);
	self.label.backgroundColor = [UIColor redColor];
}

@end
