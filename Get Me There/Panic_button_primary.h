//
//  Panic_button_primary.h
//  Get Me There
//
//  Created by joseph schneider on 5/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Panic_button_primary : UITableViewController<UIAlertViewDelegate>{
NSFetchedResultsController *_fetchedResultsController;
NSManagedObjectContext *_context;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

    
@end
