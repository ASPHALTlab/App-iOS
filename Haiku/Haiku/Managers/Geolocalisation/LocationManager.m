//
//  LocationManager.m
//  Haiku
//
//  Created by Morgan Collino on 4/5/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

- (instancetype)init {
	if (self = [super init]) {
		
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.locationManager.activityType = CLActivityTypeFitness;
		self.locationManager.distanceFilter = 7;
		
		[self.locationManager requestAlwaysAuthorization]; // VERY IMPORTANT iOS >= 8
	}
	return self;
}

- (void)startLocation {
	[self.locationManager startUpdatingLocation];
}

- (void)stopLocation {
	[self.locationManager stopUpdatingLocation];
}

+ (instancetype)sharedManager {
	
	static LocationManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[LocationManager alloc] init];
	});
	return manager;
}

#pragma mark - CoreLocation Delegate

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
	// NE BOUGE PAS
	NSLog(@"DO NOT MOVE");
	if ([self.delegate respondsToSelector:@selector(locationManager:didReceivedNewLocations:)]) {
		[self.delegate locationManager:self didReceivedNewLocations:nil];
	}
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager { 
	// RE BOUGE
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	NSLog(@"New locations: %@", locations);
	self.lastCoordinate = (CLLocation *)[locations lastObject];
	
	if ([self.delegate respondsToSelector:@selector(locationManager:didReceivedNewLocations:)]) {
		[self.delegate locationManager:self didReceivedNewLocations:locations];
	}
}

@end
