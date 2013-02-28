//
//  Event.h
//  Get Me There
//
//  Created by joseph schneider on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Route;

@interface Event : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Arrow;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSData * Picture;
@property (nonatomic, retain) NSNumber * Row;
@property (nonatomic, retain) NSNumber * Transit;
@property (nonatomic, retain) Route *route;

@end
