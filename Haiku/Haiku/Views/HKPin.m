//
//  HKPin.m
//  Haiku
//
//  Created by Morgan Collino on 5/2/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "HKPin.h"

@implementation HKPin

@synthesize title = _title, subtitle = _subtitle, coordinate = _coordinate;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description {
	if (self = [super init]) {
		self.coordinate = location;
		self.title = placeName;
		self.subtitle = description;
	}
	return self;
}
@end
