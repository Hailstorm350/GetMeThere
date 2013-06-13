//
//  edit_modal_screen.m
//  Get Me There
//
//  Created by joseph schneider on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "edit_modal_screen.h"
#import "Event_class.h"
#import "Events_list.h"
#import "Route_edit_screenViewController.h"
#import "Event.h"
#import "Route.h"
#import "Get_Me_ThereAppDelegate.h"
//#import "CameraOverlayView.h"

@implementation edit_modal_screen

@synthesize finalInheritedRoute;

@synthesize isNewEvent, indexRow, viewContollerData, imageURL, eventObject;

@synthesize context, fetchedResultsController = _fetchedResultsController;

@synthesize locCtl, mapView, turnTransitLabel, isTransit, transitToggleButton;

@synthesize rangeSlider, rangeLabel, turnTypeLabel, turnSlider, transitSegCtl;

CLLocationCoordinate2D locCoord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Event" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"details.closeDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:context sectionNameKeyPath:nil
                                                   cacheName:@"sortOrder"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
    
    
    return _fetchedResultsController;
}

- (IBAction) doneWithKeyboard{
    [descriptionOfEvent resignFirstResponder];
}

- (IBAction) doneButtonPressed: (id) sender{
    if([descriptionOfEvent.text length] <= 0)//TODO ENABLE FOR DEPLOY || imageURL == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                                        message:@"You must enter a an event description"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(isNewEvent)
    {
        eventObject.name=descriptionOfEvent.text;

        eventObject.direction = [self getTurnType];
        //TODO implement turn storage
        
        if(transitStop.selectedSegmentIndex==0)
            eventObject.isTransit=[NSNumber numberWithBool:false];
        else{
            eventObject.isTransit=[NSNumber numberWithBool:true];
        }
        
        NSNumber *newRow=[NSNumber numberWithInteger:indexRow];
        eventObject.sortOrder= newRow;
        //[eventObject addRouteObject: finalInheritedRoute]; //TODO this needs to work for inverse in CoreData to function correctly
        [finalInheritedRoute addEventObject:eventObject];

        eventObject.pictureURL = imageURL;
        
        eventObject.radius = [NSNumber numberWithFloat:[self.rangeSlider value] * 20];
        NSLog(@"Radius saved as: %f meters", [eventObject.radius doubleValue]);
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
        
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", [eventObject name]];
        
        [request setPredicate:predicate];
        
        NSError *error;
        
        NSArray *array = [context executeFetchRequest:request error:&error];
        Event *info=[array objectAtIndex:0];
        
        
        info.name=descriptionOfEvent.text;
        
        eventObject.direction = [self getTurnType];
        
        if(transitStop.selectedSegmentIndex==0) {
            info.isTransit=[NSNumber numberWithBool:false];
        }
        else{
            info.isTransit=[NSNumber numberWithBool:true];
        }
        
        eventObject.radius = [NSNumber numberWithFloat:[self.rangeSlider value] * 20];
        NSLog(@"Radius saved as: %f meters", [eventObject.radius doubleValue]);
        info.pictureURL=imageURL;
        
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction) cancelButtonPressed: (id) sender{
        [self dismissViewControllerAnimated:YES completion:nil];
}

//THIS IS DISABLED BECAUSE IT WAS DECIDED TO NOT ALLOW PHOTO PICKING
//-(IBAction) getPhoto{
//	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//	picker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) self;
//    
//    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//	[self presentModalViewController:picker animated:YES];
//    
//}

-(IBAction) takePicture{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) self;
    
    //CameraOverlayView *overlay = [[CameraOverlayView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.cameraOverlayView = overlay;
	[self presentModalViewController:picker animated:YES];
    
}

#pragma mark - 

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[imageView.image CGImage] orientation:(ALAssetOrientation)[imageView.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                self.imageURL = [assetURL absoluteString];
            }
        }];
    } else {
        self.imageURL = [[info objectForKey: UIImagePickerControllerReferenceURL] absoluteString];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)  picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) rightOrLeftControl{
    
}

- (IBAction) sharpOrNormalControl{
    
}

- (IBAction) transitToggle{
    //Toggle to/from Transit event mode
    if(!isTransit){
        [turnTransitLabel setText:@"Transit:"];
        [transitToggleButton setTitle:@"Make Turn" forState:UIControlStateNormal];
        [transitToggleButton setTitle:@"Make Turn" forState:UIControlStateHighlighted];
        
//        [rightOrLeft setTitle:@"Pull Cord" forSegmentAtIndex:0];
//        [rightOrLeft setTitle:@"Take Exit" forSegmentAtIndex:1];
//        
//        [rightOrLeft setWidth:85 forSegmentAtIndex:0];
//        [rightOrLeft setWidth:85 forSegmentAtIndex:1];
//        
//        [sharpOrNormal setHidden:YES];
        isTransit = true;
    }else{
        [turnTransitLabel setText:@"Turn:"];
        [transitToggleButton setTitle:@"Make Transit" forState:UIControlStateNormal];
        [transitToggleButton setTitle:@"Make Transit" forState:UIControlStateHighlighted];
//        [rightOrLeft setTitle:@"Right" forSegmentAtIndex:0];
//        [rightOrLeft setTitle:@"Left" forSegmentAtIndex:1];
//        [rightOrLeft setWidth:75 forSegmentAtIndex:0];
//        [rightOrLeft setWidth:75 forSegmentAtIndex:1];
//        [sharpOrNormal setHidden:NO];
        isTransit = false;
    }
}

