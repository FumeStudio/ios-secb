//
//  GetMediaGalleyContentOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetMediaGalleyContentOperation.h"

@implementation GetMediaGalleyContentOperation

- (id)initWithMediaGallery:(MediaGallery*)gallery pageIndex:(int)pIndex
{
    self = [super init];
    
    self.pageIndex = pIndex;
    currentGallery = gallery;
    
    return self;
}

- (id)doMain
{
    NSData* response = [self doRequest];
    
    if(self.pageIndex)
        [currentGallery.contents addObjectsFromArray:[self parseResponseFromHttpResponse:response]];
    else
        currentGallery.contents = [NSMutableArray arrayWithArray:[self parseResponseFromHttpResponse:response]];
    return currentGallery;
}
- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url = [NSString stringWithFormat:@"%@%@?lang=%@&pageSize=20&pageIndex=%d&folderpath=%@", Base_Service_URL, (currentGallery.mediaType == MediaTypeImages)? GetPhotoGalleries_URLSuffix : GetVideoGalleries_URLSuffix, LocalizedString(@"Lang_URL_Key",), self.pageIndex, [currentGallery.folderPath urlEncodedValue]];

    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]]];
    NSDictionary *headers = @{ @"Cookie": [cookieHeaders objectForKey:@"Cookie"] };
    return [BaseOperation doRequestWithHttpMethod:@"GET" URL:url requestBody:nil customHttpHeaders:headers forOperation:self];
}

- (NSMutableArray*)parseResponseFromHttpResponse:(NSData*)response
{
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if([jsonArray isKindOfClass:[NSArray class]])
    {
        NSMutableArray* galleries = [NSMutableArray array];
        for(NSDictionary* json in jsonArray)
            [galleries addObject:[[MediaGallery alloc] initWithMediaType:currentGallery.mediaType andJSONObject:json]];
        
        return galleries;
    }
    return nil;
}

@end
