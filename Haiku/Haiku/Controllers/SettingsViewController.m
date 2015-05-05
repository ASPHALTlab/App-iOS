//
//  SettingsViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/28/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "SettingsViewController.h"
#import "ActionTableViewCell.h"

@interface SettingsViewController ()

@property (nonatomic, strong) NSDictionary *actions;
@property (nonatomic, strong) NSDictionary *images;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.actions = @{@"Manual Track": @(HKSettingsActionManualTrack), @"Bluetooth": @(HKSettingsActionBluetooth),@"Device": @(HKSettingsActionDevice)};
	self.images = @{@(HKSettingsActionManualTrack):@"bike", @(HKSettingsActionBluetooth):@"bluetooth",@(HKSettingsActionDevice):@"bike"};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = @"Actions";
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.title = @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.actions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SETTINGS_CELL" forIndexPath:indexPath];
	
	NSString *key = [[self.actions allKeys] objectAtIndex:indexPath.row];
	NSNumber *value = [[self.actions allValues] objectAtIndex:indexPath.row];
	cell.tag = value.integerValue;
	NSString *imageName = [self.images objectForKey:value];
	[cell setImageWithName:imageName titleAction:key];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];;
	
	NSString *fireSegue = @"";
	
	switch (cell.tag) {
		case HKSettingsActionBluetooth:
			fireSegue = @"BLE_SEGUE";
			break;
		case HKSettingsActionManualTrack:
			fireSegue = @"MANUAL_TRACKING_SEGUE";
			break;
		case HKSettingsActionDevice:
			fireSegue = @"DEVICE_SEGUE";
			break;
		default:
			break;
	}
	
	
	if (![fireSegue isEqualToString:@""]) {
		[self performSegueWithIdentifier:fireSegue sender:self];
	}
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
