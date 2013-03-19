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
    IBOutlet UITextField *descriptionOfEvent;
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
-(IBAction) getPhoto;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, strong) Route_edit_screenViewController *viewContollerData;

@property (nonatomic) NSUInteger indexRow;
@property(nonatomic, strong) NSString *givenName;
//this is what will update on "DONE"
//@property (nonatomic,retain) IBOutlet UISegmentedControl *rightOrLeft;
//@property (nonatomic,retain) IBOutlet UISegmentedControl *sharpOrNormal;
//@property (nonatomic,retain) IBOutlet UISegmentedControl *goStraight;
//@property (nonatomic,retain) IBOutlet UISegmentedControl *transitStop;
@property (nonatomic) BOOL newEvent;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Route *finalInheritedRoute;
@property (nonatomic, strong) Event *inheritedEvent;
//@property (nonatomic, retain) IBOutlet UIImageView *imageView;
//@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
//@property (nonatomic, retain) IBOutlet UIButton *selectFromLibrary;
@property (nonatomic, strong) NSString *imageURL;

@end
