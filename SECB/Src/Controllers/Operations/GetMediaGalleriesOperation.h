//
//  GetPhotoGalleriesOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"
#import "MediaGallery+JSON.h"

@interface GetMediaGalleriesOperation : BaseOperation

@property int pageIndex;
@property MediaType mediaType;

- (id)initForMediaType:(MediaType)type pageIndex:(int)pageIndex;

@end
