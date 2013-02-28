//
//  Where_Am_IViewController.h
//  Get Me There
//
//  Created by joseph schneider on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <CoreData/CoreData.h>

#import <UIKit/UIKit.h>

@interface Where_Am_IViewController : UITableViewController<UITabBarDelegate, UITableViewDataSource> {
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;
}
-(IBAction) informationButtonPressed;
-(IBAction) GuardianButtonPressed;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;@end