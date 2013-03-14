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

@implementation RouteCreatorScreen
@synthesize takePictureButton, selectFromLibrary, homeImage, nameOfRoute;
@synthesize context, fetchedResultsController=_fetchedResultsController;
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
    //@autoreleasepool {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Route" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                                  initWithKey:@"Row" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest setFetchBatchSize:20];
        
        NSFetchedResultsController *theFetchedResultsController = 
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                            managedObjectContext:context sectionNameKeyPath:nil
                                                       cacheName:nil];
        self.fetchedResultsController = theFetchedResultsController;
        _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
        
        [sort release];
        [fetchRequest release];
        [theFetchedResultsController release];
        
        return _fetchedResultsController;    
    //}
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
        homeImage.image = [UIImage imageNamed:@"question_mark_sticker-p217885673497729412envb3_400.jpg"];

    self.title = @"Route Creation";
    
}

- (void)viewDidUnload {
    self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction) getPhoto{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    //	if((UIButton *) sender == selectFromLibrary) {
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //	} else {
    //		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //	}
    
	[self presentModalViewController:picker animated:YES];
    
}

-(IBAction) takePicture{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    //	if((UIButton *) sender == selectFromLibrary) {
    //   picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //	} else {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //	}
    
	[self presentModalViewController:picker animated:YES];
    
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	homeImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneButtonPressed
{
    if(homeImage.image==[UIImage imageNamed:@"question_mark_sticker-p217885673497729412envb3_400.jpg"]){
        NSString *msg = nil;
        
        msg = [[NSString alloc] initWithFormat: @"You must select a beginning image to continue."];
        UIAlertView *saveAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Incomplete Information"
                                  message:msg
                                  delegate:self cancelButtonTitle:@"OK" 
                                  otherButtonTitles:nil];
        [saveAlert show];
        [saveAlert release];
        [msg release];
        
    }
    else if(nameOfRoute.text.length>0){
        @autoreleasepool {

            Route *newRoute = [NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:context];

            newRoute.StartPicture = [NSData dataWithData:UIImagePNGRepresentation(homeImage.image)];
      
            newRoute.Name = nameOfRoute.text;
            NSError *error;

            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            //_fetchedResultsController = nil;
            
            //To get information to pass on to the next screen//
      
            //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            //NSEntityDescription *retrievedEntity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:context];
            //[fetchRequest setEntity:retrievedEntity];
            //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", nameOfRoute.text];
            
            //[fetchRequest setPredicate:predicate];
            //NSArray *array = [context executeFetchRequest:fetchRequest error:&error];

            //Route *info=[array objectAtIndex:0];
            
            
            
            
            Route_edit_screenViewController *information=[[Route_edit_screenViewController alloc]init];
            information.inheritedRoute=newRoute;
            
            [self.navigationController pushViewController:information animated:YES];
    
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                                        message:@"You must enter a route name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(IBAction)cancelButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneWithKeyboard{
    [nameOfRoute resignFirstResponder];
}

-(void)dealloc
{
    [super dealloc];
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
}

@end
