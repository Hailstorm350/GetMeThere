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
//#import "Revised_Route_Edit_ScreenAppDelegate.h" 
#import "Get_Me_ThereAppDelegate.h"
@implementation edit_modal_screen


@synthesize imageView;
@synthesize takePictureButton;
@synthesize selectFromLibrary;
@synthesize finalInheritedRoute;
@synthesize textField, rightOrLeft, sharpOrNormal, transitStop, goStraight, newEvent, indexRow, givenName, viewContollerData, modalScreenEventData, inheritedEvent;

@synthesize events=_events, context=_context, fetchedResultsController=_fetchedResultsController, fetchedResultsControllerInherited;

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
                                   entityForName:@"Event" inManagedObjectContext:thisContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"details.closeDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:thisContext sectionNameKeyPath:nil 
                                                   cacheName:@"Row"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = theFetchedResultsController.delegate;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}


-(IBAction)doneWithKeyboard{
    [descriptionOfEvent resignFirstResponder];
}
-(IBAction) doneButtonPressed: (id) sender{
    if([textField.text length]<=0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                                        message:@"You must enter a an event description"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if(newEvent)
    {
        NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
        Event *newInfo=[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:thisContext];
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:thisContext];
        
        [request setEntity:entity];
        
        newInfo.Name=textField.text;
        //   newInfo.Picture=(NSValueTransformer *)imageView;
        if(goStraight.selectedSegmentIndex==1){
            newInfo.Arrow=@"straight";
        }
        else if(rightOrLeft.selectedSegmentIndex==1){
            if(sharpOrNormal.selectedSegmentIndex==1){
                newInfo.Arrow=@"Left";
            }
            else{
                newInfo.Arrow=@"slight left";
            }
        }
        else if(rightOrLeft.selectedSegmentIndex==0){
            if(sharpOrNormal.selectedSegmentIndex==1){
                newInfo.Arrow=@"Right";
            }
            else{
                newInfo.Arrow=@"slight right";
            }
        }
        if(transitStop.selectedSegmentIndex==0)           
            newInfo.Transit=[NSNumber numberWithBool:false];
        else{
            newInfo.Transit=[NSNumber numberWithBool:true];
        }
        NSLog(@"the inherited row is %d", indexRow);
        NSNumber *newRow=[NSNumber numberWithInteger:indexRow];
        newInfo.Row= newRow;
        newInfo.route=finalInheritedRoute;
        NSLog(@"the new event's route is %@, but the inherited route is %@", newInfo.route.Name, finalInheritedRoute.Name);
        NSData* coreDataImage=[NSData dataWithData:UIImagePNGRepresentation(imageView.image)];
        newInfo.Picture=coreDataImage;
        NSError *error;
        if (![thisContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        //        NSLog(@"newInfo.transit=%i, newInfo.arrow=%@, newInfo.name=%@", newInfo.Transit, newInfo.Arrow, newInfo.Name);
              
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        
        NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
        
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:thisContext];
        
        [request setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", givenName];
        
        [request setPredicate:predicate];
        
        NSError *error;
        
        NSArray *array = [thisContext executeFetchRequest:request error:&error];
        Event *info=[array objectAtIndex:0];
        
        //        Event *newInfo=[NSEntityDescription atIndexPath:@"Event" inManagedObjectContext:thisContext];
        
        //  info.Picture=(NSValueTransformer *)imageView;
        
        info.Name=textField.text;
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
        NSData* coreDataImage=[NSData dataWithData:UIImagePNGRepresentation(imageView.image)];
        info.Picture=coreDataImage;
        
        if (![thisContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    
}


-(IBAction) cancelButtonPressed: (id) sender{
//    [self.parentViewController dismissModalViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
}
/*
 -(IBAction) takePicture{
 //http://www.iphonedevsdk.com/forum/iphone-sdk-development/42457-save-image-core-data.html
 UIImagePickerController *picker =
 [[UIImagePickerController alloc] init];
 picker.delegate = self;
 picker.allowsImageEditing = YES;
 picker.sourceType = (sender == takePictureButton) ?
 UIImagePickerControllerSourceTypeCamera :
 UIImagePickerControllerSourceTypeSavedPhotosAlbum;
 [self presentModalViewController:picker animated:YES];
 [picker release];
 
 }
 
 - (IBAction)selectExistingPicture {
 if([UIImagePickerController isSourceTypeAvailable:
 UIImagePickerControllerSourceTypePhotoLibrary])
 {
 UIImagePickerController *picker= [[UIImagePickerController alloc]init];
 picker.delegate = self;
 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
 [self presentModalViewController:picker animated:YES];
 [picker release];
 }
 }
 */
-(IBAction) getPhoto{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    //	if((UIButton *) sender == selectFromLibrary) {
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //	} else {
    //		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //	}
    
	[self presentViewController:picker animated:YES completion: nil];
    
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
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/*
 - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
 [picker dismissModalViewControllerAnimated:YES];
 }
 */
-(IBAction) rightOrLeftControl{
    
}
-(IBAction) sharpOrNormalControl{
    
}
-(IBAction) goStraightControl{
    
}
-(IBAction) transitStopControl{
    
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void)viewDidLoad{
    
    [super viewDidLoad];
    //    if (![UIImagePickerController isSourceTypeAvailable:
    //		  UIImagePickerControllerSourceTypeCamera]) {
    //		takePictureButton.hidden = YES;
    //		selectFromCameraRollButton.hidden = YES;
    //	}
    
/*    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:thisContext];
    
    [request setEntity:entity];
*/    if([inheritedEvent.Row integerValue]!=indexRow){
    NSLog(@"It's not a new route!");
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", givenName];
        
  //      [request setPredicate:predicate];
        
    //    NSError *error = nil;
        
    //    NSArray *array = [thisContext executeFetchRequest:request error:&error];
    //    if([array count]==1){
            Event *info=inheritedEvent;
        NSLog(@"I'm passing to the modal screen the event %@, which has the properties %@", info.Name, info.Transit);

  //          [_fetchedResultsController.fetchRequest setPredicate:predicate];
            textField.text=info.Name;
            //      imageView.image=(UIImage *)info.Picture;
            //        NSData* Picture = [NSData dataWithData:UIImagePNGRepresentation(imageView.image)];
            //       imageView = [UIImage imageWithData:info.Picture];
            
            //    NSData *Picture = UIImagePNGRepresentation(yourUIImage);
            //   [newManagedObject setValue:Picture forKey:@"Picture"];
            if([info.Arrow isEqualToString:@"straight"])
                goStraight.selectedSegmentIndex=1;
            else if([info.Arrow isEqualToString:@"slight right"]){
                rightOrLeft.selectedSegmentIndex=0;
                sharpOrNormal.selectedSegmentIndex=0;
                goStraight.selectedSegmentIndex=0;
            }
            else if([info.Arrow isEqualToString:@"Right"]){
                rightOrLeft.selectedSegmentIndex=0;
                sharpOrNormal.selectedSegmentIndex=1;
                goStraight.selectedSegmentIndex=0;
            }
            else if([info.Arrow isEqualToString:@"slight left"]){
                rightOrLeft.selectedSegmentIndex=1;
                sharpOrNormal.selectedSegmentIndex=0;
                goStraight.selectedSegmentIndex=0;
            }
            else if([info.Arrow isEqualToString:@"Left"]){
                rightOrLeft.selectedSegmentIndex=1;
                sharpOrNormal.selectedSegmentIndex=1;
                goStraight.selectedSegmentIndex=0;
            }
    UIImage* image=[UIImage imageWithData:info.Picture];
    imageView.image=image;
//          if(info.Transit==[NSNumber numberWithBool:false])
        if([info.Transit compare:[NSNumber numberWithBool:NO]]==NSOrderedSame){
                NSLog(@"It's false");
                transitStop.selectedSegmentIndex=0;
            }
            else
                transitStop.selectedSegmentIndex=1;
            //    NSError *error;
            /*	if (![[self fetchedResultsController] performFetch:&error]) {
             // Update to handle the error appropriately.
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
             exit(-1);  // Fail
             }
                }
 */   }    
    self.title = @"Event";
    
}

- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
    self.textField=nil;
    //    self.imageView = nil;
    //	self.takePictureButton = nil;
    //	self.selectFromCameraRollButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.events=nil;
    //    [imageView release];
    //	[takePictureButton release];
    //	[selectFromCameraRollButton release];
    [textField release];
    [super dealloc];
}



@end

