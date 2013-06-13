//
//  ShowPrimaryDirection.m
//  Get Me There
//
//  Created by Monica Camorongan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowPrimaryDirection.h"
#import "Panic_button_primary.h"
#import "Event.h"
#import "Route.h"
#import "Get_Me_ThereAppDelegate.h"

@implementation ShowPrimaryDirection
@synthesize directionImage, arrowImage, panicCallButton, nextDirButton, prevDirButton, routeName, currentEvent, eventsList, currentPosition;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context;

CLLocationManager *locMgr;
NSArray* regionList;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"route.name=%@", routeName];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"sortOrder" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
    
    return _fetchedResultsController;
}

- (void)nextEvent {
    [self showAlertWithMessage:@"Next Event called"];
    
    if(currentEvent == eventsList.count-1){//Finish the route if they were on the last event.
        [self exitWithMessage:@"You have arrived. Please charge your phone!"];
    }else{ //Continue the route
        //Stop monitoring for current region
        [locMgr stopMonitoringForRegion:[regionList objectAtIndex:currentEvent]];
        //Increment the event
        currentEvent++;
        //Perform view setup
        [self viewSetup];
        //Begin monitoring next event region
        [locMgr startMonitoringForRegion: [regionList objectAtIndex:currentEvent] desiredAccuracy:kCLLocationAccuracyBestForNavigation];
    }
}

- (void)previousEvent {
    if([nextDirButton.titleLabel.text isEqualToString: @"Finish"])
        [nextDirButton setTitle:@"Next -->" forState:UIControlStateNormal];
    currentEvent -= 1;
    [self viewSetup];
}

- (BOOL)isLastEvent{
    return currentEvent == [[[[_fetchedResultsController sections] objectAtIndex:0] objects] count] - 1;
}

- (BOOL)isFirstEvent{
    return currentEvent == 0;
}

- (void)locationUpdate:(CLLocation *)location{
    currentPosition = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
}

- (void)locationError:(NSError *)error{
    //DO Stuff
}

