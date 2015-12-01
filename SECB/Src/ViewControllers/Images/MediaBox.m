//
//  GalleryBox.m
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "MediaBox.h"

@implementation MediaBox

- (instancetype)init
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"MediaBox" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    boxMode = BoxModeAlbum;
    return self;
}

- (id)initWithMediaAlbum:(MediaGallery*)gallery
{
    self = [self init];
    boxMode = BoxModeAlbum;
    self.currentGallery = gallery;
    return self;
}

+ (MediaBox*)boxForMediaItem:(MediaGallery*)gallery
{
    MediaBox* box = [[MediaBox alloc] initWithMediaAlbum:gallery];
    
    return box;
}

- (void)updateView
{
    UIImage* placeHolder = [UIImage imageNamed:@"Placeholder"];
    mediaLabel.text = self.currentGallery.title;
    [imageView setImageWithImageUrl:(self.currentGallery.galleryThumbnailUrl)?self.currentGallery.galleryThumbnailUrl : self.currentGallery.galleryImgUrl andPlaceHolderImage:placeHolder];
}

- (IBAction)boxTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didSelectMediaBox:)])
        [self.delegate didSelectMediaBox:self];
}

@end
