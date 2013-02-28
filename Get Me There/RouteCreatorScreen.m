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
@synthesize context=_context, fetchedResultsController=_fetchedResultsController;
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
    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Route" inManagedObjectContext:thisContext];    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"Row" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:thisContext sectionNameKeyPath:nil 
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    //_fetchedResultsController.delegate = self;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
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
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    self.title = @"Failed Banks";
    
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
    
	[self presentViewController:picker animated:YES completion:nil];
    
}

-(IBAction) takePicture{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    //	if((UIButton *) sender == selectFromLibrary) {
    //   picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //	} else {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //	}
    
	[self presentViewController:picker animated:YES completion:nil];
    
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
    if(nameOfRoute.text.length>0){
        NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
        Route *newInfo=[NSEntityDescription insertNewObjectForEntityForName:@"Route" inManagedObjectContext:thisContext];
    /*    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:thisContext];
        
        [request setEntity:entity];

*/      newInfo.Name=nameOfRoute.text;
        NSError *error;

        if (![thisContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }

        
        //To get information to pass on to the next screen//
      
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *retrievedEntity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:thisContext];
        [fetchRequest setEntity:retrievedEntity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", nameOfRoute.text];
        
        [fetchRequest setPredicate:predicate];   
        NSArray *array = [thisContext executeFetchRequest:fetchRequest error:&error];
        NSLog(@"upon saving a new route, the count of the array is %d", [array count]);

        Route *info=[array objectAtIndex:0];

  /*      
        if([array count]==1){
            info=[array objectAtIndex:0];
            [_fetchedResultsController.fetchRequest setPredicate:predicate];
        }
*/
        NSLog(@"the saved object is %@", info.Name);
        
        
        
        
        Route_edit_screenViewController *information=[[Route_edit_screenViewController alloc]init];
        information.inheritedRoute=info;
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
