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


#define SETTINGS_SERVICE @"47249440-F70D-4EA0-B488-54CF344B7BE6"

	#define SETTINGS_LEFTBASIC_CHAR @"F55C3D44-E4D7-4A65-9CFE-1080798256CF"
	#define SETTINGS_RIGHTBASIC_CHAR @"186E5376-8B9F-4079-B085-F4945584D7D8"
	#define SETTINGS_LEFTDETAIL_CHAR @"6B26D18D-5BA3-4C84-9203-9277341AC3D3"
	#define SETTINGS_RIGHTDETAIL_CHAR @"7176D5DE-F1E4-43DB-B3E3-C73072881172"

#define DATA_SERVICE @"4C7D9445-9C63-4F64-96D4-7B9ECEFA2369"

	#define DATA_DISTANCE_CHAR @"F6CF6120-81B9-4B23-BCC9-476892D25E3F"
	#define DATA_SPEED_CHAR @"1094F24A-BF2B-4AD7-915E-527A4D38165C"
	#define DATA_TIME_CHAR @"B12B89C1-F50D-471C-A09C-A9FD1BFECC27"
	#define DATA_AVGSPEED_CHAR @"B2F221A9-672C-485A-8B3B-D8245116A1CF"
	#define DATA_SENSOR_CHAR @"9606A690-CE3C-47B8-9915-D73268FD8A48"


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
+ (NSDictionary *)characteristics;
+ (CBCharacteristic *)characteristicByUUID:(NSString *)uuid;
+ (BOOL)isConnected;

+ (void)scanBluetoothDevicesWithCentralDelegate:(id<CentralManagerProtocol>)delegate;
+ (void)setCentralDelegate:(id<CentralManagerProtocol>)delegate;
+ (void)setPeripheralDelegate:(id<PeripheralManagerProtocol>)delegate;
+ (void)connectOnPeripheral:(CBPeripheral *)peripheral;

@end
