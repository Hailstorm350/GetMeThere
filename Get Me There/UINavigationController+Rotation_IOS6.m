//
//  UINavigationController+Rotation_IOS6.m
//  Get Me There
//
//  Created by Kenneth Wigginton on 4/22/13.
//
//

#import "UINavigationController+Rotation_IOS6.h"

@implementation UINavigationController (Rotation_IOS6)

- (BOOL) shouldAutorotate{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger) supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
