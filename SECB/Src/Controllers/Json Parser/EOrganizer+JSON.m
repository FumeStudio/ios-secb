//
//  EOrganizer+JSON.m
//  SECB
//
//  Created by Peter Mosaad on 10/26/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EOrganizer+JSON.h"

@implementation EOrganizer (JSON)

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
        val = [json valueForKey:@"OrganizerName"];
        if([val isKindOfClass:[NSString class]])
            self.name = val;
        
        val = [json valueForKey:@"OrganizerImage"];
        if([val isKindOfClass:[NSString class]])
            self.image = val;
        
        val = [json valueForKey:@"OrganizerLocation"];
        if([val isKindOfClass:[NSString class]])
            self.location = val;
        
        val = [json valueForKey:@"OrganizerCity"];
        if([val isKindOfClass:[NSString class]])
            self.city = val;
        
        val = [json valueForKey:@"OrganizerPhone"];
        if([val isKindOfClass:[NSString class]])
            self.phone = val;
        
        val = [json valueForKey:@"OrganizerEmail"];
        if([val isKindOfClass:[NSString class]])
            self.email = val;
        
        val = [json valueForKey:@"OrganizerFAX"];
        if([val isKindOfClass:[NSString class]])
            self.fax = val;
        
        val = [json valueForKey:@"OrganizerWebAddress"];
        if([val isKindOfClass:[NSString class]])
            self.webAddress = val;
        
        val = [json valueForKey:@"OrganizerStreet"];
        if([val isKindOfClass:[NSString class]])
            self.street = val;
        
        val = [json valueForKey:@"OrganizerAddressDescription"];
        if([val isKindOfClass:[NSString class]])
            self.addressDescription = val;
        
        val = [json valueForKey:@"OrganizerDescription"];
        if([val isKindOfClass:[NSString class]])
            self.organizerDescription = val;
        
        val = [json valueForKey:@"OrganizerDistrict"];
        if([val isKindOfClass:[NSString class]])
            self.district = val;
    }
    
}

- (NSDictionary*)JSONObject
{
    return nil;
}

@end
