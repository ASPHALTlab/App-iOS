//
//  BluetoothIntValueViewController.h
//  Haiku
//
//  Created by Morgan Collino on 4/26/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothIntValueViewController : UIViewController

@property (nonatomic, retain) CBCharacteristic *characteristic;

@end
