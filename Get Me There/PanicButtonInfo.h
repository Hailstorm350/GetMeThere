//
//  PanicButtonInfo.h
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PanicButtonDetails;
@interface PanicButtonInfo : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) PanicButtonDetails *details;
@property (nonatomic, strong) NSString *ImageURL;

@end
