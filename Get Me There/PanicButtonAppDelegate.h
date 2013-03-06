//
//  PanicButtonAppDelegate.h
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanicButtonAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *_navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (PanicButtonAppDelegate *) sharedAppDelegate;

@end
