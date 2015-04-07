//
//  RunManager.m
//  Haiku
//
//  Created by Morgan Collino on 4/4/15.
//  Copyright (c) 2015 Morgan Collino. All rights reserved.
//

#import "RunManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Run.h"
#import "Location.h"

@implementation RunManager

+ (NSArray *)runs {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [NSFetchRequest alloc];
	request.entity = entityDescription;
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	NSArray *sortDescriptors = @[sortDescriptor];
	request.sortDescriptors = sortDescriptors;
	
	NSError *error;
	NSArray *arr = [moc executeFetchRequest:request error:&error];
	
	return arr;
}

+ (Run *)newRun {
	
	NSManagedObjectContext *moc = [self managedObjectContext];
	Run *newRun = (Run *)[NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:moc];
	return newRun;
}

+ (Location  *)newLocationWithCoordinate:(CLLocation *)coordinate {
	NSManagedObjectContext *moc = [self managedObjectContext];
	Location *newLocation = (Location *)[NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:moc];
	newLocation.latitude = @(coordinate.coordinate.latitude);
	newLocation.longitude = @(coordinate.coordinate.longitude);
	newLocation.timestamp = coordinate.timestamp;
	
	return newLocation;
}

+ (BOOL)save {
	
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSError *error;
	
	BOOL response = [moc save:&error];
	if (!response) {
		NSLog(@"Error : %@", error);
	}
	return response;
}

+ (NSManagedObjectContext *)managedObjectContext {
	AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	return appDelegate.managedObjectContext;
}

@end