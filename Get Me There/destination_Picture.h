//
//  destination_Picture.h
//  Get Me There
//
//  Created by joseph schneider on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Route.h"
@interface destination_Picture : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    UIImageView *endImage;
    UIButton *takePictureButton;
	UIButton *selectFromLibrary;
    NSFetchedResultsController *_fetchedResultsController;
}
-(IBAction) doneButtonPressed;
-(IBAction) cancelButtonPressed;
-(IBAction) getPhoto;

@property (nonatomic, retain) Route *inheritedRoute;

@property (nonatomic, retain) IBOutlet UIImageView *endImage;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIButton *selectFromLibrary;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *imageURL;

@end
