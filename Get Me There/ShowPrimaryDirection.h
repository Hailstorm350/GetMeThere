//
//  ShowPrimaryDirection.h
//  Get Me There
//
//  Created by Monica Camorongan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Route;
@interface ShowPrimaryDirection : UIViewController {
    UIImageView *directionImage;
    UIImageView *arrowImage;
    UIButton *panicCallButton;
    UIButton *nextDirButton;
    UIButton *prevDirButton;
    NSFetchedResultsController *_fetchedResultsController;
    NSString *routeName;
    NSInteger currentEvent;
    
}
@property (nonatomic) NSInteger currentEvent;
@property (nonatomic, retain) IBOutlet UIImageView *directionImage;
@property (nonatomic, retain) IBOutlet UIImageView *arrowImage;
@property (nonatomic, retain) IBOutlet UIButton *panicCallButton;
@property (nonatomic, retain) IBOutlet UIButton *nextDirButton;
@property (nonatomic, retain) IBOutlet UIButton *prevDirButton;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSString *routeName;
- (IBAction)contactListButtonPressed;
- (IBAction)nextButtonPressed;
- (IBAction)prevButtonPressed;

@end
