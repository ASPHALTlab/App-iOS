//
//  RunManager.h
//  Haiku
//
//  Created by Morgan Collino on 4/4/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Run;
@class Location;

@interface RunManager : NSObject

+ (NSArray *)runs;
+ (Run *)newRun;
+ (Location  *)newLocationWithCoordinate:(CLLocation *)coordinate;
+ (BOOL)save;

@end
