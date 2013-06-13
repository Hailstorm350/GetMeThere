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
#import <MapKit/MapKit.h>
#import "CoreLocationController.h"


@class Route_edit_screenViewController;
@class Route;
@class Event;

@interface edit_modal_screen : UIViewController<UIImagePickerControllerDelegate, CoreLocationControllerDelegate, MKMapViewDelegate>
{
    MKMapView *mapView;
    IBOutlet UITextField *descriptionOfEvent;
    UISegmentedControl *transitStop;
    NSFetchedResultsController *_fetchedResultsController;
    UIImageView *imageView;
	UIButton *takePictureButton;
	UIButton *selectFromLibrary;
    IBOutlet UILabel* turnTransitLabel;
    IBOutlet UIButton* transitToggleButton;
    IBOutlet UISlider* rangeSlider;
    IBOutlet UILabel* rangeLabel;
    IBOutlet UISlider* turnSlider;
    IBOutlet UILabel* turnTypeLabel;
    IBOutlet UISegmentedControl* transitSegCtl;
}

-(IBAction) saveLocation;
-(IBAction) doneWithKeyboard;
-(IBAction) doneButtonPressed: (id) sender;
-(IBAction) cancelButtonPressed: (id)sender;
-(IBAction) takePicture;
-(IBAction) transitToggle;
-(IBAction) rangeSliderChange:(id)sender;
-(IBAction) turnSliderChange:(id)sender;
-(NSString*) getTurnType;

@property (nonatomic, strong) IBOutlet UILabel* turnTransitLabel;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) Route_edit_screenViewController *viewContollerData;
@property (nonatomic, strong) CoreLocationController *locCtl;
@property (nonatomic) NSUInteger indexRow;
@property (nonatomic) BOOL isNewEvent;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Route *finalInheritedRoute;
@property (nonatomic, strong) Event *eventObject;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property BOOL isTransit;
@property (nonatomic, strong) IBOutlet UIButton* transitToggleButton;
@property (nonatomic, strong) IBOutlet UISlider* rangeSlider;
@property (nonatomic, strong) IBOutlet UILabel* rangeLabel;
@property (nonatomic, strong) IBOutlet UISlider* turnSlider;
@property (nonatomic, strong) IBOutlet UILabel* turnTypeLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl* transitSegCtl;

@end
