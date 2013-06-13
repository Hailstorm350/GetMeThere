//
//  RouteCreatorScreen.m
//  Get Me There
//
//  Created by joseph schneider on 4/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteCreatorScreen.h"
#import "Route_edit_screenViewController.h"
#import "Get_Me_ThereAppDelegate.h"
#import "Route.h"
#import "CameraOverlayView.h"

@implementation RouteCreatorScreen
//@synthesize takePictureButton, selectFromLibrary, homeImage, nameOfRoute;
@synthesize context, fetchedResultsController=_fetchedResultsController;
@synthesize imageURL;
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
                                   entityForName:@"Route" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"sortOrder" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:self.context sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
    
    return _fetchedResultsController;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    if(homeImage.image == nil)
        homeImage.image = [UIImage imageNamed:@"placeholder.jpg"];

    self.title = @"Route Creation";
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        takePictureButton.hidden = YES; //TODO maybe just exit here? no camera should mean no usage
}

- (void)viewDidUnload {
    //self.fetchedResultsController = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
-(IBAction) getPhoto{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

	[self presentModalViewController:picker animated:YES];
    
}

-(IBAction) takePicture{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.cameraOverlayView = [[CameraOverlayView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self presentModalViewController:picker animated:YES];
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	homeImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[homeImage.image CGImage] orientation:(ALAssetOrientation)[homeImage.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                //We have the URL!!!
                self.imageURL = [assetURL absoluteString];
                NSLog(@"StartURL is: %@", self.imageURL); //DEBUG
            }
        }];
    } else {
        self.imageURL = [[info objectForKey: UIImagePickerControllerReferenceURL] absoluteString];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneButtonPressed
{
    if(homeImage.image==[UIImage imageNamed:@"placeholder.jpg"]){
        NSString *msg = nil;
        
        msg = [[NSString alloc] initWithFormat: @"You must select a beginning image to continue."];
        UIAlertView *saveAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Incomplete Information"
                                  message:msg
                                  delegate:self cancelButtonTitle:@"OK" 
                                  otherButtonTitles:nil];
        [saveAlert show];
        
    }
    else if(nameOfRoute.text.length>0){
        
        Route *newRoute = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:context];
        NSLog(@"inRouteCreator: StartPictureURL: %@\n imageURL: %@\n",newRoute.startPictureURL, imageURL); //DEBUG
        newRoute.startPictureURL = imageURL;
        
        newRoute.name = nameOfRoute.text;
        
        NSError *error;

        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }

        Route_edit_screenViewController *information=[[Route_edit_screenViewController alloc] init];
        information.inheritedRoute=newRoute;
        
        [self.navigationController pushViewController:information animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                                        message:@"You must enter a route name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
//        [alert release];
    }
}

-(IBAction)cancelButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneWithKeyboard{
    [nameOfRoute resignFirstResponder];
}

//-(void)dealloc
//{
//    [nameOfRoute release], nameOfRoute = nil;
//    [homeImage release], homeImage = nil;
//    [takePictureButton release], takePictureButton = nil;
//    [selectFromLibrary release], selectFromLibrary = nil;
//    [context release], context = nil;
//    [_fetchedResultsController release], _fetchedResultsController = nil;
//    [self.fetchedResultsController release], self.fetchedResultsController = nil;
//    [super dealloc];
//
//}
- (BOOL) shouldAutorotate{
    return NO;
}
@end
