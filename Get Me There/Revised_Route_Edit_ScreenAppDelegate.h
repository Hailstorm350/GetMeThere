//
//  Revised_Route_Edit_ScreenAppDelegate.h
//  Revised Route Edit Screen
//
//  Created by Student on 1/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events_list.h"
#import "Route_edit_screenViewController.h"


@interface Revised_Route_Edit_ScreenAppDelegate : NSObject <UIApplicationDelegate> {
    Events_list *eventDataPortion;
    NSManagedObjectContext *managedObjectContext;  
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}



@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Route_edit_screenViewController *viewController;

@property (nonatomic, retain) IBOutlet Route_edit_screenViewController *editRoute;


@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (Revised_Route_Edit_ScreenAppDelegate *)sharedAppDelegate;
@end
