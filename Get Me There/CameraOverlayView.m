//
//  CameraOverlayView.m
//  Get Me There
//
//  Created by Kenneth Wigginton on 5/15/13.
//
//

#import "CameraOverlayView.h"

@implementation CameraOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //clear the background color of the overlay
        self.opaque = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect called");

    //Draw guides
    UIBezierPath* bezPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 320, 300) cornerRadius:15];
    [[UIColor clearColor] setFill];
    [[UIColor redColor] setStroke];
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat x = (screenRect.size.width - 320) / 2;
    CGFloat y = (screenRect.size.height - 300) / 2;
    
    CGContextTranslateCTM(aRef, x, y);
    
    [bezPath fill];
    [bezPath stroke];
    bezPath.lineWidth = 1;
}
@end
