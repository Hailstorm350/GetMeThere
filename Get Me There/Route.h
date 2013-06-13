//
//  Route.h
//  Get Me There
//
//  Created by joseph schneider on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Route : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * destinationPictureURL;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * startPictureURL;
@property (nonatomic, strong) NSSet *event;
@property (nonatomic, strong) NSNumber *sortOrder;
@end

@interface Route (CoreDataGeneratedAccessors)

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;
@end
