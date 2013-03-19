//
//  ShowPrimaryDirection.h
//  Get Me There
//
//  Created by Monica Camorongan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
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
@property (nonatomic, strong) IBOutlet UIImageView *directionImage;
@property (nonatomic, strong) IBOutlet UIImageView *arrowImage;
@property (nonatomic, strong) IBOutlet UIButton *panicCallButton;
@property (nonatomic, strong) IBOutlet UIButton *nextDirButton;
@property (nonatomic, strong) IBOutlet UIButton *prevDirButton;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *routeName;
- (IBAction)contactListButtonPressed;
- (IBAction)nextButtonPressed;
- (IBAction)prevButtonPressed;

@end
