//
//  News+JSON.m
//  SECB
//
//  Created by Peter Mosaad on 10/17/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "News+JSON.h"

@implementation News (JSON)

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
        val = [json valueForKey:@"Title"];
        if([val isKindOfClass:[NSString class]])
            self.title = val;
        
        val = [json valueForKey:@"CreationDate"];
        if([val isKindOfClass:[NSString class]])
            self.creationDate = [NSDate dateFromString:val withFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        val = [json valueForKey:@"ImageUrl"];
        if([val isKindOfClass:[NSString class]])
            self.imageUrl = val;
        
        val = [json valueForKey:@"ID"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;
        
        val = [json valueForKey:@"NewsCategory"];
        if([val isKindOfClass:[NSString class]])
            self.newsCategory = val;
        
        val = [json valueForKey:@"NewsBrief"];
        if([val isKindOfClass:[NSString class]])
            self.newsBrief = val;
        
        val = [json valueForKey:@"NewsBody"];
        if([val isKindOfClass:[NSString class]])
            self.newsBody = val;
    }

}

- (NSDictionary*)JSONObject
{
    return nil;
}

@end


@implementation NewsCategory (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"CategoryArabic"];
        if([val isKindOfClass:[NSString class]])
            self.arTitle = val;
        
        val = [json valueForKey:@"CategoryEnglish"];
        if([val isKindOfClass:[NSString class]])
            self.enTitle = val;
        
        val = [json valueForKey:@"ID"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;        
    }
    return self;
}

@end