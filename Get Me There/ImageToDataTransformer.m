//
//  ImageToDataTransformer.m
//  PanicButton
//
//  Created by monica dimalanta camorongan on 5/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageToDataTransformer.h"

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    NSData *data = UIImagePNGRepresentation(value);
    return data;
}

- (id)reverseTransformedValue:(id)value {
    UIImage *uiImage = [[UIImage alloc] initWithData:value];
    return [uiImage autorelease];
}

@end
