//
//  GetUserStatisticsOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetUserStatisticsOperation.h"

@implementation GetUserStatisticsOperation

- (id)initWithUser:(User*)user
{
    self = [super init];
    currentUser = user;
    return self;
}

- (id)doMain
{
    NSData* response = [self doRequest];
    
    [self parseResponseFromHttpResponse:response];
    
    return currentUser;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url = [NSString stringWithFormat:@"%@%@?userName=%@", Base_Service_URL, Get_User_Statistics, currentUser.username];
    
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]]];
    NSDictionary *headers = @{ @"Cookie": [cookieHeaders objectForKey:@"Cookie"] };
    return [BaseOperation doRequestWithHttpMethod:@"GET" URL:url requestBody:nil customHttpHeaders:headers forOperation:self];
}

- (void)parseResponseFromHttpResponse:(NSData*)response
{
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if([jsonArray isKindOfClass:[NSArray class]])
    {
        for(NSDictionary* json in jsonArray)
        {
            NSString* val = [json valueForKey:@"Value"];
            if([val isKindOfClass:[NSString class]])
            {
                NSString* key = [json valueForKey:@"Key"];
                if([key isKindOfClass:[NSString class]])
                {
                    if([key isEqualToString:@"InProgress"])
                        currentUser.inProgressRequestsCounter = val.intValue;
                    else if([key isEqualToString:@"ClosedRequests"])
                        currentUser.closedRequestsCounter = val.intValue;
                    else if([key isEqualToString:@"Inbox"])
                        currentUser.inboxRequestsCounter = val.intValue;
                }
            }
        }
    }
//    else /// TEMP DATA
//    {
//        currentUser.inProgressRequestsCounter = 15;
//        currentUser.closedRequestsCounter = 20;
//        currentUser.inboxRequestsCounter = 55;
//    }
}


@end