- (IBAction) rangeSliderChange:(id)sender{
    int meters = (int)([(UISlider*) sender value] * 20);
    [rangeLabel setText:[NSString stringWithFormat:@"%d Meters", meters]];
}

- (IBAction) turnSliderChange:(id)sender{
    [turnTypeLabel setText:[self getTurnType]];
}

- (NSString*) getTurnType{
    NSString * retStr;
    float val = [turnSlider value];
    if(val < .2){ //Left Turn
        retStr = @"Left";
    }else if(val < .4){ //Slight Left Turn
        retStr = @"Slight Left";
    }else if(val < .6){ //Go Straight
        retStr = @"Straight";
    }else if(val < .8){ //Slight Right Turn
        retStr = @"Slight Right";
    }else{ //Right Turn
        retStr = @"Right";
    }
    return retStr;
}

//- (float) yardsToMeters:(NSNumber*) yards{
//    return [yards floatValue] * .914;
//}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad{
    
    [super viewDidLoad];

    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    if(eventObject == nil && isNewEvent){ //New route!
        eventObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        //MKCircle *circle = [MKCircle circleWithCenterCoordinate:locCoord radius:10];
        //[mapView addOverlay:circle];
    }
    if(!isNewEvent && [eventObject.sortOrder integerValue] != indexRow){ //Not a new route
        descriptionOfEvent.text = eventObject.name;
        MKCircle *circle = [MKCircle circleWithCenterCoordinate: CLLocationCoordinate2DMake((CLLocationDegrees)[eventObject.latitude floatValue], (CLLocationDegrees) [eventObject.longitude floatValue]) radius:[eventObject.radius floatValue]];
        [mapView addOverlay:circle];
        //Load the thumb image preview into view
        [self loadImgPreview:[NSURL URLWithString:imageURL]];
        [self.rangeSlider setValue:([[eventObject radius] floatValue]/20)];
    }
    [self rangeSliderChange:self.rangeSlider];
    self.title = @"Event";
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        takePictureButton.hidden = YES;
    
    //Start and configure Location Services
    locCtl = [[CoreLocationController alloc] init];
    locCtl.delegate = self;
    [locCtl.locMgr setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [locCtl.locMgr startUpdatingLocation];
    
    //Set up Map View
    mapView.delegate = self;
    
    //Show user location if new event, or pin on event location
    MKCoordinateRegion region;
    
    if(isNewEvent){
        mapView.showsUserLocation = YES;
        region = MKCoordinateRegionMakeWithDistance (
                                            mapView.userLocation.location.coordinate, 50, 50);
    }else{
        // Place a single pin
        [self dropPin:[eventObject getLocationAsCLCoordinate]];
        
        region = MKCoordinateRegionMakeWithDistance(eventObject.getLocationAsCLCoordinate, 50, 50);
    }
    [mapView setRegion:region animated:NO];
//    [rightOrLeft setFrame:CGRectMake(17, 210, 150, 30)];
//    [sharpOrNormal setFrame:CGRectMake(17, 240, 150, 30)];

    if(eventObject.isTransit){
        isTransit = true;
        [self.transitToggleButton setTitle:@"Make Turn" forState:UIControlStateNormal];
        [self.transitToggleButton setTitle:@"Make Turn" forState:UIControlStateHighlighted];

        [transitSegCtl setHidden:NO];
        [turnSlider setHidden:YES];
    }
    else{
        isTransit = false;
        [self.transitToggleButton setTitle:@"Make Transit" forState:UIControlStateNormal];
        [self.transitToggleButton setTitle:@"Make Transit" forState:UIControlStateHighlighted];
    }
    
    [turnTransitLabel setText:(isTransit ? @"Transit:" : @"Turn:")];
}

- (BOOL) shouldAutorotate{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void) loadImgPreview:(NSURL *)thumbURL{
    __block UIImage * thumbUIImage;
    //result block for startImage
    ALAssetsLibraryAssetForURLResultBlock thumbresultblock = ^(ALAsset *myasset)
    {
        //ALAssetRepresentation *rep = [myasset defaultRepresentation];    // Change to commented lines when
        CGImageRef iref = [myasset thumbnail];//[rep fullResolutionImage]; //  Thumbnail is not wanted
        
        if (iref) {
            thumbUIImage = [UIImage imageWithCGImage:iref];
            
            [imageView setImage: thumbUIImage];
        }
    };
    
    //failure block for all cases
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Image Retrieval Error - %@",[myerror localizedDescription]);
    };
    
    //Fetch and retain thumbnail
    if(thumbURL && [[thumbURL absoluteString] length])
    {
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:thumbURL
                       resultBlock:thumbresultblock
                      failureBlock:failureblock];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Stop updating location and save battery life.
    [locCtl.locMgr stopUpdatingLocation];
}

#pragma mark - Map View functionality

- (void) mapView:(MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void) locationError:(NSError *)error{
    //Log the location error
    NSLog(@"%@", [error description]);
}

- (void) locationUpdate:(CLLocation *)location{
    //Update location data to be current
    locCoord.latitude = location.coordinate.latitude;
    locCoord.longitude = location.coordinate.longitude;
}

- (IBAction) saveLocation{
    //save the location to our event object
    [eventObject setLocation:locCoord];
    
    //Clear existing annotations
    [mapView removeAnnotations:[mapView annotations]];
    
    //Add annotation for current location
    [self dropPin:locCoord];
    //Set Center of MapView to new Pin
    self.mapView.centerCoordinate = locCoord;
}

- (void) dropPin:(CLLocationCoordinate2D)coord{
    // Place a single pin
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    [pin setCoordinate:coord];
    [self.mapView addAnnotation:pin];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}
@end

