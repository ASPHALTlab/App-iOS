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

+ (int16_t)convertDoubleInto2bytesArray:(double)value {
	int8_t entier = (int8_t)value;
	int8_t decimale = (value - entier) * 10;
	
	int16_t val = (decimale << 8) | (entier & 0xff);
	return val;
}

+ (int16_t)convertDoubleInto2bytesArrayReversedBytes:(NSInteger)value {
	int8_t entier = (int8_t)value;
	int8_t decimale = 0;
	
	int16_t val = (entier << 8) | (decimale & 0xff);
	return val;
}

+ (void)write2BytesValue:(int16_t)value onCharacteristic:(CBCharacteristic *)characteristic {

	CentralManager *manager = [CentralManager sharedCentral];
	CBPeripheral *peripheral = manager.connectedPeripheral;

	if (peripheral && characteristic) {
		
		NSLog(@"SET CHARACTERISTIC: %@", characteristic);
		
		NSData* valData = [NSData dataWithBytes:&value length:sizeof(value)];
		NSLog(@"NSDATA: %@", valData);
		NSLog(@"Value: %d", value);
		
		int valuee = CFSwapInt32BigToHost(*(int*)([valData bytes]));
		NSLog(@"bytes: %d", (int16_t)valuee);
		
		[peripheral writeValue:valData forCharacteristic:characteristic type:	CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	} else {
		NSLog(@"___write2BytesValue_Couldn't write on characteristic !\nONE OF THEM IS NIL !");
		NSLog(@"DEBUG: __Peripheral : %@", peripheral);
		NSLog(@"DEBUG: __Characteristic : %@", characteristic);
		NSLog(@"________\n\n\n\n");
	}
	
}

+ (void)write1BytesValue:(int8_t)value onCharacteristic:(CBCharacteristic *)characteristic {
	
	CentralManager *manager = [CentralManager sharedCentral];
	CBPeripheral *peripheral = manager.connectedPeripheral;
	
	if (peripheral && characteristic) {
		NSData* valData = [NSData dataWithBytes:(void*)&value length:sizeof(value)];
		[peripheral writeValue:valData forCharacteristic:characteristic type:	CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	} else {
		NSLog(@"___write1BytesValue_Couldn't write on characteristic !\nONE OF THEM IS NIL !");
		NSLog(@"DEBUG: __Peripheral : %@", peripheral);
		NSLog(@"DEBUG: __Characteristic : %@", characteristic);
		NSLog(@"________\n\n\n\n");
	}
	
}


+ (void)updateCharacteristic:(CBCharacteristic *)characteristic withValue:(NSNumber *)value sizeOctets:(NSInteger)size {
	
	if (size == 2) {
		// Double value
		
		int16_t val;
		if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DATA_TIME_CHAR]]) {
			val = [self convertDoubleInto2bytesArrayReversedBytes:value.integerValue];
		} else {
			val = [self convertDoubleInto2bytesArray:value.doubleValue];
		}
		[self write2BytesValue:val onCharacteristic:characteristic];
	} else {
		int8_t val = value.integerValue;
		[self write1BytesValue:val onCharacteristic:characteristic];
	}
	
	
}

+ (void)updateDistance:(double)distance {
	
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_DISTANCE_CHAR];
	int16_t val = [self convertDoubleInto2bytesArray:distance];
	[self write2BytesValue:val onCharacteristic:characteristic];
}

+ (void)updateAvgSpeed:(double)speed {
	
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_AVGSPEED_CHAR];
	int16_t val = [self convertDoubleInto2bytesArray:speed];
	[self write2BytesValue:val onCharacteristic:characteristic];
}

+ (void)updateSpeed:(double)speed {
	
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_SPEED_CHAR];
	int16_t val = [self convertDoubleInto2bytesArray:speed];
	[self write2BytesValue:val onCharacteristic:characteristic];
}

+ (void)updateTime:(NSTimeInterval)time {
	
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_TIME_CHAR];
	int16_t val = [self convertDoubleInto2bytesArrayReversedBytes:time];

	[self write2BytesValue:val onCharacteristic:characteristic];
}

+ (void)updateSensor:(NSInteger)sensor {
	
	CBCharacteristic *characteristic = [self characteristicByUUID:DATA_SENSOR_CHAR];
	
	int8_t val = (uint8_t)sensor;
	[self write1BytesValue:val onCharacteristic:characteristic];
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
	//[[CentralManager sharedCentral] scan];
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
