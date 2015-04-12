//
//  PeripheralManager.m
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import "PeripheralManager.h"
#import <UIKit/UIKit.h>

@interface PeripheralManager ()

@property (strong, nonatomic) NSMutableData *data;

@end

@implementation PeripheralManager

- (instancetype) init {
	if (self = [super init]) {
		_manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
		_data = [[NSMutableData alloc] init];
	}
	return self;
}

+ (instancetype)sharedPeripheral {
	
	static PeripheralManager *shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		shared = [[self alloc] init];
	});
	return shared;
}

#pragma mark - Peripheral Manager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
	if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
		[_manager startAdvertising:@{
												   CBAdvertisementDataLocalNameKey: [[UIDevice currentDevice] name]
												   }];
	} else {
		[_manager stopAdvertising];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	
	NSLog(@"This peripheral services : %@", peripheral.services);
	NSLog(@"Error ? [%@]", error);
	if (error) {
		if ([self.delegate respondsToSelector:@selector(clean)]) {
			[self.delegate clean];
		}
		return;
	}
 
	for (CBService *service in peripheral.services) {
		NSLog(@"Service: %@", service.UUID.UUIDString);
		[peripheral discoverCharacteristics:nil forService:service];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
	if (error) {
		if ([self.delegate respondsToSelector:@selector(clean)]) {
			[self.delegate clean];
		}
		return;
	}
	
	for (CBCharacteristic *characteristic in service.characteristics) {
		[peripheral setNotifyValue:YES forCharacteristic:characteristic];
		// Saving characteristics
		[self.characteristics setObject:characteristic forKey:characteristic.UUID.UUIDString];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	if (error) {
		if ([self.delegate respondsToSelector:@selector(clean)]) {
			[self.delegate clean];
		}
		return;
	}
	
	NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
	
	// Have we got everything we need?
	if ([stringFromData isEqualToString:@"EOM"]) {
		[peripheral setNotifyValue:NO forCharacteristic:characteristic];
		//[self.manager cancelPeripheralConnection:peripheral];
	}
	
	[_data appendData:characteristic.value];
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	
	if (characteristic.isNotifying) {
		NSLog(@"Notification began on %@", characteristic);
	} else {
		// Notification has stopped
		NSLog(@"NOTIFICATION Stopped! Abort /!\\");
		//[self.manager cancelPeripheralConnection:peripheral];
	}
}

@end
