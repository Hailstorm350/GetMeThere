//
//  Event.m
//  Get Me There
//
//  Created by joseph schneider on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "Route.h"


@implementation Event
@dynamic Arrow;
@dynamic Name;
@dynamic Picture;
@dynamic Row;
@dynamic Transit;
@dynamic route;
@dynamic latitude;
@dynamic longitude;

- (void) setLocation:(CLLocationCoordinate2D)coord{
    [self setLongitude: [NSNumber numberWithDouble:coord.longitude]];
    [self setLatitude: [NSNumber numberWithDouble:coord.latitude]];
    NSLog(@"Location updated to: %f, %f", coord.longitude, coord.latitude);
}

- (CLLocationCoordinate2D) getLocationAsCLCoordinate{
    CLLocationCoordinate2D retCoord = CLLocationCoordinate2DMake( [self.latitude doubleValue], [self.longitude doubleValue]);
    
    return retCoord;
}
@end
