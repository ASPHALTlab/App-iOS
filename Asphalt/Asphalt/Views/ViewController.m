//
//  ViewController.m
//  Asphalt
//
//  Created by Morgan Collino on 10/31/14.
//
//

#import "ViewController.h"
#import "AsphaltManager.h"

@interface ViewController () <UITextFieldDelegate, AsphaltManagerDelegate>

@property (nonatomic, retain) AsphaltManager *manager;
@property (nonatomic, retain) IBOutlet UIButton *dateButton;
@property (nonatomic, retain) IBOutlet UIButton *colorButton;
@property (nonatomic, retain) IBOutlet UISlider *redSlider;
@property (nonatomic, retain) IBOutlet UISlider *greenSlider;
@property (nonatomic, retain) IBOutlet UISlider *blueSlider;
@property (nonatomic, retain) IBOutlet UILabel *connectedLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.manager = [AsphaltManager sharedManager];
	self.manager.delegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)sendColor:(id)sender {
	uint8_t colors[3];

	colors[0] = (uint8_t)self.redSlider.value;
	colors[1] = (uint8_t)self.greenSlider.value;
	colors[2] = (uint8_t)self.blueSlider.value;
	
	[self.manager sendColor:colors];
}

#pragma mark UITextfieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - CBAsphaltManger Protocol

- (void)connectionDidChange:(BOOL)hasConnection {
	self.connectedLabel.backgroundColor = hasConnection == YES ? [UIColor blueColor] : [UIColor redColor];
}

@end
