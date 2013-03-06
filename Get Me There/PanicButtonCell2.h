//
//  PanicButtonCell2.h
//  Get Me There
//
//  Created by joseph schneider on 5/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanicButtonCell2 : UITableViewCell{
    IBOutlet UILabel *contactName;
    IBOutlet UIImageView *contactPicture;
}

@property (nonatomic, retain) IBOutlet UILabel *contactName;
@property (nonatomic, retain) IBOutlet UIImageView *contactPicture;
@end
