//
//  UIImagePickerController+RotationFix.m
//  Get Me There
//
//  Created by Kenneth Wigginton on 5/1/13.
//
//

#import "UIImagePickerController+RotationFix.h"

@implementation UIImagePickerController (RotationFix)

- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
