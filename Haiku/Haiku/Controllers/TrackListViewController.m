//
//  TrackListViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/10/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "TrackListViewController.h"
#import "TrackViewController.h"
#import "Run.h"
#import "RunManager.h"

@interface TrackListViewController ()

@end

@implementation TrackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.tracks == nil) {
		self.tracks = [RunManager runs];
	}
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(tapOnRightButton:)];
	self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOnRightButton:(id)sender {
	[self performSegueWithIdentifier:@"VIEW_TRACKS" sender:sender];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.tracks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString * const identifier = @"TRACK_CELL";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateStyle = NSDateFormatterShortStyle;
	dateFormatter.timeStyle = NSDateFormatterShortStyle;
	
	Run *run = self.tracks[indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Track > Temps:%@, Distance: %@", run.duration, run.distance];
	cell.detailTextLabel.text = [dateFormatter stringFromDate:run.timestamp];
	cell.tag = indexPath.row;
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([segue.destinationViewController isKindOfClass:[TrackViewController class]] && [sender isKindOfClass:[UITableViewCell class]]) {
		
		NSInteger index = ((UITableViewCell *)sender).tag;
		TrackListViewController *controller = (TrackListViewController *)segue.destinationViewController;
		controller.tracks = @[self.tracks[index]];
	} else if ([segue.destinationViewController isKindOfClass:[TrackViewController class]]) {
		
		TrackListViewController *controller = (TrackListViewController *)segue.destinationViewController;
		controller.tracks = self.tracks;
	}
}


@end
