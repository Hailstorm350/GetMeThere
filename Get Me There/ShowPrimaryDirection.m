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
@synthesize directionImage, arrowImage, panicCallButton, nextDirButton, prevDirButton, routeName, currentEvent;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context;
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"route.Name=%@", routeName];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"Row" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
    
    return _fetchedResultsController;
}

- (IBAction)contactListButtonPressed {
    Panic_button_primary * toPush = [[Panic_button_primary alloc] init];
    [self.navigationController pushViewController: toPush animated:YES];
//    [toPush release];
}
- (IBAction)nextButtonPressed {
    //Finish the route
    if([nextDirButton.titleLabel.text isEqualToString: @"Finish"]){
        UIAlertView *finishedAlert = [[UIAlertView alloc]
                                  initWithTitle:@"You have arrived!"
                                  message:@"You have arrived. Please charge your phone!"
                                  delegate:self cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        
        [self dismissModalViewControllerAnimated:YES];
        [finishedAlert show];
    }else{ //Continue the route
        currentEvent += 1;
        [self viewLogic];
    }
}

- (IBAction)prevButtonPressed {
    if([nextDirButton.titleLabel.text isEqualToString: @"Finish"])
        [nextDirButton setTitle:@"Next -->" forState:UIControlStateNormal];
    currentEvent -= 1;
    [self viewLogic];
}

-(BOOL)isLastEvent{
    return currentEvent == [[[[_fetchedResultsController sections] objectAtIndex:0] objects] count] - 1;
}
-(BOOL)isFirstEvent{
    return currentEvent == 0;
}
-(void)viewLogic{
    
    //Grab the current event for display
    Event *info=[[[[_fetchedResultsController sections] objectAtIndex:0] objects] objectAtIndex:currentEvent];
    
    //Show Direction Arrow
    arrowImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", info.Arrow]];
    
    //Show Event Picture
    [self setDestinationUIImage:[NSURL URLWithString:info.Picture]];
    
    if (self.isLastEvent){ //Is last event?
        [nextDirButton setTitle:@"Finish" forState:UIControlStateNormal];
        
        //TODO insert logic for handling completion of Route
    }
    if(self.isFirstEvent)           //Is first event?
        prevDirButton.hidden = YES;
    else
        prevDirButton.hidden = NO;
}

-(void)setDestinationUIImage:(NSURL *)eventImageURL
{
    __block UIImage * eventImage;
    //result block for eventImage
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage]; //  Thumbnail is not wanted
        
        if (iref) {
            eventImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation: 0];
            
            [[self directionImage] setImage: eventImage];
//            [eventImage retain];
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRoute: (NSString *)route
{
    self = [super init];
    if (self){
        currentEvent = 0;
        routeName = route;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
	NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1); 
    }
    
    [self viewLogic];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL) shouldAutorotate{
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

@end
