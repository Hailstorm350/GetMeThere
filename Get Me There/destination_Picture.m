//
//  destination_Picture.m
//  Get Me There
//
//  Created by joseph schneider on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "destination_Picture.h"
#import "Get_Me_ThereAppDelegate.h"
#import "Route.h"
@implementation destination_Picture

//@synthesize endImage, takePictureButton, selectFromLibrary,
@synthesize fetchedResultsController=_fetchedResultsController, context, inheritedRoute, imageURL;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    @autoreleasepool {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Route" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", inheritedRoute.Name];
        
        [fetchRequest setPredicate:predicate];   
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
        
    }
    return _fetchedResultsController;
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
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    endImage.image = [UIImage imageNamed:@"question_mark_sticker-p217885673497729412envb3_400.jpg"];

    self.title = @"Destination Picture";
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        takePictureButton.hidden = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    
	[self presentModalViewController:picker animated:YES];
    
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	endImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[endImage.image CGImage] orientation:(ALAssetOrientation)[endImage.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                //We have the URL!!!
                self.imageURL = [assetURL absoluteString];
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
    if(endImage.image==[UIImage imageNamed:@"question_mark_sticker-p217885673497729412envb3_400.jpg"]){
        NSString *msg = nil;
        
        msg = [[NSString alloc] initWithFormat: @"You must select a beginning image to continue."];
        UIAlertView *saveAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Incomplete Information"
                                  message:msg
                                  delegate:self cancelButtonTitle:@"OK" 
                                  otherButtonTitles:nil];
        [saveAlert show];
        
    }
    else {

        inheritedRoute.DestinationPicture=imageURL;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        //_fetchedResultsController =nil;
        [self.navigationController popViewControllerAnimated:YES];
        //To get information to pass on to the next screen//
    }
    
    
}

-(IBAction)cancelButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}




@end