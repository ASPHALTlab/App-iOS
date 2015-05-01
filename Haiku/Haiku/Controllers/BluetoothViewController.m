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


@interface BluetoothViewController ()

@property (nonatomic, strong) NSMutableArray *devices;
@property (nonatomic, strong) UILabel *label;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.devices = [[NSMutableArray alloc] init];

	[HaikuCommunication scanBluetoothDevicesWithCentralDelegate:nil];
	
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	self.label.backgroundColor = [UIColor redColor];
	UIBarButtonItem *isConnected = [[UIBarButtonItem alloc] initWithCustomView:self.label];
	self.navigationItem.rightBarButtonItem = isConnected;

	// Register to notifications BLE
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNewBLEDevice:) name:BLE_NEW_DEVICE_DETECTED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectBLEDeviceOn:) name:BLE_CO_DEVICE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnectBLEDevice:) name:BLE_DECO_DEVICE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = @"BLE Devices";
	self.label.backgroundColor = [HaikuCommunication isConnected] ? [UIColor blueColor] : [UIColor redColor];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.title = @"";
}

#pragma mark - Bluetooth Notifications

- (void)receivedNewBLEDevice:(NSNotification*)notification {
	
	NSDictionary *userInfo = notification.userInfo;
	CBPeripheral *peripheral = [userInfo objectForKey:@"peripheral"];
	if ([self.devices containsObject:peripheral]) {
		[self.devices removeObject:peripheral];
	}
	[self.devices addObject:peripheral];
	[self.tableView reloadData];
}

- (void)didConnectBLEDeviceOn:(NSNotification*)notification {
	self.label.backgroundColor = [UIColor blueColor];
}

- (void)didDisconnectBLEDevice:(NSNotification*)notification {
	self.label.backgroundColor = [UIColor redColor];
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

	cell.textLabel.text = [peripheral name];
	cell.detailTextLabel.text = [peripheral.identifier UUIDString];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([self.label.backgroundColor isEqual:[UIColor redColor]]) {
		CBPeripheral *peripheral = [self.devices objectAtIndex:indexPath.row];
		[HaikuCommunication connectOnPeripheral:peripheral];
	}
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
