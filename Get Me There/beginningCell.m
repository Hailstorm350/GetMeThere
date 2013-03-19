//
//  beginningCell.m
//  Get Me There
//
//  Created by joseph schneider on 4/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "beginningCell.h"

@implementation beginningCell
//@synthesize test, startPicture, endPicture;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUIImages:(NSURL *)startImageURL : (NSURL *) destImageURL
{
    __block UIImage * startUIImage;
    __block UIImage * destUIImage;
    //result block for startImage
    ALAssetsLibraryAssetForURLResultBlock startresultblock = ^(ALAsset *myasset)
    {
        //ALAssetRepresentation *rep = [myasset defaultRepresentation];    // Change to commented lines when
        CGImageRef iref = [myasset thumbnail];//[rep fullResolutionImage]; //  Thumbnail is not wanted
        
        if (iref) {
            startUIImage = [UIImage imageWithCGImage:iref];
            
            [((UIImageView *)[self viewWithTag:1]) setImage: startUIImage];
            [startUIImage retain];
        }
    };
    //result block for destImage
    ALAssetsLibraryAssetForURLResultBlock destresultblock = ^(ALAsset *myasset)
    {
        //ALAssetRepresentation *rep = [myasset defaultRepresentation];// Change to commented lines when
        CGImageRef iref = [myasset thumbnail];//[rep fullResolutionImage];//  Thumbnail is not wanted
        if (iref) {
            destUIImage = [UIImage imageWithCGImage:iref];
            
            [((UIImageView *)[self viewWithTag:2]) setImage:destUIImage];
            [destImageURL retain];
        }
    };
    
    //failure block for all cases
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"Image Retrieval Error - %@",[myerror localizedDescription]);
    };
    
    //Fetch and retain start Image
    if(startImageURL && [[startImageURL absoluteString] length])
    {
        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        [assetslibrary assetForURL:startImageURL
                       resultBlock:startresultblock
                      failureBlock:failureblock];
    }
    //Fetch and retain destination Image
    if(destImageURL && [[destImageURL absoluteString] length])
    {
        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        [assetslibrary assetForURL:destImageURL
                       resultBlock:destresultblock
                      failureBlock:failureblock];
    }
}
@end