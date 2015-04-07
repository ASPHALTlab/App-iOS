//
//  MathManager.m
//  Haiku
//
//  Created by Morgan Collino on 4/4/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "MathManager.h"

static bool const isMetric = YES;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

@implementation MathManager

+ (NSString *)stringifyDistance:(float)meters {
	float unitDivider;
	NSString *unitName;
 
	// metric
	if (isMetric) {
		unitName = @"km";
		// to get from meters to kilometers divide by this
		unitDivider = metersInKM;
		// U.S.
	} else {
		unitName = @"mi";
		// to get from meters to miles divide by this
		unitDivider = metersInMile;
	}
 
	return [NSString stringWithFormat:@"%.2f %@", (meters / unitDivider), unitName];
}

+ (NSString *)stringifySecondCount:(NSInteger)seconds usingLongFormat:(BOOL)longFormat {

	NSInteger remainingSeconds = seconds;
	NSInteger hours = remainingSeconds / 3600;
	remainingSeconds = remainingSeconds - hours * 3600;
	NSInteger minutes = remainingSeconds / 60;
	remainingSeconds = remainingSeconds - minutes * 60;
 
	if (longFormat) {
		if (hours > 0) {
			return [NSString stringWithFormat:@"%lihr %limin %lisec", hours, minutes, (long)remainingSeconds];
		} else if (minutes > 0) {
			return [NSString stringWithFormat:@"%limin %lisec", minutes, remainingSeconds];
		} else {
			return [NSString stringWithFormat:@"%lisec", remainingSeconds];
		}
	} else {
		if (hours > 0) {
			return [NSString stringWithFormat:@"%02li:%02li:%02li", hours, minutes, remainingSeconds];
		} else if (minutes > 0) {
			return [NSString stringWithFormat:@"%02li:%02li", minutes, remainingSeconds];
		} else {
			return [NSString stringWithFormat:@"00:%02li", remainingSeconds];
		}
	}
}

+ (NSString *)stringifySpeed:(float)speed {
	return [NSString stringWithFormat:@"%.2f km/h", speed];
}

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds {
	if (seconds == 0 || meters == 0) {
		return @"0";
	}
 
	float avgPaceSecMeters = seconds / meters;
 
	float unitMultiplier;
	NSString *unitName;
 
	// metric
	if (isMetric) {
		unitName = @"min/km";
		unitMultiplier = metersInKM;
		// U.S.
	} else {
		unitName = @"min/mi";
		unitMultiplier = metersInMile;
	}
 
	int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
	int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
 
	return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

@end