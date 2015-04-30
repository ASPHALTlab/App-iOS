//
//  SettingsViewController.h
//  Haiku
//
//  Created by Morgan Collino on 4/28/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HKSettingsActionType) {
	
	HKSettingsActionManualTrack = 0,
	HKSettingsActionBluetooth,
};

@interface SettingsViewController : UITableViewController

@end
