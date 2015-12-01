//
//  GetEOrganizersOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/26/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetEOrganizersOperation.h"

@implementation OrganizerFilter

@end

@implementation GetEOrganizersOperation


+ (NSMutableArray*)allOrganizers
{
    static NSMutableArray* all_organizers;
    @synchronized(self) {
        if (all_organizers == nil) {
            all_organizers = [[NSMutableArray alloc] init];
        }
    }
    
    return all_organizers;
}

- (id)initToGetOrganizersWithFilters:(OrganizerFilter *)filter
{
    self = [super init];
    self.currentFilter = filter;
    return self;
}

- (id)doMain
{
    NSData* response = [self doRequest];
    
    NSMutableArray* results = [self parseResponseFromHttpResponse:response];
    
    [[[self class] allOrganizers] addObjectsFromArray:results];
    
    return results;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url;
    
    url = [NSString stringWithFormat:@"%@%@?Lang=%@", Base_Service_URL, GetOrganizersList_URLSuffix, LocalizedString(@"Lang_URL_Key",)];
    
    if(self.currentFilter.name)
        url = [url stringByAppendingFormat:@"&Name=%@", [self.currentFilter.name urlEncodedValue]];
    else
        url = [url stringByAppendingFormat:@"&Name=%@", @"All"];
    
    if(self.currentFilter.cityID)
        url = [url stringByAppendingFormat:@"&OrganizerCity=%@", self.currentFilter.cityID];
    else
        url = [url stringByAppendingFormat:@"&OrganizerCity=%@", NewsCategoryAll];
    
    if(self.currentFilter.pageIndex)
        url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", self.currentFilter.pageIndex];
    else
        url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", 0];
    
    
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

        NSMutableArray* locationsList = [NSMutableArray array];
            for(NSDictionary* json in jsonArray)
                [locationsList addObject:[[EOrganizer alloc] initWithJSONObject:json]];
            return locationsList;
    }
    return nil;
}



@end
