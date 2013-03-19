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
@class Events_list;
@class  Route_edit_screenViewController;
@class Route;
@class Event;
@interface edit_modal_screen : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    UITextField *descriptionOfEvent;
    UISegmentedControl *rightOrLeft;
    UISegmentedControl *transitStop;
    UISegmentedControl *goStraight;
    UISegmentedControl *sharpOrNormal;
    NSArray *_events;
    NSFetchedResultsController *_fetchedResultsController;
    UIImageView *imageView;
	UIButton *takePictureButton;
	UIButton *selectFromLibrary;
    
}
-(IBAction) doneWithKeyboard;
-(IBAction) doneButtonPressed: (id) sender;
-(IBAction) cancelButtonPressed: (id)sender;
-(IBAction) takePicture;
-(IBAction) rightOrLeftControl;
-(IBAction) sharpOrNormalControl;
-(IBAction) goStraightControl;
-(IBAction) transitStopControl;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerInherited;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) Route_edit_screenViewController *viewContollerData;
@property (nonatomic, retain) Events_list *modalScreenEventData;
@property (nonatomic) NSUInteger indexRow;
@property(nonatomic, retain) NSString *givenName;
//this is what will update on "DONE"
@property (nonatomic,retain) IBOutlet UISegmentedControl *rightOrLeft;
@property (nonatomic,retain) IBOutlet UISegmentedControl *sharpOrNormal;
@property (nonatomic,retain) IBOutlet UISegmentedControl *goStraight;
@property (nonatomic,retain) IBOutlet UISegmentedControl *transitStop;
@property (nonatomic) BOOL newEvent;
@property (nonatomic, retain) NSArray *events;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, retain) Route *finalInheritedRoute;
@property (nonatomic, retain) Event *inheritedEvent;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *selectFromLibrary;
@property (nonatomic, strong) NSString *imageURL;
-(IBAction) getPhoto;
@end
