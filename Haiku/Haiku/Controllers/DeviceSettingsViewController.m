//
//  DeviceSettingsViewController.m
//  Haiku
//
//  Created by Morgan Collino on 5/4/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "DeviceSettingsViewController.h"

@interface DeviceSettingsViewController () <UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UIButton *firstScreen1;
@property (nonatomic, weak) IBOutlet UIButton *firstScreen2;
@property (nonatomic, weak) IBOutlet UIButton *secondScreen1;
@property (nonatomic, weak) IBOutlet UIButton *secondScreen2;


@end

@implementation DeviceSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Device";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOnScreen:(id)sender {
	
	UIButton *screen = sender;
	
	// sender.tag > TO WRITE ON
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a screen" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Time", @"Distance", @"Speed", @"Avg speed", nil];
	actionSheet.tag = screen.tag;
	[actionSheet showInView:self.view];
}

- (UIButton *)buttonForTag:(NSInteger)tag {
	
	UIButton *btn;
	
	switch (tag) {
		case 1:
			btn = self.firstScreen2;
			break;
		case 2:
			btn = self.secondScreen1;

			break;

		case 3:
			btn = self.secondScreen2;

			break;
		case 0:
			btn = self.firstScreen1;
			break;

		default:
			break;
	}
	return btn;
}

- (NSString *)titleForPosition:(NSInteger)position {

	NSString *str = @"?";
	switch (position) {
		case 0:
			str = @"TIME";
			break;
		case 1:
			str = @"DISTANCE";
			break;
		case 2:
			str = @"SPEED";
			break;
		case 3:
			str = @"AVG SPEED";
			break;
			
		default:
			break;
	}
	return str;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		UIButton *button = [self buttonForTag:actionSheet.tag];
		NSString *title = [self titleForPosition:buttonIndex];
		[button setTitle:title forState:UIControlStateNormal];
	}
}


@end
