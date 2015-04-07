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

- (void)createNewTrack:(NSDate *)timestamp withInitialLocations:(NSArray *)locations;
- (void)endTracking;

@end
