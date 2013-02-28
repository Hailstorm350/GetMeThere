//
//  Get_Me_ThereAppDelegate.h
//  Get Me There
//
//  Created by joseph schneider on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events_list.h"
#import "Where_Am_IViewController.h"
#import "Route_edit_screenViewController.h"
#import "UserManual.h"
//#import "Home Screen.h"
#import "Guardian_Home_Screen.h"
@class Where_Am_IViewController;

@interface Get_Me_ThereAppDelegate : NSObject <UIApplicationDelegate>{
    Events_list *eventDataPortion;
    
    //-com.apple.CoreData.SQLDebug 1
    
    //START WITH THIS ONE!
    
    
    
    //NEW CODE
    IBOutlet UINavigationController *navigationController;
    NSManagedObjectContext *managedObjectContext;  
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, retain) IBOutlet Where_Am_IViewController *viewController;

@property (nonatomic, retain) IBOutlet Route_edit_screenViewController *whereIWillGetMyData;

@property (nonatomic, retain) IBOutlet UserManual *manual;

//@property (nonatomic, retain) IBOutlet Home_Screen *home;

@property (nonatomic, retain) IBOutlet Guardian_Home_Screen *guardianHome;

//ALSO NEW CODE
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;




- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (Get_Me_ThereAppDelegate *)sharedAppDelegate;

@end
