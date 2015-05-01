//
//  GlobalRidesViewController.m
//  Haiku
//
//  Created by Morgan Collino on 5/1/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "GlobalRidesViewController.h"
#import "TrackListViewController.h"
#import "RunManager.h"

@interface GlobalRidesViewController ()

@property (nonatomic, strong) NSArray *order;

@end

@implementation GlobalRidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.order = @[@"Daily", @"Weekly", @"Monthly", @"Yearly", @"All"];
	self.title = @"Global";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.order.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLB_CELL" forIndexPath:indexPath];
	
	cell.textLabel.text = [self.order objectAtIndex:indexPath.row];
	cell.tag = indexPath.row;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
	UITableViewCell *cell = sender;
	NSArray *rides = nil;
	NSString *title = @"All";
	switch (cell.tag) {
		case HKGlobalRideByDaily:
			[RunManager dailyRuns];
			title = @"Daily";
			break;
		case HKGlobalRideByWeekly:
			[RunManager weeklyRuns];
			title = @"Weekly";
			break;
		case HKGlobalRideByMontly:
			[RunManager monthlyRuns];
			title = @"Monthly";
			break;
		case HKGlobalRideByYearly:
			[RunManager yearlyRuns];
			title = @"Yearly";
			break;
		default:
			// All
			break;
	}

	if ([segue.destinationViewController isKindOfClass:[TrackListViewController class]]) {
		TrackListViewController	*vc = (TrackListViewController *)segue.destinationViewController;
		vc.tracks = rides;
		vc.title = title;
	}
}

@end
