//
//  PeripheralManager.m
//  Asphalt
//
//  Created by Morgan Collino on 2/8/15.
//
//

#import <UIKit/UIKit.h>
#import "PeripheralManager.h"
#import "HaikuCommunication.h"
#import "TrackManager.h"

@interface PeripheralManager ()

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic) BOOL strictScan;

@end

@implementation PeripheralManager

- (instancetype) init {
	if (self = [super init]) {
		self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
		self.data = [[NSMutableData alloc] init];
		self.strictScan = NO;
		
		// Characteristics to be notified / write on
		self.characteristicsUUIDs = @{SETTINGS_SERVICE : @[[HaikuCommunication uiidFromString:SETTINGS_LEFTBASIC_CHAR], [HaikuCommunication uiidFromString:SETTINGS_RIGHTBASIC_CHAR],[HaikuCommunication uiidFromString:SETTINGS_LEFTDETAIL_CHAR], [HaikuCommunication uiidFromString:SETTINGS_RIGHTDETAIL_CHAR]], DATA_SERVICE:@[[HaikuCommunication uiidFromString:DATA_DISTANCE_CHAR], [HaikuCommunication uiidFromString:DATA_SPEED_CHAR],[HaikuCommunication uiidFromString:DATA_TIME_CHAR], [HaikuCommunication uiidFromString:DATA_AVGSPEED_CHAR],[HaikuCommunication uiidFromString:DATA_SENSOR_CHAR]]};
		
		self.discoveredCharacteristics = [[NSMutableDictionary alloc] init];
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
		[self.manager startAdvertising:@{
												   CBAdvertisementDataLocalNameKey: [[UIDevice currentDevice] name]
												   }];
	} else {
		[self.manager stopAdvertising];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	
	NSLog(@"This peripheral services : %@", peripheral.services);
	if (error) {
		if ([self.delegate respondsToSelector:@selector(clean)]) {
			[self.delegate clean];
		}
		return;
	}
 
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BLE_NEW_SERVICES_DETECTED
														object:self
													  userInfo:@{@"services":peripheral.services}];
	
	for (CBService *service in peripheral.services) {
		NSLog(@"\t\tService : %@", service.UUID.UUIDString);

		if (self.strictScan == YES)	{
			[peripheral discoverCharacteristics:self.characteristicsUUIDs[service.UUID.UUIDString]	forService:service];
		} else {
			[peripheral discoverCharacteristics:nil forService:service];
		}
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
	
	if (error) {
		if ([self.delegate respondsToSelector:@selector(clean)]) {
			[self.delegate clean];
		}
		return;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BLE_NEW_CHARACTERISTICS_DETECTED
														object:self
													  userInfo:@{@"service":service}];

	
	
	if ([self.delegate respondsToSelector:@selector(peripheral:didDiscoverCharacteristicsForService:)]) {
		[self.delegate peripheral:self didDiscoverCharacteristicsForService:service];
	}
	
	for (CBCharacteristic *characteristic in service.characteristics) {
		[peripheral setNotifyValue:YES forCharacteristic:characteristic];
		// Saving characteristics
		[self.discoveredCharacteristics setObject:characteristic forKey:characteristic.UUID.UUIDString];
	}
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	
	if (error) {
		if ([self.delegate respondsToSelector:@selector(clean)]) {
			[self.delegate clean];
		}
		return;
	}
	
	// IF THE SENSOR == 1 => TIME TO TRACK
	// ELSE: THE SENSOR == UNPLUGGED -> End of tracking;
	if ([characteristic.UUID.UUIDString isEqualToString:DATA_SENSOR_CHAR]) {
		NSLog(@"_____UPDATE____DATA_SENSOR_CHAR:");
		
		NSData *data = characteristic.value;
		NSInteger value = (NSInteger)data.bytes;
		
		/*if (value == 0) {
			[[TrackManager sharedManager] endTracking];
		} else {
			[[TrackManager sharedManager] createNewTrack:[NSDate date] withInitialLocations:nil];
		}*/
	}
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	
	if (characteristic.isNotifying) {
		NSLog(@"\t\t=> Notification began on %@: UUID=%@", characteristic, characteristic.UUID.UUIDString);
	}
	
	// IF THE SENSOR == 1 => TIME TO TRACK
	// ELSE: THE SENSOR == UNPLUGGED -> End of tracking;
	if ([characteristic.UUID.UUIDString isEqualToString:DATA_SENSOR_CHAR]) {
		NSLog(@"_____NOTIFY____DATA_SENSOR_CHAR:");

		NSData *data = characteristic.value;
		NSInteger value = (NSInteger)data.bytes;
		
		/*if (value == 0) {
			[[TrackManager sharedManager] endTracking];
		} else {
			[[TrackManager sharedManager] createNewTrack:[NSDate date] withInitialLocations:nil];
		}*/
	}
}

@end
