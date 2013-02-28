//
//  Event_class.h
//  Route_edit screen
//
//  Created by Student on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Event_class : NSObject {
    
}

@property (nonatomic) BOOL rightTurn;
@property (nonatomic) BOOL slightTurn;
@property (nonatomic) BOOL goStraight;
@property (nonatomic) BOOL transitStop;
@property (nonatomic, retain) NSString *descriptionOfEvent;
@end
