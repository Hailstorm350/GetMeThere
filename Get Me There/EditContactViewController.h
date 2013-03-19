//
//  EditContactViewController.h
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface EditContactViewController : UIViewController
    <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITextField *nameField;
    UITextField *phoneField;
    UIImageView *imageField;
    UIButton *photoButton;
    NSFetchedResultsController *_fetchedResultsController;
    NSString *givenName;
}

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UITextField *phoneField;
@property (nonatomic, strong) IBOutlet UIImageView *imageField;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *givenName;

- (IBAction)doneWithKeyboardTap:(id)sender;
- (IBAction)doneWithKeyboard:(id)sender;
- (IBAction)backButtonPressed;
- (IBAction)pressPhotoButton;
- (IBAction)saveContact;


@end
