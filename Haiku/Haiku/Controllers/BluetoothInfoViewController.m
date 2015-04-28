//
//  BluetoothInfoViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/23/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "BluetoothInfoViewController.h"
#import "BluetoothDoubleValueViewController.h"
#import "BluetoothIntValueViewController.h"
#import "HaikuCommunication.h"

@interface BluetoothInfoViewController () <CentralManagerProtocol>

@property (nonatomic, retain) NSDictionary *characteristics;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, weak)	NSIndexPath *indexPath;

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

	// REGISTER TO NOTIFICATIONS
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectBLEDeviceOn:) name:BLE_CO_DEVICE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnectBLEDevice:) name:BLE_DECO_DEVICE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverCharacteristicsForService:) name:BLE_NEW_CHARACTERISTICS_DETECTED object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - Bluetooth Notifications

- (void)didConnectBLEDeviceOn:(NSNotification*)notification {
	self.label.backgroundColor = [UIColor blueColor];
}

- (void)didDisconnectBLEDevice:(NSNotification*)notification {
	self.label.backgroundColor = [UIColor redColor];
}

- (void)didDiscoverCharacteristicsForService:(NSNotification *)notification {
	
	NSDictionary *userInfo = notification.userInfo;
	CBService *service = userInfo[@"service"];
	
	NSUInteger section = [[self.characteristics allKeys] indexOfObject:service.UUID.UUIDString];
	NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:section];
	
	[self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSArray *rows = [[self.characteristics allValues] objectAtIndex:indexPath.section];
	
	CBUUID *uuid = [rows objectAtIndex:indexPath.row];
	NSString *uuidString = uuid.UUIDString;
	
	CBCharacteristic *characteristic = [HaikuCommunication characteristicByUUID:uuid.UUIDString];
	
	if (!characteristic) {
		NSLog(@"NO CHARACTERISTIC TO EDIT !");
		// return;
	}
	
	self.indexPath = indexPath;
	
	if ([uuidString isEqualToString:DATA_DISTANCE_CHAR] || [uuidString isEqualToString:DATA_SPEED_CHAR] || [uuidString isEqualToString:DATA_TIME_CHAR] || [uuidString isEqualToString:DATA_AVGSPEED_CHAR]) {
		[self performSegueWithIdentifier:@"SHOW_DOUBLE_SET" sender:self];
	} else {
		[self performSegueWithIdentifier:@"SHOW_INT_SET" sender:self];
	}
	
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	NSIndexPath *indexPath = self.indexPath;
	NSArray *rows = [[self.characteristics allValues] objectAtIndex:indexPath.section];
	
	CBUUID *uuid = [rows objectAtIndex:indexPath.row];
	CBCharacteristic *characteristic = [HaikuCommunication characteristicByUUID:uuid.UUIDString];
	
	if ([[segue.destinationViewController class] isSubclassOfClass:
		[BluetoothDoubleValueViewController class]]) {
		
		BluetoothDoubleValueViewController *vc = segue.destinationViewController;
		vc.characteristic = characteristic;
	} else if ([[segue.destinationViewController class] isSubclassOfClass:[BluetoothIntValueViewController class]]) {
		BluetoothIntValueViewController *vc = segue.destinationViewController;
		vc.characteristic = characteristic;
	}
}

@end
