//
//  RouteCreatorScreen.h
//  Get Me There
//
//  Created by joseph schneider on 4/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCreatorScreen : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate >{
    UITextField *nameOfRoute;
    UIImageView *homeImage;
    UIButton *takePictureButton;
	UIButton *selectFromLibrary;
    NSFetchedResultsController *_fetchedResultsController;
}
-(IBAction) doneButtonPressed;
-(IBAction) cancelButtonPressed;
-(IBAction) doneWithKeyboard;
-(IBAction) getPhoto;

//@property (nonatomic, retain) IBOutlet UITextField *nameOfRoute;
//@property (nonatomic, retain) IBOutlet UIImageView *homeImage;
//@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
//@property (nonatomic, retain) IBOutlet UIButton *selectFromLibrary;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
