//
//  MediaGallery+JSON.h
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "MediaGallery.h"

@interface MediaGallery (JSON)

- (id)initWithMediaType:(MediaType)type andJSONObject:(NSDictionary*)json;

@end
