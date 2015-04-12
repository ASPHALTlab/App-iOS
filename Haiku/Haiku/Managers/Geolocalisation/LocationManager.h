//
//  LocationManager.h
//  Haiku
//
//  Created by Morgan Collino on 4/5/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerProtocol;

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocation *lastCoordinate;

- (void)startLocation;
- (void)stopLocation;

// Static method
+ (instancetype)sharedManager;

@property (nonatomic, weak) id<LocationManagerProtocol> delegate;

@end

@protocol LocationManagerProtocol <NSObject>

- (void)locationManager:(LocationManager *)manager didReceivedNewLocations:(NSArray *)newLocations;

@end