- (void)setEventUIImage:(NSURL *)eventImageURL{
    __block UIImage * eventImage;
    //result block for eventImage
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage]; //  Thumbnail is not wanted

        if (iref) {
            eventImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:[rep orientation]];

            [[self directionImage] setImage: eventImage];
        }
    };

    
    //failure block for all cases
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Image Retrieval Error - %@",[myerror localizedDescription]);
    };
    
    //Fetch and retain start Image
    if(eventImageURL && [[eventImageURL absoluteString] length])
    {
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:eventImageURL
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRoute: (NSString *)route{
    self = [super init];
    if (self){
        currentEvent = 0;
        routeName = route;
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
	
    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
	NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    if(![CLLocationManager regionMonitoringAvailable]){
        UIAlertView *finishedAlert = [[UIAlertView alloc]
                                     initWithTitle:@"GPS Error"
                                     message:@"Region Monitoring is not available right now."
                                     delegate:self cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [locMgr stopUpdatingLocation];
        [self dismissModalViewControllerAnimated:YES];
        [finishedAlert show];
        return;
    }
    if(![CLLocationManager regionMonitoringEnabled]){
        UIAlertView *finishedAlert = [[UIAlertView alloc]
                                      initWithTitle:@"GPS Error"
                                      message:@"Region Monitoring is not enabled right now."
                                      delegate:self cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [locMgr stopUpdatingLocation];
        [self dismissModalViewControllerAnimated:YES];
        [finishedAlert show];
        return;
    }
    //Load events
    self.eventsList = [[[_fetchedResultsController sections] objectAtIndex:0] objects];
    
    //Start Location Services
    [self initializeLocationManager];
    regionList = [self setupRegions];

    
    [self initializeLocationUpdates];
    //we want all results from the location manager
	[locMgr setDistanceFilter:kCLDistanceFilterNone];

    currentEvent = [self determineFirstEvent];
    //NSLog(@"Current Event is: %d", currentEvent);
    //Monitor first region. TODO handle when user is inside of region radius
    [self initializeRegionMonitoring];
    
    [self viewSetup];
}

- (void)initializeLocationManager{
    // Check to ensure location services are enabled
    if(![CLLocationManager locationServicesEnabled]) {
        [self showAlertWithMessage:@"You need to enable location services to use this app."];
        return;
    }
    
    locMgr = [[CLLocationManager alloc] init];
    locMgr.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (![self.presentedViewController isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}


#pragma mark - View Logic

- (void)viewSetup{
    
    //Grab the current event for display
    Event *info=[eventsList objectAtIndex:currentEvent];
    
    //Show Direction Arrow
    arrowImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", info.direction]];
    
    //Show Event Picture
    [self setEventUIImage:[NSURL URLWithString:info.pictureURL]];
    
    if (self.isLastEvent){ //Is last event?
        [nextDirButton setTitle:@"Finish" forState:UIControlStateNormal];
        
        //TODO insert logic for handling completion of Route
    }
    if(self.isFirstEvent)           //Is first event?
        prevDirButton.hidden = YES;
    else
        prevDirButton.hidden = NO;
}

- (IBAction)contactListButtonPressed{
    Panic_button_primary * toPush = [[Panic_button_primary alloc] init];
    [self presentModalViewController:toPush animated:YES];
}

- (IBAction)exitNavigation{
    [self exit];
}

- (void)exit{
    [locMgr stopUpdatingLocation];
    [locMgr stopMonitoringSignificantLocationChanges];
    for(CLRegion *r in regionList)
        [locMgr stopMonitoringForRegion:r];
    if (![self.presentedViewController isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)exitWithMessage:(NSString*)message{
    UIAlertView *finishedAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Notification:"
                                  message:message
                                  delegate:self cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    [self exit];
    [finishedAlert show];
}

- (void)showAlertWithMessage:(NSString*)alertText{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Error"
                                                        message:alertText
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}


#pragma mark - Location Logic
- (NSArray *) setupRegions{
    NSMutableArray* tempList = [NSMutableArray array];
    //Establish CLRegions for event notification
    for(Event* e in eventsList){
        CLLocationDegrees radius = [e.radius doubleValue];
        if (radius > locMgr.maximumRegionMonitoringDistance) {
            radius = locMgr.maximumRegionMonitoringDistance;
        }
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([e.latitude doubleValue], [e.longitude doubleValue]);
        CLRegion* r = [[CLRegion alloc] initCircularRegionWithCenter:center radius:radius identifier:e.name];
        //NSLog(@"region: %@",r);
        [tempList addObject:r];
    }
    return [NSArray arrayWithArray:tempList];
}

- (int)determineFirstEvent{
    //Calculate distances
    float dist = FLT_MAX;
    float tempDist;
    int eventIndex = -1;
    
    //Find closest Event
    for (int i = 0; i < [eventsList count]; i++){
        Event* event = [eventsList objectAtIndex:i];
        CLLocation *newLoc = [self locationForEvent:event];
        tempDist = [self getCurrentDistanceToLocation: newLoc];
        //NSLog(@"Calculating dist to loc: %@", newLoc);
        //NSLog(@"Distance to event %@ is %f", event.name, tempDist);
        //[self showAlertWithMessage:[NSString stringWithFormat:@"Calculating dist to loc: %@", newLoc]]; //DEBUG
        //[self showAlertWithMessage:[NSString stringWithFormat:@"Distance to event %@ is %f", event.name, tempDist]]; //DEBUG
        if(tempDist < dist){
            dist = tempDist;
            eventIndex = i;
        }
    }
    //Abort if last event
    if(eventIndex == [eventsList count] - 1)
        return eventIndex;

    //Examine nearest vs Next to determine relative positioning
    Event *nearEvent = [eventsList objectAtIndex:eventIndex];
    CLLocation *nearEventLoc = [self locationForEvent:nearEvent];
    //Look at the next event so that 
    Event *nextEvent = [eventsList objectAtIndex:eventIndex + 1];
    CLLocation *nextEventLoc = [self locationForEvent:nextEvent];
    
    float distToNext = [self getCurrentDistanceToLocation:nextEventLoc];
    float distToNear = [self getCurrentDistanceToLocation:nearEventLoc];
    if(distToNext > distToNear) //Then user is behind nearest event
        return eventIndex;
    
    return eventIndex + 1; //The user is between nearest event and next event
}

- (CLLocation*)locationForEvent:(Event*) event{
    return [[CLLocation alloc] initWithLatitude:(CLLocationDegrees) [event.latitude doubleValue] longitude:(CLLocationDegrees) [event.longitude doubleValue]];
}

- (float)getCurrentDistanceToLocation: (CLLocation*) location{
    //CLLocation* curLocation = [locMgr location]; //Why is this always null?
    //NSLog(@"getDist: %@ to %@",curLocation, location);
    return [location distanceFromLocation:[locMgr location]];
}

- (void)initializeLocationUpdates {
    [locMgr startUpdatingLocation];
    //we want it to be as accurate as possible
	//regardless of how much time/power it takes
	[locMgr setDesiredAccuracy:kCLLocationAccuracyBest];
    [locMgr startMonitoringSignificantLocationChanges];
}

- (void)initializeRegionMonitoring{
    
    if (locMgr == nil) {
        [NSException raise:@"Location Manager Not Initialized" format:@"You must initialize location manager first."];
    }
    
    if(![CLLocationManager regionMonitoringAvailable]) {
        [self showAlertWithMessage:@"This app requires region monitoring features which are unavailable on this device."];
        return;
    }
    
    [locMgr startMonitoringForRegion:[regionList objectAtIndex:currentEvent] desiredAccuracy:kCLLocationAccuracyBestForNavigation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self locationError:error];
	}
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    if([self conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        NSLog(@"Entered a Region");
        //Remove the previous region from monitoring
        [locMgr stopMonitoringForRegion:region];
        //Start monitoring the next region, and perform view setup
        [self nextEvent];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    [self showAlertWithMessage:[error localizedDescription]]; //DEBUG

    NSLog(@"Region monitoring failed with error: %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started monitoring %@ region", region.identifier);
}
@end
