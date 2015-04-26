//
//  BluetoothIntValueViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/26/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "BluetoothIntValueViewController.h"
#import "HaikuCommunication.h"

@interface BluetoothIntValueViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *control;
@property (nonatomic, weak) IBOutlet UIButton *send;
@property (nonatomic, strong) UILabel *label;

@end

@implementation BluetoothIntValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	self.label.backgroundColor = [HaikuCommunication isConnected] ? [UIColor blueColor] : [UIColor redColor];
	UIBarButtonItem *isConnected = [[UIBarButtonItem alloc] initWithCustomView:self.label];
	self.navigationItem.rightBarButtonItem = isConnected;

	// REGISTER TO NOTIFICATIONS
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectBLEDeviceOn:) name:BLE_CO_DEVICE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDisconnectBLEDevice:) name:BLE_DECO_DEVICE object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOnSendButton:(id)sender {
	
	NSInteger value = self.control.selectedSegmentIndex;
	[HaikuCommunication updateCharacteristic:self.characteristic withValue:@(value) sizeOctets:1];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Bluetooth Notifications

- (void)didConnectBLEDeviceOn:(NSNotification*)notification {
	self.label.backgroundColor = [UIColor blueColor];
}

- (void)didDisconnectBLEDevice:(NSNotification*)notification {
	self.label.backgroundColor = [UIColor redColor];
}

@end
