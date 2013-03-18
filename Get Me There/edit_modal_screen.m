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
@synthesize textField, rightOrLeft, sharpOrNormal, transitStop, goStraight, newEvent, indexRow, givenName, viewContollerData, modalScreenEventData, inheritedEvent, imageURL;

@synthesize events=_events, context, fetchedResultsController=_fetchedResultsController, fetchedResultsControllerInherited;

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
    @autoreleasepool {
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
        
        [sort release];
        [fetchRequest release];
        [theFetchedResultsController release];
        
        return _fetchedResultsController;    
    }
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
        Event *newEventObject =[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];

        
        newEventObject.Name=textField.text;
        //   newRoute.Picture=(NSValueTransformer *)imageView;
        if(goStraight.selectedSegmentIndex==1){
            newEventObject.Arrow=@"straight";
        }
        else if(rightOrLeft.selectedSegmentIndex==1){
            if(sharpOrNormal.selectedSegmentIndex==1){
                newEventObject.Arrow=@"left turn";
            }
            else{
                newEventObject.Arrow=@"slight left";
            }
        }
        else if(rightOrLeft.selectedSegmentIndex==0){
            if(sharpOrNormal.selectedSegmentIndex==1){
                newEventObject.Arrow=@"right turn";
            }
            else{
                newEventObject.Arrow=@"slight right";
            }
        }
        if(transitStop.selectedSegmentIndex==0)           
            newEventObject.Transit=[NSNumber numberWithBool:false];
        else{
            newEventObject.Transit=[NSNumber numberWithBool:true];
        }
        //NSLog(@"the inherited row is %d", indexRow);
        NSNumber *newRow=[NSNumber numberWithInteger:indexRow];
        newEventObject.Row= newRow;
        //[newEventObject addRouteObject: finalInheritedRoute]; //TODO this needs to work for inverse in CoreData to function correctly
        [finalInheritedRoute addEventObject:newEventObject];

        newEventObject.Picture = imageURL;
        NSLog(@"Event Picture URL is: %@", imageURL);
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else
    {
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
        
        [request setEntity:entity];
        
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", givenName];
        
        [request setPredicate:predicate];
        
        NSError *error;
        
        NSArray *array = [context executeFetchRequest:request error:&error];
        Event *info=[array objectAtIndex:0];
        
        
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
        
        info.Picture=imageURL;
        
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(IBAction) cancelButtonPressed: (id) sender{
        [self dismissViewControllerAnimated:YES completion:nil];
}

/*

 http://www.iphonedevsdk.com/forum/iphone-sdk-development/42457-save-image-core-data.html
*/


-(IBAction) getPhoto{
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
	[self presentModalViewController:picker animated:YES];
    
    [picker release];
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
	imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageURL = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/*
 - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
 [picker dismissViewControllerAnimated:YES completion:nil];
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

    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    if([inheritedEvent.Row integerValue]!=indexRow){ //Not a new route

        Event *info=inheritedEvent;
        textField.text=info.Name;
       
        //TODO replace all this crappy logic with something useful: redesign UI for picker
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
        
    
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: imageURL]]];
    if([info.Transit compare:[NSNumber numberWithBool:NO]]==NSOrderedSame){
        transitStop.selectedSegmentIndex=0;
    }
    else
        transitStop.selectedSegmentIndex=1;
    }
    self.title = @"Event";
    
}

- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
    self.textField=nil;
    //    self.imageView = nil;
    //	self.takePictureButton = nil;
    //	self.selectFromCameraRollButton = nil;
    //[super viewDidUnload];
    self.fetchedResultsController = nil;
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

