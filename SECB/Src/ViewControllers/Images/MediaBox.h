//
//  GalleryBox.h
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaGallery.h"

@class MediaBox;

typedef enum BoxMode
{
    BoxModeAlbum,
    BoxModeItem
}BoxMode;

@protocol MediaBoxDelegate <NSObject>

- (void)didSelectMediaBox:(MediaBox*)box;

@end

@interface MediaBox : UIView
{
    __weak IBOutlet LocalizableIconWithView *labelView;
    __weak IBOutlet UILabel *mediaLabel;
    __weak IBOutlet UIImageView *imageView;
    
    BoxMode boxMode;
}

@property (weak) id<MediaBoxDelegate> delegate;
@property (weak) MediaGallery* currentGallery;

+ (MediaBox*)boxForMediaItem:(MediaGallery*)gallery;

- (void)updateView;

- (IBAction)boxTapped:(id)sender;


@end
