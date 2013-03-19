//
//  PanicButtonDetails.h
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PanicButtonInfo;

@interface PanicButtonDetails : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSNumber * displayOrder;
@property (nonatomic, strong) PanicButtonInfo *info;

@end
