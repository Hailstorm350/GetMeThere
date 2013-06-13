//
//  ShowPrimaryDirection.h
//  Get Me There
//
//  Created by Monica Camorongan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CoreLocationController.h"

@class Route;
@interface ShowPrimaryDirection : UIViewController<CoreLocationControllerDelegate, CLLocationManagerDelegate> {
    UIImageView *directionImage;
    UIImageView *arrowImage;
    UIButton *panicCallButton;
    UIButton *nextDirButton;
    UIButton *prevDirButton;
    NSFetchedResultsController *_fetchedResultsController;
    NSString *routeName;
    NSInteger currentEvent;
}
@property (nonatomic, strong) CoreLocationController *locCtl;
@property (nonatomic) NSInteger currentEvent;
@property (nonatomic, strong) NSArray* eventsList;

@property (nonatomic, strong) IBOutlet UIImageView *directionImage;
@property (nonatomic, strong) IBOutlet UIImageView *arrowImage;
@property (nonatomic, strong) IBOutlet UIButton *panicCallButton;
@property (nonatomic, strong) IBOutlet UIButton *nextDirButton;
@property (nonatomic, strong) IBOutlet UIButton *prevDirButton;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *routeName;
@property (nonatomic, strong) CLLocation * currentPosition;

- (IBAction)contactListButtonPressed;
- (void)nextEvent;
- (void)previousEvent;
- (id)initWithRoute: (NSString *)route;
@end
