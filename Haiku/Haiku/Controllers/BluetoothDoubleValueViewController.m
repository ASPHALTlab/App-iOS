//
//  BluetoothDoubleValueViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/26/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "BluetoothDoubleValueViewController.h"
#import "HaikuCommunication.h"

@interface BluetoothDoubleValueViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *value;
@property (nonatomic, weak) IBOutlet UIButton *send;

@end

@implementation BluetoothDoubleValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return NO;
}

- (IBAction)tapOnSendButton:(id)sender {

	NSString *realValue = [self.value.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
	double value = realValue.doubleValue;

	[HaikuCommunication updateCharacteristic:self.characteristic withValue:@(value) sizeOctets:2];
}

@end
