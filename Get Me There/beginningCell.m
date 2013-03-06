//
//  beginningCell.m
//  Get Me There
//
//  Created by joseph schneider on 4/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "beginningCell.h"

@implementation beginningCell
@synthesize test, startPicture, endPicture;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
