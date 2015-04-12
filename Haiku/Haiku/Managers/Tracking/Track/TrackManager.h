//
//  TrackManager.h
//  Haiku
//
//  Created by Morgan Collino on 4/6/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"

@class Run;

@interface TrackManager : NSObject <LocationManagerProtocol>

- (Run *)createNewTrack:(NSDate *)timestamp withInitialLocations:(NSArray *)locations;
- (Run *)endTracking;
+ (instancetype)sharedManager;

@property (nonatomic, strong) Run *lastRun;
@property (nonatomic) double distance;
@property (nonatomic) double speed;

@end
