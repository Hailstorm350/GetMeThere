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
    @autoreleasepool {
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

        [sort release];
        [fetchRequest release];
        [theFetchedResultsController release];
        
        return _fetchedResultsController;
    }
}

- (IBAction)contactListButtonPressed {
    
    [self.navigationController pushViewController:[[Panic_button_primary alloc] init] animated:YES];
}
- (IBAction)nextButtonPressed {
    currentEvent += 1;
    
    [self viewLogic];
}

- (IBAction)prevButtonPressed {
    currentEvent -= 1;
    
    [self viewLogic];
}

-(void)viewLogic{
    
    //Grab the current event for display
    Event *info=[[[[_fetchedResultsController sections] objectAtIndex:0] objects] objectAtIndex:currentEvent];
    
    //Show Direction Arrow
    arrowImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", info.Arrow]];
    
    //Show Event Picture
    [self setDestinationUIImage:[NSURL URLWithString:info.Picture]];
    
    int isLastEvent = [[[[_fetchedResultsController sections] objectAtIndex:0] objects] count] - 1;
    if (currentEvent == isLastEvent){ //Is last event?
        nextDirButton.hidden = YES;
        //TODO insert logic for handling completion of Route
    }
    if(currentEvent == 0)           //Is first event?
        prevDirButton.hidden = YES;
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
            eventImage = [UIImage imageWithCGImage:iref];
            
            [[self directionImage] setImage: eventImage];
            [eventImage retain];
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
        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
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
    NSLog(@"currentEvent is: %d", currentEvent);
    [self viewLogic];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//We only want to support Landscape Orientations
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


- (void) viewWillAppear:(BOOL)animated {
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft]; //TODO Why does this still work?
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

@end
