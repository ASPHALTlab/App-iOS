//
//  HaikuCommunication.h
//  Haiku
//
//  Created by Morgan Collino on 4/15/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CentralManager.h"
#import "PeripheralManager.h"

@interface HaikuCommunication : NSObject

// Move -- If in the future we implement a GPS


#define SETTINGS_SERVICE @"F000BA01-0451-4000-B000-000000000000"

	#define SETTINGS_LEFTBASIC_CHAR @"F000BA02-0451-4000-B000-000000000000"
	#define SETTINGS_RIGHTBASIC_CHAR @"F000BA03-0451-4000-B000-000000000000"
	#define SETTINGS_LEFTDETAIL_CHAR @"F000BA04-0451-4000-B000-000000000000"
	#define SETTINGS_RIGHTDETAIL_CHAR @"F000BA05-0451-4000-B000-000000000000"

#define DATA_SERVICE @"F000BA11-0451-4000-B000-000000000000"

	#define DATA_DISTANCE_CHAR @"F000BA12-0451-4000-B000-000000000000"
	#define DATA_SPEED_CHAR @"F000BA13-0451-4000-B000-000000000000"
	#define DATA_TIME_CHAR @"F000BA14-0451-4000-B000-000000000000"
	#define DATA_AVGSPEED_CHAR @"F000BA15-0451-4000-B000-000000000000"
	#define DATA_SENSOR_CHAR @"F000BA16-0451-4000-B000-000000000000"



#define BLE_NEW_DEVICE_DETECTED  @"BLENEWDEVICEDETECTED"
#define BLE_DECO_DEVICE  @"BLEDECODEVICE"
#define BLE_CO_DEVICE  @"BLECODEVICE"
#define BLE_NEW_SERVICES_DETECTED  @"BLENEWSERVICESDETECTED"
#define BLE_NEW_CHARACTERISTICS_DETECTED  @"BLENEWCHARSDETECTED"

typedef NS_ENUM(NSInteger, HKMovement) {
	HKMovementLeft,
	HKMovementRight,
	HKMovementFront,
	HKMovementUTurn,
};

typedef NS_ENUM(NSInteger, HKLeftRendering) {
	HKLeftBasic,
	HKLeftDetail,
};

typedef NS_ENUM(NSInteger, HKRightRendering) {
	HKRightBasic,
	HKRightDetail,
};


+ (void)updateCharacteristic:(CBCharacteristic *)charactertistic withValue:(NSNumber *)value sizeOctets:(NSInteger)size;
+ (void)updateSpeed:(double)speed;
+ (void)updateTime:(NSTimeInterval)time;
+ (void)updateDistance:(double)distance; // in meters ?
+ (void)updateAvgSpeed:(double)speed;
+ (void)updateSensor:(NSInteger)sensor;

+ (void)setLeftRendering:(HKLeftRendering)rendering;
+ (void)setRightRendering:(HKRightRendering)rendering;

+ (CBUUID *)uiidFromString:(NSString *)string;

/*
 @params: NSDictionary *infos : @{@"speed":NSNumber.double, @"time":NSNumber.integerValue, @"distance":NSNumber.double,@"movement":NSNumber.integerValue
	Call update methods for given keys
 */

+ (void)updateInfos:(NSDictionary *)infos;


+ (NSArray *)services;
+ (NSDictionary *)characteristics;
+ (CBCharacteristic *)characteristicByUUID:(NSString *)uuid;
+ (BOOL)isConnected;

+ (void)scanBluetoothDevicesWithCentralDelegate:(id<CentralManagerProtocol>)delegate;
+ (void)setCentralDelegate:(id<CentralManagerProtocol>)delegate;
+ (void)setPeripheralDelegate:(id<PeripheralManagerProtocol>)delegate;
+ (void)connectOnPeripheral:(CBPeripheral *)peripheral;

@end
