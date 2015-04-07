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

@interface HomeViewController ()

@property (nonatomic, retain) IBOutlet UICollectionView *collect;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
