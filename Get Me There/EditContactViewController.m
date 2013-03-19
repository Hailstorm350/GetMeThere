//
//  EditContactViewController.m
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PanicButtonInfo.h"
#import "PanicButtonDetails.h"
#import "Get_Me_ThereAppDelegate.h"
#import "EditContactViewController.h"


@implementation EditContactViewController
@synthesize nameField, phoneField, imageField, photoButton, givenName;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context;
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
    @autoreleasepool {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PanicButtonInfo" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"details.phone" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest setFetchBatchSize:20];
        
        NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController = theFetchedResultsController;
        _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
        
        
        return _fetchedResultsController;
    }
}

- (IBAction)doneWithKeyboardTap:(id)sender
{
    [nameField resignFirstResponder];
    [phoneField resignFirstResponder];
}

- (IBAction)doneWithKeyboard:(id)sender 
{
    [sender resignFirstResponder];
}


- (IBAction)backButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressPhotoButton
{
    UIActionSheet *photoAction = [[UIActionSheet alloc]
                                  initWithTitle:@"Photo Selection" 
                                  delegate:self 
                                  cancelButtonTitle:@"Cancel Photo"
                                  destructiveButtonTitle:@"Take New Photo"
                                  otherButtonTitles:
                                  @"Choose From Gallery", 
                                  nil];
    [photoAction showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) 
    {
        NSString *msg = nil;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        if (buttonIndex == [actionSheet destructiveButtonIndex])
        {
            if (![UIImagePickerController isSourceTypeAvailable:
                  UIImagePickerControllerSourceTypeCamera]) {
                msg = @"Camera is not allowed on this device.";
                UIAlertView *photoAlert = [[UIAlertView alloc]
                                       initWithTitle:@"No Camera Detected"
                                       message:msg
                                       delegate:self cancelButtonTitle:@"OK" 
                                       otherButtonTitles:nil];
                [photoAlert show];
            } else {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:picker animated:YES];            
            }
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:picker animated:YES]; 
            
            msg = @"Please select a photo for your contact.";
            UIAlertView *photoAlert = [[UIAlertView alloc]
                                       initWithTitle:@"Welcome to Your Photo Album"
                                       message:msg
                                       delegate:self cancelButtonTitle:@"OK" 
                                       otherButtonTitles:nil];
            [photoAlert show];
        }
    }
}

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    imageField.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[imageField.image CGImage] orientation:(ALAssetOrientation)[imageField.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
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

- (IBAction)saveContact
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PanicButtonInfo" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", givenName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *array = [context executeFetchRequest:request error:&error];
    
    PanicButtonInfo *contactInfo = [array objectAtIndex:0];
    PanicButtonDetails *details = contactInfo.details;

    contactInfo.name = nameField.text;
    
    NSNumberFormatter *new = [[NSNumberFormatter alloc] init];
    [new setNumberStyle:NSNumberFormatterDecimalStyle];
    details.phone = phoneField.text;
    details.imageURL = imageURL;
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self.navigationItem setTitle:@"Edit Contact"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveContact)];
    self.navigationItem.rightBarButtonItem = saveButton;

    
    NSString *msg = nil;
    
    msg = [[NSString alloc] initWithFormat: @"%@'s info has been saved.", contactInfo.name];
    UIAlertView *saveAlert = [[UIAlertView alloc]
                              initWithTitle:@"Saved!"
                              message:msg
                              delegate:self cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil];
    [self dismissViewControllerAnimated:TRUE completion:nil];
    [saveAlert show];
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
    // Do any additional setup after loading the view from its nib.
    
    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PanicButtonInfo" inManagedObjectContext:context];
       
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", givenName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    PanicButtonInfo *contactInfo = [array objectAtIndex:0];
    PanicButtonDetails *details = contactInfo.details;
    [_fetchedResultsController.fetchRequest setPredicate:predicate];
    nameField.text = contactInfo.name;
    phoneField.text = [NSString stringWithFormat: @"%@", details.phone];
    
    if(!details.imageURL)
        imageField.image = [UIImage imageNamed:@"Facebook-Silhouette_normal.gif.png"];
    else
        imageField.image = [UIImage imageWithContentsOfFile: [NSData dataWithContentsOfURL: [NSURL URLWithString:details.imageURL]]];
    
    self.title = @"Edit Contact";
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        photoButton.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
