//
//  Events_list.m
//  Route_edit screen
//
//  Created by Student on 11/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Events_list.h"

@implementation Events_list
-(id)init
{
    self=[super init];
    if(self)
    {
        listOfEvents= [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addEvent: (Event_class *) newEvent
{
    if (newEvent)
        [listOfEvents addObject:newEvent];
    else
    {
        NSLog(@"image is nil");
    }


}

-(void)replaceEvent: (Event_class *) newEvent withIndex: (NSUInteger) index
{
    [listOfEvents replaceObjectAtIndex:index withObject:newEvent];
}

-(Event_class *)getMemberAtIndex: (NSUInteger) index{
    return [listOfEvents objectAtIndex:index];
}


-(NSUInteger) numberOfEvents
{
    return [listOfEvents count];
}

- (void)dealloc
{
    [listOfEvents release];
    [super dealloc];
}


#pragma mark - View lifecycle




@end

