//
//  ForgetPasswordOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "ForgetPasswordOperation.h"

@implementation ForgetPasswordOperation

- (id)initWithUserName:(NSString *)username
{
    self = [super init];
    currentUserName = username;
    return self;
}

- (id)doMain
{
    NSData* response = [self doRequest];
    [self parseResponseFromHttpResponse:response];
    return nil;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url = [NSString stringWithFormat:@"%@%@?userName=%@", Base_Service_URL, ForgetPassword_URLSuffix, currentUserName];
    
    return [BaseOperation doRequestWithHttpMethod:@"GET" URL:url requestBody:nil customHttpHeaders:nil forOperation:self];
}

- (void)parseResponseFromHttpResponse:(NSData*)response
{
    return ;
}


@end
