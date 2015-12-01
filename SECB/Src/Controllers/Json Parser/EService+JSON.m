//
//  EService+JSON.m
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EService+JSON.h"
#import "NSDate-Utilities.h"

@implementation EService (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    [self getDataFromJsonObject:json];
    return self;
}

- (void)getDataFromJsonObject:(NSDictionary*)json
{
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"name"];
        if([val isKindOfClass:[NSString class]])
            self.name = val;
        
        val = [json valueForKey:@"RequestNumber"];
        if([val isKindOfClass:[NSString class]])
            self.number = val;
        
        val = [json valueForKey:@"RequestDate"];
        if([val isKindOfClass:[NSString class]])
            self.date = [NSDate dateFromString:val withFormat:@"yyyy/MM/dd'T'HH:mm:ss'Z'"];;
        
        val = [json valueForKey:@"ReuquestStatusSingleValue"];
        if([val isKindOfClass:[NSString class]])
            self.status = val;
        
        val = [json valueForKey:@"RequestUrl"];
        if([val isKindOfClass:[NSString class]])
            self.detailsURL = val;
        
        val = [json valueForKey:@"RequestType"];
        if([val isKindOfClass:[NSString class]])
            self.type = val;
    }
    
}

- (NSDictionary*)JSONObject
{
    return nil;
}


@end


@implementation WorkSpaceMode (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    [self getDataFromJsonObject:json];
    return self;
}

- (void)getDataFromJsonObject:(NSDictionary*)json
{
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"NameAr"];
        if([val isKindOfClass:[NSString class]])
            self.arTitle = val;
        
        val = [json valueForKey:@"NameEn"];
        if([val isKindOfClass:[NSString class]])
            self.enTitle = val;

        val = [json valueForKey:@"Value"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;
    }
}


@end


@implementation EserviceRequestType (JSON)


- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    [self getDataFromJsonObject:json];
    return self;
}

- (void)getDataFromJsonObject:(NSDictionary*)json
{
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"Value"];
        if([val isKindOfClass:[NSString class]])
            self.value = val;
        
        val = [json valueForKey:@"Key"];
        if([val isKindOfClass:[NSNumber class]])
            self.key = [(NSNumber*)val stringValue];
    }
}

@end