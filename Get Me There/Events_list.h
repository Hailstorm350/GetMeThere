//
//  Events_list.h
//  Route_edit screen
//
//  Created by Student on 11/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event_class.h"

//previously was UIViewController
@interface Events_list : NSObject {
    NSMutableArray *listOfEvents;
}

-(id)init;
-(void)addEvent: (Event_class *) newEvent;
-(void)replaceEvent: (Event_class *) newEvent withIndex: (NSUInteger) index;
-(Event_class *)getMemberAtIndex:(NSUInteger)index;
-(NSUInteger) numberOfEvents; 

@end
