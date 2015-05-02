//
//  TrackViewController.m
//  Haiku
//
//  Created by Morgan Collino on 4/3/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "TrackViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"
#import "Run.h"

@interface TrackViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = @"Track";
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.mapView.mapType = MKMapTypeSatellite;
	[self.mapView removeFromSuperview];
	self.mapView = nil;
	self.title = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MapKit Delegate

- (MKCoordinateRegion)mapRegion {
	
	MKCoordinateRegion region;
	if (self.tracks.count == 0) {
		return region;
	}
	
	
	Location *initialLoc = ((Run *)self.tracks[0]).locations.firstObject;

	float minLat = initialLoc.latitude.floatValue;
	float minLng = initialLoc.longitude.floatValue;
	float maxLat = initialLoc.latitude.floatValue;
	float maxLng = initialLoc.longitude.floatValue;
	
	for (Run *run in self.tracks) {

		
		for (Location *location in run.locations) {
			if (location.latitude.floatValue < minLat) {
				minLat = location.latitude.floatValue;
			}
			if (location.longitude.floatValue < minLng) {
				minLng = location.longitude.floatValue;
			}
			if (location.latitude.floatValue > maxLat) {
				maxLat = location.latitude.floatValue;
			}
			if (location.longitude.floatValue > maxLng) {
				maxLng = location.longitude.floatValue;
			}
		}
		
	}
	region.center.latitude = (minLat + maxLat) / 2.0f;
	region.center.longitude = (minLng + maxLng) / 2.0f;
 
	region.span.latitudeDelta = (maxLat - minLat) * 1.1f; // 10% padding
	region.span.longitudeDelta = (maxLng - minLng) * 1.1f; // 10% padding
 
	return region;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
	if ([overlay isKindOfClass:[MKPolyline class]]) {
		MKPolyline *polyLine = (MKPolyline *)overlay;
		MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
		aRenderer.strokeColor = [UIColor blackColor];
		aRenderer.lineWidth = 3;
		return aRenderer;
	}
 
	return nil;
}

- (MKPolyline *)polyLine {
	
	if (self.tracks.count == 0) {
		return nil;
	}

	int count = 0;
	for (Run *run in self.tracks) {
		count += run.locations.count;
	}
	
	CLLocationCoordinate2D coords[count];
	
	int pos = 0;
	for (Run *run in self.tracks) {
		for (Location *location in run.locations) {
			coords[pos] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
			pos++;
		}
	}
	
	return [MKPolyline polylineWithCoordinates:coords count:count];
}

- (void)loadMap {
	
	if (self.tracks.count == 0) {
		return ;
	}
	
	int count = 0;
	for (Run *run in self.tracks) {
		count += run.locations.count;
	}
	
	if (count > 0) {
		
		self.mapView.hidden = NO;
		
		// set the map bounds
		[self.mapView setRegion:[self mapRegion]];
		
		// make the line(s!) on the map
		[self.mapView addOverlay:[self polyLine]];
		
	} else {
		
		// no locations were found!
		self.mapView.hidden = YES;
		
		UIAlertView *alertView = [[UIAlertView alloc]
								  initWithTitle:@"Error"
								  message:@"Sorry, this run has no locations saved."
								  delegate:nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
		[alertView show];
	}
}

@end
