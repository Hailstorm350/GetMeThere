//
//  PanicButtonCell2.m
//  Get Me There
//
//  Created by joseph schneider on 5/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PanicButtonCell2.h"

@implementation PanicButtonCell2
@synthesize contactName, contactPicture;
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
