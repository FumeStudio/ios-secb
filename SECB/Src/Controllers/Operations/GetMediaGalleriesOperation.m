//
//  GetPhotoGalleriesOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetMediaGalleriesOperation.h"

@implementation GetMediaGalleriesOperation

- (id)initForMediaType:(MediaType)type pageIndex:(int)pIndex
{
    self = [super init];
    
    self.pageIndex = pIndex;
    self.mediaType = type;
    
    return self;
}

- (id)doMain
{
    NSData* response = [self doRequest];
    
    NSMutableArray* galleriesList = [self parseResponseFromHttpResponse:response];
    return galleriesList;
}
- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url = [NSString stringWithFormat:@"%@%@?lang=%@&pageSize=20&pageIndex=%d", Base_Service_URL, (self.mediaType == MediaTypeImages)? GetPhotoGalleries_URLSuffix : GetVideoGalleries_URLSuffix, LocalizedString(@"Lang_URL_Key",), self.pageIndex];

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
            [galleries addObject:[[MediaGallery alloc] initWithMediaType:self.mediaType andJSONObject:json]];
        
        return galleries;
    }
    return nil;
}

@end
