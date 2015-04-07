//
//  ManualTrackingViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/4/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "ManualTrackingViewController.h"

@interface ManualTrackingViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger seconds;

@end

@implementation ManualTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.seconds = 0;
	
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tickTock {
	self.seconds++;
}

- (void)viewWillDisappear:(BOOL)animated {

	[super viewWillDisappear:animated];
	if (self.timer) {
		[self.timer invalidate];
	}
}

#pragma mark - IBActions

- (IBAction)tapOnStop:(id)sender {
	
	if (self.timer) {
		[self.timer invalidate];
	}}

- (IBAction)tapOnStart:(id)sender {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickTock) userInfo:nil repeats:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
