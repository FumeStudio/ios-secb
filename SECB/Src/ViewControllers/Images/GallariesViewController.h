//
//  GallariesViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaBox.h"
#import "GetMediaGalleriesOperation.h"
#import "MediaGallery+JSON.h"
#import "MWPhotoBrowser.h"

typedef enum ScreenMode
{
    ScreenModeAlbumsList,
    ScreenModeAlbumDetails,
}ScreenMode;

@interface GallariesViewController : SuperViewController <MediaBoxDelegate, BaseOperationDelegate, MWPhotoBrowserDelegate>
{
    __weak IBOutlet UIScrollView* galleriesScrollView;
    
    MediaGallery* currentMediaGallery;
    
    NSMutableArray* dataSource;
    
    ScreenMode screenMode;
    MediaType currentMediaType;
}

- (id)initWithMediaType:(MediaType)mediaType;
- (id)initWithMediaGallery:(MediaGallery*)gallery;

@end
