//
//  User+JSON.m
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "User+JSON.h"

@implementation User (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    [self getDataFromJsonObject:json];
    return self;
}

- (NSDictionary*)JSONObject
{
    return nil;
}

- (void)getDataFromJsonObject:(NSDictionary*)json
{
    
}


@end
