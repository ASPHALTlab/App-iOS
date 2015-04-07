//
//  TrackManager.m
//  Haiku
//
//  Created by Morgan Collino on 4/6/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "TrackManager.h"
#import "LocationManager.h"
#import "RunManager.h"
#import "Run.h"
#import "Location.h"

@interface TrackManager ()

@end

@implementation TrackManager

+ (instancetype)sharedManager {
	
	static TrackManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[TrackManager alloc] init];
		manager.distance = 0;
	});
	return manager;
}

- (Run *)createNewTrack:(NSDate *)timestamp withInitialLocations:(NSArray *)locations {
	
	LocationManager *manager = [LocationManager sharedManager];
	manager.delegate = self;
	[manager startLocation];
	
	// Create Run*
	Run *newRun = [RunManager newRun];
	if (locations) {
		NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:locations];
		newRun.locations = orderedSet;
	}
	self.lastRun = newRun;
	self.speed = 0;
	self.distance = 0;
	
	return newRun;
}

- (void)endTracking {
	LocationManager *manager = [LocationManager sharedManager];
	manager.delegate = nil;
	[manager stopLocation];

	
	[RunManager save];
}

#pragma mark - LocationManager delegate

- (void)locationManager:(LocationManager *)manager didReceivedNewLocations:(NSArray *)newLocations {
	
	for (CLLocation *location in newLocations) {
		// Create new Model Location -> Run to run;
		
		Location *newLocation = [RunManager newLocationWithCoordinate:location];
		
		Location *last = [self.lastRun.locations lastObject];
		if (last) {
			CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:last.latitude.doubleValue longitude:last.longitude.doubleValue];
		

			double lastDistance = [location distanceFromLocation:lastLocation];
			self.distance += lastDistance;
			NSTimeInterval secs = [[newLocation timestamp] timeIntervalSinceDate:last.timestamp];
			self.speed = (lastDistance / secs) * 3.6; // km/h
		}
		
		
		NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.lastRun.locations];
		[tempSet addObject:newLocation];
		[self.lastRun setLocations:tempSet];
	}
	
	[RunManager save];
}

@end