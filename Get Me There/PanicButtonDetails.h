//
//  PanicButtonDetails.h
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ImageToDataTransformer.h"

@class PanicButtonInfo;

@interface PanicButtonDetails : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) UIImage * imageToData;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) PanicButtonInfo *info;

@end
