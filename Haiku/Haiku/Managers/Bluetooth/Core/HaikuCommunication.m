//
//  HaikuCommunication.m
//  Haiku
//
//  Created by Morgan Collino on 4/15/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "HaikuCommunication.h"
#import "CentralManager.h"
#import "PeripheralManager.h"

@interface HaikuCommunication ()

@end

@implementation HaikuCommunication

+ (void)updateInfos:(NSDictionary *)infos {

	if ([infos objectForKey:@"distance"]) {
		NSNumber *distance = [infos objectForKey:@"distance"];
		[self updateDistance:distance.doubleValue];
	}
	
	if ([infos objectForKey:@"speed"]) {
		NSNumber *speed = [infos objectForKey:@"speed"];
		[self updateSpeed:speed.doubleValue];
	}
	
	if ([infos objectForKey:@"time"]) {
		NSNumber *time = [infos objectForKey:@"time"];
		[self updateTime:time.integerValue];
	}
	
	if ([infos objectForKey:@"avgspeed"]) {
		NSNumber *speed = [infos objectForKey:@"avgspeed"];
		[self updateAvgSpeed:speed.doubleValue];
	}
	
}

+ (CBUUID *)uiidFromString:(NSString *)string {
	return [CBUUID UUIDWithString:string];
}


+ (NSArray *)services {
	return [CentralManager sharedCentral].serviceUUIDs;
}

+ (NSDictionary *)characteristics {
	return [PeripheralManager sharedPeripheral].characteristicsUUIDs;
}

+ (BOOL)isConnected {
	CBPeripheral *peripheral = [CentralManager sharedCentral].connectedPeripheral;
	if (peripheral && (peripheral.state == CBPeripheralStateConnected || peripheral.state == CBPeripheralStateConnecting)) {
		return YES;
	}
	return NO;
}

+ (CBCharacteristic *)characteristicByUUID:(NSString *)uuid {
	
	CBCharacteristic *characteristic = [[PeripheralManager sharedPeripheral].discoveredCharacteristics objectForKey:uuid];
	return characteristic;
}

#pragma mark - Update methods

+ (void)updateDistance:(double)distance {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_DISTANCE_CHAR];
	
	if (characteristic && peripheral) {
		int8_t val = (uint8_t)distance;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
}

+ (void)updateAvgSpeed:(double)speed {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_AVGSPEED_CHAR];
	
	if (characteristic && peripheral) {
		int8_t val = (uint8_t)speed;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
}

+ (void)updateSpeed:(double)speed {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_SPEED_CHAR];
	
	if (characteristic && peripheral) {
		int8_t val = (uint8_t)speed;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
}

+ (void)updateTime:(NSTimeInterval)time {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_TIME_CHAR];
	
	if (characteristic && peripheral) {
		int8_t val = (uint8_t)time;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
}

+ (void)updateSensor:(NSInteger)sensor {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_SENSOR_CHAR];
	
	if (characteristic && peripheral) {
		int8_t val = (uint8_t)sensor;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
}

#pragma mark - Rendering

+ (void)setLeftRendering:(HKLeftRendering)rendering {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	
	NSString *renderingUUID = nil;
	NSString *unrenderingUUID = nil;
	
	switch (rendering) {
		case HKLeftDetail:
			renderingUUID = SETTINGS_LEFTDETAIL_CHAR;
			unrenderingUUID = SETTINGS_LEFTBASIC_CHAR;
			break;
		default:
			// basic
			renderingUUID = SETTINGS_LEFTBASIC_CHAR;
			unrenderingUUID = SETTINGS_LEFTDETAIL_CHAR;
			break;
	}
	
	
	CBCharacteristic *characteristic1 = [self characteristicByUUID:renderingUUID];
	CBCharacteristic *characteristic2 = [self characteristicByUUID:unrenderingUUID];
	if (characteristic1 && characteristic2 && peripheral) {
		int8_t val = (uint8_t)0;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		[peripheral writeValue:valData forCharacteristic:characteristic2 type:CBCharacteristicWriteWithResponse];
		val = 1;
		[peripheral writeValue:valData forCharacteristic:characteristic1 type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic1];
		[peripheral readValueForCharacteristic:characteristic2];
	}
	
}

+ (void)setRightRendering:(HKRightRendering)rendering {

	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	
	NSString *renderingUUID = nil;
	NSString *unrenderingUUID = nil;
	
	switch (rendering) {
		case HKLeftDetail:
			renderingUUID = SETTINGS_RIGHTDETAIL_CHAR;
			unrenderingUUID = SETTINGS_RIGHTBASIC_CHAR;
			break;
		default:
			// basic
			renderingUUID = SETTINGS_RIGHTBASIC_CHAR;
			unrenderingUUID = SETTINGS_RIGHTDETAIL_CHAR;
			break;
	}
	
	
	CBCharacteristic *characteristic1 = [self characteristicByUUID:renderingUUID];
	CBCharacteristic *characteristic2 = [self characteristicByUUID:unrenderingUUID];
	if (characteristic1 && characteristic2 && peripheral) {
		int8_t val = (uint8_t)0;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		[peripheral writeValue:valData forCharacteristic:characteristic2 type:CBCharacteristicWriteWithResponse];
		val = 1;
		[peripheral writeValue:valData forCharacteristic:characteristic1 type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic1];
		[peripheral readValueForCharacteristic:characteristic2];
	}
}


+ (void)scanBluetoothDevicesWithCentralDelegate:(id<CentralManagerProtocol>)delegate {
	[[CentralManager sharedCentral] setDelegate:delegate];
	[[CentralManager sharedCentral] scan];
}

+ (void)connectOnPeripheral:(CBPeripheral *)peripheral {
	[[CentralManager sharedCentral] connectOnPeripheral:peripheral];
}

+ (void)setCentralDelegate:(id<CentralManagerProtocol>)delegate {
	[[CentralManager sharedCentral] setDelegate:delegate];
}

+ (void)setPeripheralDelegate:(id<PeripheralManagerProtocol>)delegate {
	[[PeripheralManager sharedPeripheral] setDelegate:delegate];
}


@end
