//
//  UIImagePickerController+RotationFix.h
//  Get Me There
//
//  Created by Kenneth Wigginton on 5/1/13.
//
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (RotationFix)

- (BOOL)shouldAutorotate;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

@end
