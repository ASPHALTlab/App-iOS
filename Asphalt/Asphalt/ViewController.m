//
//  ViewController.m
//  Asphalt
//
//  Created by Morgan Collino on 10/31/14.
//
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *mphField;
@property (nonatomic, retain) IBOutlet UITextField *minutesField;
@property (nonatomic, retain) IBOutlet UITextField *hoursField;

@property (nonatomic, retain) IBOutlet UIButton *sendAllButton;
@property (nonatomic, retain) IBOutlet UIButton *sendMphButton;
@property (nonatomic, retain) IBOutlet UIButton *sendMinutesButton;
@property (nonatomic, retain) IBOutlet UIButton *sendHoursButton;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (IBAction) didPushSendAllButton:(id)sender
{
	
}

- (IBAction) didPushSendMphButton:(id)sender
{
	
}
- (IBAction) didPushSendMinutesButton:(id)sender
{
	
}

- (IBAction) didPushSendHoursButton:(id)sender
{
	
}

#pragma mark UITextfieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

@end
