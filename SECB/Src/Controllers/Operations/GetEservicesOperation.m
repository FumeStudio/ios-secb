//
//  GetEservicesOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetEservicesOperation.h"

@implementation EservicesFilters
@end

@implementation GetEservicesOperation

+ (NSMutableArray*)allRequestTypes
{
    static NSMutableArray* request_types;
    @synchronized(self) {
        if (request_types == nil) {
            request_types = [[NSMutableArray alloc] init];
        }
    }
    
    return request_types;
}

+ (NSMutableArray*)allWorkSpaceModes
{
    static NSMutableArray* work_space_modes;
    @synchronized(self) {
        if (work_space_modes == nil) {
            work_space_modes = [[NSMutableArray alloc] init];
        }
    }
    
    return work_space_modes;
}

- (id)initToGetEservicesListWithFilters:(EservicesFilters*)filters
{
    self = [super init];
    
    self.currentFilter = filters;
    
    return self;
}

- (id)initToGetWorkSpaceModes
{
    self = [super init];
    self.isGettingWorkSpaceModes = true;
    return self;
}

- (id)initToGetRequestTypes;
{
    self = [super init];
    self.isGettingRequestTypes = true;
    return self;
}

- (id)doMain
{
    NSData* response = [self doRequest];
    
    NSMutableArray* results = [self parseResponseFromHttpResponse:response];
    
    if(self.isGettingRequestTypes && ![[self class] allRequestTypes].count)
        [[[self class] allRequestTypes] addObjectsFromArray:results];
    
    else if(self.isGettingWorkSpaceModes && ![[self class] allWorkSpaceModes].count)
        [[[self class] allWorkSpaceModes] addObjectsFromArray:results];
    
    return results;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url;
    
    if(self.isGettingRequestTypes)
    {
        url = [NSString stringWithFormat:@"%@%@?Lang=%@", Base_Service_URL, GetEServicesRequestTpyes_URLSuffix, LocalizedString(@"Lang_URL_Key",)];
    }
    else if(self.isGettingWorkSpaceModes)
    {
        url = [NSString stringWithFormat:@"%@%@", Base_Service_URL, GetWorkSpaceModes_URLSuffix];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@?UserName=%@&Lang=%@", Base_Service_URL, GetEServicesList_URLSuffix, [UserManager sharedInstance].currentLoggedInUser.username, LocalizedString(@"Lang_URL_Key",)];
        
        if(self.currentFilter.fromDate)
            url = [url stringByAppendingFormat:@"&FromDate=%@", [self.currentFilter.fromDate toStringWithFormat:@"yyyy/MM/dd"]];
        else
            url = [url stringByAppendingFormat:@"&FromDate=%@", @"null"];
        
        if(self.currentFilter.fromDate)
            url = [url stringByAppendingFormat:@"&ToDate=%@", [self.currentFilter.toDate toStringWithFormat:@"yyyy/MM/dd"]];
        else
            url = [url stringByAppendingFormat:@"&ToDate=%@", @"null"];
        
        if(self.currentFilter.status)
            url = [url stringByAppendingFormat:@"&Status=%@", self.currentFilter.status];
        else
            url = [url stringByAppendingFormat:@"&Status=%@", NewsCategoryAll];
        
        if(self.currentFilter.type)
            url = [url stringByAppendingFormat:@"&RequestType=%@", self.currentFilter.type];
        else
            url = [url stringByAppendingFormat:@"&RequestType=%@", NewsCategoryAll];
        
        if(self.currentFilter.requestNumber)
            url = [url stringByAppendingFormat:@"&RequestNumber=%@", self.currentFilter.requestNumber];
        else
            url = [url stringByAppendingFormat:@"&RequestNumber=%@", NewsCategoryAll];
    }
    
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
        if(self.isGettingRequestTypes)
        {
            NSMutableArray* requestTypes = [NSMutableArray array];
//            EserviceRequestType* requestType = [[EserviceRequestType alloc] init];
//            requestType.key = NewsCategoryAll;
//            requestType.value = LocalizedString(@"All",);
//            [requestTypes addObject:requestType];

            for(NSDictionary* json in jsonArray)
                [requestTypes addObject:[[EserviceRequestType alloc] initWithJSONObject:json]];
            return requestTypes;

        }
        else if(self.isGettingWorkSpaceModes)
        {
            NSMutableArray* workSpaceModes = [NSMutableArray array];
//            WorkSpaceMode* workSpaceMode = [[WorkSpaceMode alloc] init];
//            workSpaceMode.arTitle = @"الكل";
//            workSpaceMode.enTitle = @"All";
//            workSpaceMode.ID = NewsCategoryAll;
//            [workSpaceModes addObject:workSpaceMode];

            for(NSDictionary* json in jsonArray)
                [workSpaceModes addObject:[[WorkSpaceMode alloc] initWithJSONObject:json]];
            return workSpaceModes;
        }
        else
        {
            NSMutableArray* locationsList = [NSMutableArray array];
            for(NSDictionary* json in jsonArray)
                [locationsList addObject:[[EService alloc] initWithJSONObject:json]];
            return locationsList;
        }
    }
    return nil;
}

@end
