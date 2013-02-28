//
//  RouteList.h
//  Get Me There
//
//  Created by joseph schneider on 4/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <CoreData/CoreData.h>

#import <UIKit/UIKit.h>

@interface RouteList : UITableViewController<UINavigationControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
