//
//  HomeViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/1/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "HomeViewController.h"
#import "UIButton_XDShape.h"
#import "TrackViewController.h"
#import "RunManager.h"
#import "StatsCollectionViewCell.h"

@interface HomeViewController () <UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) IBOutlet UICollectionView *collect;
@property (nonatomic, strong) NSDictionary *defaultValue; // To Remove in prod

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Haiku";
    // Do any additional setup after loading the view.
	self.defaultValue = @{@"Distance": @"12kms", @"Duration": @"57mins", @"Speed": @"20km/h", @"Rides": @"4"};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapOnMoreStats:(id)sender {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Global", @"By ride", nil];
	[actionSheet showInView:self.view];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ([segue.destinationViewController isKindOfClass:[TrackViewController class]]) {
		TrackViewController *vc = (TrackViewController *)segue.destinationViewController;
		vc.tracks = [RunManager runs];
	}
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.destructiveButtonIndex) {
		if (buttonIndex == HKStatsActionGlobal) {
			// List > Actions (Daily,Weekly, Monthly, Yearly)
		} else if (buttonIndex == HKStatsActionByRide) {
			// All rides
			[self performSegueWithIdentifier:@"ALL_RIDES" sender:self];
		}
	}
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.defaultValue.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	StatsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STATS_CELL" forIndexPath:indexPath];
	NSString *key = [[self.defaultValue allKeys] objectAtIndex:indexPath.row];
	NSString *value = [[self.defaultValue allValues] objectAtIndex:indexPath.row];
	
	[cell setTitle:key withValue:value];
	return cell;
}

#pragma mark - Collection View Data Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat picDimension = collectionView.frame.size.width / 2.2f;
	return CGSizeMake(picDimension, picDimension);
}

@end
