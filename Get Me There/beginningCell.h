//
//  beginningCell.h
//  Get Me There
//
//  Created by joseph schneider on 4/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface beginningCell : UITableViewCell{
    IBOutlet UILabel *test;
    IBOutlet UIImageView *startPicture;
    IBOutlet UIImageView *endPicture;
}
@property (nonatomic, strong) IBOutlet UIImageView *startPicture;
@property (nonatomic, strong) IBOutlet UIImageView *endPicture;
-(void)setUIImages:(NSURL *)startImageURL : (NSURL *) destImageURL;
@end
