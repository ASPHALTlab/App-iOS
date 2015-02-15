//
//  AppDelegate.h
//  Asphalt
//
//  Created by Morgan Collino on 10/31/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class AsphaltManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Core data persistance
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) AsphaltManager *manager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

