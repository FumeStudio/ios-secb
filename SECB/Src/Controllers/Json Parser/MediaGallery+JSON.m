//
//  MediaGallery+JSON.m
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "MediaGallery+JSON.h"

@implementation MediaGallery (JSON)

- (id)initWithMediaType:(MediaType)type andJSONObject:(NSDictionary*)json
{
    self = [self init];
    self.mediaType = type;
    
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"Title"];
        if([val isKindOfClass:[NSString class]])
            self.title = val;
        
        val = [json valueForKey:@"Created"];
        if([val isKindOfClass:[NSString class]])
            self.creationDate = [NSDate dateFromString:val withFormat:@"dd/MM/yyyy h:mm:ss a"];

        val = [json valueForKey:(self.mediaType == MediaTypeImages)?@"PhotoGalleryImageUrl" : @"VideoGalleryUrl"];
        if([val isKindOfClass:[NSString class]])
            self.galleryImgUrl = val;
        
        val = [json valueForKey:(self.mediaType == MediaTypeImages)?@"PhotoGalleryAlbumThumbnail" : @"VideosGalleryAlbumThumbnail"];
        if([val isKindOfClass:[NSString class]])
            self.galleryThumbnailUrl = val;
        
        val = [json valueForKey:@"Id"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;

        val = [json valueForKey:@"FolderPath"];
        if([val isKindOfClass:[NSString class]])
            self.folderPath = val;
        
        val = [json valueForKey:@"IsFolder"];
        if([val isKindOfClass:[NSNumber class]])
            self.isFolder = [(NSNumber*)val boolValue];
    }
    
    return self;
}

@end
