//
//  SendContactUsFormOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SendContactUsFormOperation.h"

@implementation SendContactUsFormOperation

- (id)initWithFormData:(ContactUsForm*)form
{
    self = [super init];
    formData = form;
    return self;
}

- (id)doMain
{
    NSData* response = [self doRequest];
    
    return response;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url;
    
    url = [NSString stringWithFormat:@"%@%@?Lang=%@", Base_Service_URL, SendContactUsForm_URLSuffix, LocalizedString(@"Lang_URL_Key",)];
    
    url = [url stringByAppendingFormat:@"&userName=%@", [formData.username urlEncodedValue]];
    url = [url stringByAppendingFormat:@"&Phone=%@", [formData.phone urlEncodedValue]];
    url = [url stringByAppendingFormat:@"&Email=%@", formData.email];
    url = [url stringByAppendingFormat:@"&Organization=%@", [formData.organization urlEncodedValue]];
    url = [url stringByAppendingFormat:@"&JobTitle=%@", [formData.jobTitle urlEncodedValue]];
    url = [url stringByAppendingFormat:@"&Subject=%@", [formData.subject urlEncodedValue]];
    
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]]];
    NSDictionary *headers = @{ @"Cookie": [cookieHeaders objectForKey:@"Cookie"] };
    return [BaseOperation doRequestWithHttpMethod:@"GET" URL:url requestBody:nil customHttpHeaders:headers forOperation:self];
}


@end
