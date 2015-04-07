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

@interface TrackManager ()

@property (nonatomic, strong) Run *lastRun;

@end

@implementation TrackManager

- (void)createNewTrack:(NSDate *)timestamp withInitialLocations:(NSArray *)locations {
	
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
}

- (void)endTracking {
	LocationManager *manager = [LocationManager sharedManager];
	manager.delegate = nil;
	[manager stopLocation];
}

#pragma mark - LocationManager delegate

- (void)locationManager:(LocationManager *)manager didReceivedNewLocations:(NSArray *)newLocations {
	
	for (CLLocation *location in newLocations) {
		// Create new Model Location -> Run to run;
		Location *newLocation = [RunManager newLocationWithCoordinate:location];
		[self.lastRun addLocationsObject:newLocation];
	}
	
	[RunManager save];
}

@end
