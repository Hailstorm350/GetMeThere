//
//  Event.h
//  Get Me There
//
//  Created by joseph schneider on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreLocationController.h"
@class Route;

@interface Event : NSManagedObject {

@private
}
@property (nonatomic, strong) NSString * direction;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * pictureURL;
@property (nonatomic, strong) NSNumber * sortOrder;
@property (nonatomic, strong) NSNumber * isTransit;
@property (nonatomic, strong) NSSet *route;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSNumber * radius;

- (void) setLocation: (CLLocationCoordinate2D) coord;
- (CLLocationCoordinate2D) getLocationAsCLCoordinate;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addRouteObject:(Route *)value;
- (void)removeRouteObject:(Route *)value;
- (void)addRoutes:(NSSet *)values;
- (void)removeRoutes:(NSSet *)values;

@end