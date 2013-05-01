//
//  edit_modal_screen.h
//  Get Me There
//
//  Created by joseph schneider on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "CoreLocationController.h"


@class Route_edit_screenViewController;
@class Route;
@class Event;

@interface edit_modal_screen : UIViewController<UIImagePickerControllerDelegate, CoreLocationControllerDelegate >
{
    IBOutlet UITextField *descriptionOfEvent;
    UISegmentedControl *rightOrLeft;
    UISegmentedControl *transitStop;
    UISegmentedControl *goStraight;
    UISegmentedControl *sharpOrNormal;
    NSFetchedResultsController *_fetchedResultsController;
    UIImageView *imageView;
	UIButton *takePictureButton;
	UIButton *selectFromLibrary;
}

-(IBAction) saveLocation;
-(IBAction) doneWithKeyboard;
-(IBAction) doneButtonPressed: (id) sender;
-(IBAction) cancelButtonPressed: (id)sender;
-(IBAction) takePicture;
-(IBAction) rightOrLeftControl;
-(IBAction) sharpOrNormalControl;
-(IBAction) goStraightControl;
-(IBAction) transitStopControl;
-(IBAction) getPhoto;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) Route_edit_screenViewController *viewContollerData;
@property (nonatomic, strong) CoreLocationController *locCtl;
@property (nonatomic) NSUInteger indexRow;
@property (nonatomic) BOOL isNewEvent;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Route *finalInheritedRoute;
@property (nonatomic, strong) Event *eventObject;
@property (nonatomic, strong) NSString *imageURL;

@end
