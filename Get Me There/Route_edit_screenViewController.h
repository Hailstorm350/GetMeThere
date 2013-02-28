//
//  Route_edit_screenViewController.h
//  Get Me There
//
//  Created by joseph schneider on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Route;
@interface Route_edit_screenViewController : UITableViewController{
NSFetchedResultsController *_fetchedResultsController;
NSManagedObjectContext *_context;




}


//@property to declare the events based on the appDelegate ivar
//@property (nonatomic, retain) Events_list *eventData; 
@property (nonatomic) NSInteger inheritedIndexRow;
@property (nonatomic, retain) NSString *inheritedName;
@property (nonatomic, retain) Route *inheritedRoute;
//@property (nonatomic) NSIndexPath inheritedIndexPath;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
