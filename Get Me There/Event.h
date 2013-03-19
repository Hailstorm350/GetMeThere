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
@property (nonatomic, strong) NSString * Arrow;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * Picture;
@property (nonatomic, strong) NSNumber * Row;
@property (nonatomic, strong) NSNumber * Transit;
@property (nonatomic, strong) NSSet *route;


@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addRouteObject:(Route *)value;
- (void)removeRouteObject:(Route *)value;
- (void)addRoutes:(NSSet *)values;
- (void)removeRoutes:(NSSet *)values;
@end