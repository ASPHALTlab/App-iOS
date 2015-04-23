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

@interface HaikuCommunication : NSObject

// Move -- If in the future we implement a GPS


#define SETTINGS_SERVICE @"F0000000-­0451-­4000­-B000-­00000000­BA01"

	#define SETTINGS_LEFTBASIC_CHAR @"F0000000­0451­4000­B000­00000000­BA02"
	#define SETTINGS_RIGHTBASIC_CHAR @"F0000000­0451­4000­B000­00000000­BA03"
	#define SETTINGS_LEFTDETAIL_CHAR @"F0000000­0451­4000­B000­00000000­BA04"
	#define SETTINGS_RIGHTDETAIL_CHAR @"F0000000­0451­4000­B000­00000000­BA05"

#define DATA_SERVICE @"F0000000­0451­4000­B000­00000000­BA11"

	#define DATA_DISTANCE_CHAR @"F0000000­0451­4000­B000­00000000­BA12"
	#define DATA_SPEED_CHAR @"F0000000­0451­4000­B000­00000000­BA13"
	#define DATA_TIME_CHAR @"F0000000­0451­4000­B000­00000000­BA14"
	#define DATA_AVGSPEED_CHAR @"F0000000­0451­4000­B000­00000000­BA15"
	#define DATA_SENSOR_CHAR @"F0000000­0451­4000­B000­00000000­BA16"


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
+ (CBCharacteristic *)characteristicByUUID:(NSString *)uuid;
+ (void)scanBluetoothDevicesWithCentralDelegate:(id<CentralManagerProtocol>)delegate;
+ (void)connectOnPeripheral:(CBPeripheral *)peripheral;

@end
