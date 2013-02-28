//
//  Event_class.m
//  Route_edit screen
//
//  Created by Student on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Event_class.h"


@implementation Event_class

@synthesize goStraight;
@synthesize transitStop;
@synthesize rightTurn;
@synthesize slightTurn;
@synthesize descriptionOfEvent;


- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [descriptionOfEvent release];
    [super dealloc];
}



#pragma mark - View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
