//
//  EditContactViewController.h
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditContactViewController : UIViewController
    <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITextField *nameField;
    UITextField *phoneField;
    UIImageView *imageField;
    UIButton *photoButton;
    NSFetchedResultsController *_fetchedResultsController;
    NSString *givenName;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *phoneField;
@property (nonatomic, retain) IBOutlet UIImageView *imageField;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSString *givenName;

- (IBAction)doneWithKeyboardTap:(id)sender;
- (IBAction)doneWithKeyboard:(id)sender;
- (IBAction)backButtonPressed;
- (IBAction)pressPhotoButton;
- (IBAction)saveContact;


@end
