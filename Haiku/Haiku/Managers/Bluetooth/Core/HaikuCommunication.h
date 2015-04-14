//
//  HaikuCommunication.h
//  Haiku
//
//  Created by Morgan Collino on 4/15/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HaikuCommunication : NSObject

// Move -- If in the future we implement a GPS


#define UPD_DISTANCE_CHAR @"FF1"
#define UPD_SPEED_CHAR @"FF2"
#define UPD_MOVE_CHAR @"FF3"
#define UPD_TIME_CHAR @"FF4"



typedef NS_ENUM(NSInteger, HKMovement) {
	HKMovementLeft,
	HKMovementRight,
	HKMovementFront,
	HKMovementUTurn,
};

+ (void)updateSpeed:(double)speed;
+ (void)updateTime:(NSTimeInterval)time;
+ (void)updateDistance:(double)distance; // in meters ?
+ (void)updateMovement:(HKMovement)movement infos:(NSString *)infos;


/*
 @params: NSDictionary *infos : @{@"speed":NSNumber.double, @"time":NSNumber.integerValue, @"distance":NSNumber.double,@"movement":NSNumber.integerValue
	Call update methods for given keys
 */

+ (void)updateInfos:(NSDictionary *)infos;
@end
