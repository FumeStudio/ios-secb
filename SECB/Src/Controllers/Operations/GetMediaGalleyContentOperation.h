//
//  GetMediaGalleyContentOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"
#import "MediaGallery+JSON.h"

@interface GetMediaGalleyContentOperation : BaseOperation
{
    MediaGallery* currentGallery;
}
@property int pageIndex;

- (id)initWithMediaGallery:(MediaGallery*)gallery pageIndex:(int)pIndex;

@end
