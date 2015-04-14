//
//  HaikuCommunication.m
//  Haiku
//
//  Created by Morgan Collino on 4/15/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "HaikuCommunication.h"
#import "CentralManager.h"

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
	
	if ([infos objectForKey:@"movement"]) {
		NSNumber *movement = [infos objectForKey:@"movement"];
		[self updateMovement:movement.integerValue infos:@""];
	}
}


+ (void)updateDistance:(double)distance {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	NSDictionary *characteristics = manager.peripheralCharacteristics;
	
	if (peripheral && characteristics && [characteristics objectForKey:UPD_DISTANCE_CHAR]) {
		
		int8_t val = (uint8_t)distance;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:UPD_DISTANCE_CHAR];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}

}

+ (void)updateMovement:(HKMovement)movement infos:(NSString *)infos {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	NSDictionary *characteristics = manager.peripheralCharacteristics;
	
	if (peripheral && characteristics && [characteristics objectForKey:UPD_MOVE_CHAR]) {
		
		int8_t val = (uint8_t)movement;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:UPD_MOVE_CHAR];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
}

+ (void)updateSpeed:(double)speed {

	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	NSDictionary *characteristics = manager.peripheralCharacteristics;
	
	if (peripheral && characteristics && [characteristics objectForKey:UPD_SPEED_CHAR]) {
		
		int8_t val = (uint8_t)speed;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:UPD_SPEED_CHAR];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
	
}

+ (void)updateTime:(NSTimeInterval)time {
	
	CentralManager *manager = [CentralManager sharedCentral];
	
	CBPeripheral *peripheral = manager.connectedPeripheral;
	NSDictionary *characteristics = manager.peripheralCharacteristics;
	
	if (peripheral && characteristics && [characteristics objectForKey:UPD_TIME_CHAR]) {
		
		int8_t val = (uint8_t)time;
		NSData* valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
		CBCharacteristic *characteristic = [characteristics objectForKey:UPD_TIME_CHAR];
		[peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		[peripheral readValueForCharacteristic:characteristic];
	}
}

@end
