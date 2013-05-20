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

@synthesize context, fetchedResultsController=_fetchedResultsController;

@synthesize locCtl, mapView;

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
                                                   cacheName:@"Row"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
    
    
    return _fetchedResultsController;
}

- (IBAction) doneWithKeyboard{
    [descriptionOfEvent resignFirstResponder];
}

- (IBAction) doneButtonPressed: (id) sender{
    if([descriptionOfEvent.text length]<=0)
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
        eventObject.Name=descriptionOfEvent.text;
        //   newRoute.Picture=(NSValueTransformer *)imageView;
        if(goStraight.selectedSegmentIndex==1){
            eventObject.Arrow=@"straight";
        }
        else if(rightOrLeft.selectedSegmentIndex==1){
            if(sharpOrNormal.selectedSegmentIndex==1){
                eventObject.Arrow=@"left turn";
            }
            else{
                eventObject.Arrow=@"slight left";
            }
        }
        else if(rightOrLeft.selectedSegmentIndex==0){
            if(sharpOrNormal.selectedSegmentIndex==1){
                eventObject.Arrow=@"right turn";
            }
            else{
                eventObject.Arrow=@"slight right";
            }
        }
        if(transitStop.selectedSegmentIndex==0)           
            eventObject.Transit=[NSNumber numberWithBool:false];
        else{
            eventObject.Transit=[NSNumber numberWithBool:true];
        }
        
        NSNumber *newRow=[NSNumber numberWithInteger:indexRow];
        eventObject.Row= newRow;
        //[eventObject addRouteObject: finalInheritedRoute]; //TODO this needs to work for inverse in CoreData to function correctly
        [finalInheritedRoute addEventObject:eventObject];

        eventObject.Picture = imageURL;
        //NSLog(@"Event Picture URL is: %@", imageURL);
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", [eventObject Name]];
        
        [request setPredicate:predicate];
        
        NSError *error;
        
        NSArray *array = [context executeFetchRequest:request error:&error];
        Event *info=[array objectAtIndex:0];
        
        
        info.Name=descriptionOfEvent.text;
        if(goStraight.selectedSegmentIndex==1){
            info.Arrow=@"straight";
        }
        else if(rightOrLeft.selectedSegmentIndex==1){
            if(sharpOrNormal.selectedSegmentIndex==1){
                info.Arrow=@"Left";
            }
            else{
                info.Arrow=@"slight left";
            }
        }
        else if(rightOrLeft.selectedSegmentIndex==0){
            if(sharpOrNormal.selectedSegmentIndex==1){
                info.Arrow=@"Right";
            }
            else{
                info.Arrow=@"slight right";
            }
        }
        
        if(transitStop.selectedSegmentIndex==0) {
            info.Transit=[NSNumber numberWithBool:false];
        }
        else{
            info.Transit=[NSNumber numberWithBool:true];
        }    
        
        info.Picture=imageURL;
        
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

- (IBAction) goStraightControl{
    
}

- (IBAction) transitStopControl{
    //Handle Transit control event?
}

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
    
    if(eventObject == nil && isNewEvent) //New route!
        eventObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    
    if(!isNewEvent && [eventObject.Row integerValue] != indexRow){ //Not a new route

        descriptionOfEvent.text = eventObject.Name;
       
        //TODO replace all this crappy logic with something useful: redesign UI for picker
        if([eventObject.Arrow isEqualToString:@"straight"])
            goStraight.selectedSegmentIndex = 1;
        else if([eventObject.Arrow isEqualToString:@"slight right"]){
            rightOrLeft.selectedSegmentIndex = 0;
            sharpOrNormal.selectedSegmentIndex = 0;
            goStraight.selectedSegmentIndex = 0;
        }
        else if([eventObject.Arrow isEqualToString:@"Right"]){
            rightOrLeft.selectedSegmentIndex = 0;
            sharpOrNormal.selectedSegmentIndex = 1;
            goStraight.selectedSegmentIndex = 0;
        }
        else if([eventObject.Arrow isEqualToString:@"slight left"]){
            rightOrLeft.selectedSegmentIndex = 1;
            sharpOrNormal.selectedSegmentIndex = 0;
            goStraight.selectedSegmentIndex = 0;
        }
        else if([eventObject.Arrow isEqualToString:@"Left"]){
            rightOrLeft.selectedSegmentIndex = 1;
            sharpOrNormal.selectedSegmentIndex = 1;
            goStraight.selectedSegmentIndex = 0;
        }
        
        //Load the thumb image preview into view
        [self loadImgPreview:[NSURL URLWithString:imageURL]];
        
        if([eventObject.Transit compare:[NSNumber numberWithBool:NO]] == NSOrderedSame){
            transitStop.selectedSegmentIndex=0;
        }
        else
            transitStop.selectedSegmentIndex=1;
    }
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
    //mapView.mapType = MKMapTypeStandard;
    
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
}

- (BOOL) shouldAutorotate{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void) dealloc{
    
    _fetchedResultsController = nil;

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
//    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:10];
//    for (id annotation in mapView.annotations)
//        if (annotation != mapView.userLocation)
//            [toRemove addObject:annotation];
//    [mapView removeAnnotations:toRemove];
    [mapView removeAnnotations:[mapView annotations]];
    
    //Add annotation for current location
    [self dropPin:locCoord];
    for (id annotation in mapView.annotations) {
        NSLog(@"%@", annotation);
    }

}
- (void) dropPin:(CLLocationCoordinate2D)coord{
    // Place a single pin
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    [pin setCoordinate:coord];
    [self.mapView addAnnotation:pin];
}
@end

