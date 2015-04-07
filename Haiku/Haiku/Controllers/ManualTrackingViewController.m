//
//  ManualTrackingViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/4/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "ManualTrackingViewController.h"
#import "TrackManager.h"
#import "Run.h"
#import "MathManager.h"
#import "TrackViewController.h"

@interface ManualTrackingViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger seconds;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *seeResultButton;

@property (nonatomic, retain) Run *track;

@end

@implementation ManualTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.seconds = 0;
	
	self.stopButton.hidden = YES;
	self.seeResultButton.hidden = YES;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tickTock {
	self.seconds++;
	self.track = [[TrackManager sharedManager] lastRun];
	self.distanceLabel.text = [MathManager stringifyDistance:[TrackManager sharedManager].distance];
	self.speedLabel.text = [MathManager stringifySpeed:[TrackManager sharedManager].speed];
	self.timeLabel.text = [MathManager stringifySecondCount:self.seconds usingLongFormat:NO];
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
	}
	self.track = [TrackManager sharedManager].lastRun;
	
	self.startButton.hidden = NO;
	self.stopButton.hidden = YES;
	
	self.seconds = 0;
	[self.timer invalidate];
	self.timeLabel.text = [MathManager stringifySecondCount:self.seconds usingLongFormat:NO];

	[[TrackManager sharedManager] endTracking];
	
	if (self.track) {
		self.seeResultButton.hidden = NO;
	}
}

- (IBAction)tapOnStart:(id)sender {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickTock) userInfo:nil repeats:YES];
	self.startButton.hidden = YES;
	self.stopButton.hidden = NO;
	
	self.track = [[TrackManager sharedManager] createNewTrack:[NSDate date] withInitialLocations:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.destinationViewController isKindOfClass:[TrackViewController class]]) {
		TrackViewController *vc = (TrackViewController *)segue.destinationViewController;
		vc.tracks = @[self.track];
	}
}


@end
