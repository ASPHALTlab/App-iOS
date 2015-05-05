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
#import "HaikuCommunication.h"

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

- (Run *)endTracking {
	LocationManager *manager = [LocationManager sharedManager];
	manager.delegate = nil;
	[manager stopLocation];
	
	Location *first = [self.lastRun.locations firstObject];
	Location *last = [self.lastRun.locations lastObject];

	self.lastRun.distance = @(self.distance);
	NSTimeInterval secs = [[last timestamp] timeIntervalSinceDate:first.timestamp];
	NSInteger minutes = secs / 60;
	self.lastRun.duration = @(minutes);

	[RunManager save];
	return self.lastRun;
}

#pragma mark - LocationManager delegate

- (void)locationManager:(LocationManager *)manager didReceivedNewLocations:(NSArray *)newLocations {
	
	for (CLLocation *location in newLocations) {
		// Create new Model Location -> Run to run;
		
		Location *newLocation = [RunManager newLocationWithCoordinate:location];
		
		Location *last = [self.lastRun.locations lastObject];
		Location *first = [self.lastRun.locations firstObject];
		NSTimeInterval time = [[newLocation timestamp] timeIntervalSinceDate:first.timestamp];

		if (last) {
			CLLocation *lastLocation = [[CLLocation alloc] initWithLatitude:last.latitude.doubleValue longitude:last.longitude.doubleValue];
		

			double lastDistance = [location distanceFromLocation:lastLocation];
			self.distance += lastDistance;
			NSTimeInterval secs = [[newLocation timestamp] timeIntervalSinceDate:last.timestamp];
			self.speed = (lastDistance / secs) * 3.6; // km/h
			[HaikuCommunication updateSpeed:self.speed];
			[HaikuCommunication updateDistance:self.distance];
			[HaikuCommunication updateTime:time/60];
		}
		
		
		NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.lastRun.locations];
		[tempSet addObject:newLocation];
		[self.lastRun setLocations:tempSet];
	}
	
	[RunManager save];
}

@end
