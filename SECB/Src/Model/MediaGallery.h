//
//  MediaGallery.h
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MediaType
{
    MediaTypeImages,
    MediaTypeVideos,
}MediaType;

@interface MediaGallery : NSObject

@property(strong) NSString* title;
@property(strong) NSDate* creationDate;
@property(strong) NSString* galleryImgUrl;
@property(strong) NSString* galleryThumbnailUrl;
@property(strong) NSString* ID;
@property BOOL isFolder;
@property(strong) NSString* folderPath;
@property MediaType mediaType;

/// If item is folder, will contain an array of MediaGallery Objects
@property (strong) NSMutableArray* contents;

- (NSString*)youTubeVideoID;


@end
