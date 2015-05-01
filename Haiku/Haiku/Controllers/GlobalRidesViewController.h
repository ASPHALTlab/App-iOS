//
//  GlobalRidesViewController.h
//  Haiku
//
//  Created by Morgan Collino on 5/1/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HKGlobalRideBy) {
	
	HKGlobalRideByDaily = 0,
	HKGlobalRideByWeekly,
	HKGlobalRideByMontly,
	HKGlobalRideByYearly,
	HKGlobalRideByAll
};

@interface GlobalRidesViewController : UITableViewController

@end
