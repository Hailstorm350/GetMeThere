//
//  PanicButtonViewController.h
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditContactViewController;

@interface PanicButtonViewController : UITableViewController
    <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
- (IBAction)toggleEdit;
- (IBAction)toggleAdd;
- (IBAction)backButtonPressed;

@end
