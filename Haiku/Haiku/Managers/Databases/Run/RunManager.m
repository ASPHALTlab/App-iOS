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
	
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Run"];
	request.entity = entityDescription;
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	NSArray *sortDescriptors = @[sortDescriptor];
	request.sortDescriptors = sortDescriptors;
	
	NSError *error = nil;
	NSArray *arr = [moc executeFetchRequest:request error:&error];
	
	return arr;
}

+ (NSArray *)dailyRuns {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Run"];
	request.entity = entityDescription;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) AND (timestamp <= %@)", [NSDate date], [NSDate date]];
	[request setPredicate:predicate];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	NSArray *sortDescriptors = @[sortDescriptor];
	request.sortDescriptors = sortDescriptors;
	
	NSError *error = nil;
	NSArray *arr = [moc executeFetchRequest:request error:&error];
	
	return arr;
}
+ (NSArray *)weeklyRuns {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Run"];
	request.entity = entityDescription;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
	[comp setDay:1];
	
	NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
	[comp setDay:([comp day] - ((dayofweek) - 2))];// for beginning of the week.

	NSDate *firstDayOfWeek = [gregorian dateFromComponents:comp];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) AND (timestamp <= %@)", firstDayOfWeek, [NSDate date]];
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	NSArray *sortDescriptors = @[sortDescriptor];
	request.sortDescriptors = sortDescriptors;
	
	NSError *error = nil;
	NSArray *arr = [moc executeFetchRequest:request error:&error];
	
	return arr;
}
+ (NSArray *)monthlyRuns {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Run"];
	request.entity = entityDescription;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
	[comp setDay:1];
	NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) AND (timestamp <= %@)", firstDayOfMonthDate, [NSDate date]];
	[request setPredicate:predicate];
	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	NSArray *sortDescriptors = @[sortDescriptor];
	request.sortDescriptors = sortDescriptors;
	
	NSError *error = nil;
	NSArray *arr = [moc executeFetchRequest:request error:&error];
	
	return arr;
}
+ (NSArray *)yearlyRuns {
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run" inManagedObjectContext:moc];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Run"];
	request.entity = entityDescription;
	
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear) fromDate:[NSDate date]];
	[comp setYear:([comp year])];
	NSDate *firstDayOfYearDate = [gregorian dateFromComponents:comp];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(timestamp >= %@) AND (timestamp <= %@)", firstDayOfYearDate, [NSDate date]];
	[request setPredicate:predicate];

	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	NSArray *sortDescriptors = @[sortDescriptor];
	request.sortDescriptors = sortDescriptors;
	
	NSError *error = nil;
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
	newLocation.speed = @(coordinate.speed * 3.6); // m/s to km/h
	
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