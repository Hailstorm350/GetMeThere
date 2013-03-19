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
}


//@property to declare the events based on the appDelegate ivar
//@property (nonatomic, retain) Events_list *eventData; 
@property (nonatomic) NSInteger inheritedIndexRow;
@property (nonatomic, strong) NSString *inheritedName;
@property (nonatomic, strong) Route *inheritedRoute;
//@property (nonatomic) NSIndexPath inheritedIndexPath;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
