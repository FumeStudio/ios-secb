//
//  ELocation+JSON.m
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "ELocation+JSON.h"

@implementation ELocation (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    [self getDataFromJsonObject:json];
    return self;
}

//-(NSDate *)calculateStringToDate:(NSString *)getString
//{
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
//    
//    NSDate *aDate = [dateFormat dateFromString:getString];
//    
//    if( !aDate )
//    {
//        [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
//        [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
//        aDate = [dateFormat dateFromString:getString];
//    }
//    
//    return aDate;
//}

- (void)getDataFromJsonObject:(NSDictionary*)json
{
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"ID"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;

        val = [json valueForKey:@"SiteName"];
        if([val isKindOfClass:[NSString class]])
            self.name = val;
        
        val = [json valueForKey:@"SiteImage"];
        if([val isKindOfClass:[NSString class]])
            self.image = val;
        
        val = [json valueForKey:@"SiteLocation"];
        if([val isKindOfClass:[NSString class]])
            self.location = val;
        
        val = [json valueForKey:@"SiteCapacity"];
        if([val isKindOfClass:[NSString class]])
            self.capacity = val;
        
        val = [json valueForKey:@"SiteArea"];
        if([val isKindOfClass:[NSString class]])
            self.area = val;
        
        val = [json valueForKey:@"SitePhone"];
        if([val isKindOfClass:[NSString class]])
            self.phone = val;
        
        val = [json valueForKey:@"SiteEmail"];
        if([val isKindOfClass:[NSString class]])
            self.email = val;

        val = [json valueForKey:@"SiteCity"];
        if([val isKindOfClass:[NSString class]])
            self.city = val;
        
        val = [json valueForKey:@"SiteType"];
        if([val isKindOfClass:[NSString class]])
            self.type = val;
        
        val = [json valueForKey:@"SiteStreet"];
        if([val isKindOfClass:[NSString class]])
            self.street = val;

        val = [json valueForKey:@"SiteAddressDescription"];
        if([val isKindOfClass:[NSString class]])
            self.addressDescription = val;

        val = [json valueForKey:@"SiteDescription"];
        if([val isKindOfClass:[NSString class]])
            self.locationDescription = val;

        val = [json valueForKey:@"SiteFeaturesAndResources"];
        if([val isKindOfClass:[NSString class]])
            self.featuresAndResources = val;

        val = [json valueForKey:@"SiteDistrict"];
        if([val isKindOfClass:[NSString class]])
            self.district = val;
        
        val = [json valueForKey:@"WebSite"];
        if([val isKindOfClass:[NSString class]])
            self.webSite = val;
            
        
        NSArray* roomsJson = [json valueForKey:@"LocationRooms"];
        if([roomsJson isKindOfClass:[NSArray class]])
        {
            self.locationRooms = [NSMutableArray array];
            for(NSDictionary* roomJson in roomsJson)
                [self.locationRooms addObject:[[LocationRoom alloc] initWithJSONObject:roomJson]];
        }
    }
    
}

- (NSDictionary*)JSONObject
{
    return nil;
}

@end

@implementation LocationRoom (JSON)

- (id)initWithJSONObject:(NSDictionary *)json
{
    self = [super init];
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"RoomArea"];
        if([val isKindOfClass:[NSString class]])
            self.roomArea = val;
        
        val = [json valueForKey:@"RoomCapacity"];
        if([val isKindOfClass:[NSString class]])
            self.roomCapacity = val;
        
        val = [json valueForKey:@"RoomsCount"];
        if([val isKindOfClass:[NSString class]])
            self.roomsCount = val;
        
        val = [json valueForKey:@"RoomType"];
        if([val isKindOfClass:[NSString class]])
            self.roomType = val;

    }
    return self;

}

@end

@implementation LocationType (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"SiteTypeArabic"];
        if([val isKindOfClass:[NSString class]])
            self.arTitle = val;
        
        val = [json valueForKey:@"SiteTypeEnglish"];
        if([val isKindOfClass:[NSString class]])
            self.enTitle = val;
        
        val = [json valueForKey:@"ID"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;
    }
    return self;
}

@end

@implementation LocationCity (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"CityArabic"];
        if([val isKindOfClass:[NSString class]])
            self.arTitle = val;
        
        val = [json valueForKey:@"CityEnglish"];
        if([val isKindOfClass:[NSString class]])
            self.enTitle = val;
        
        val = [json valueForKey:@"ID"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;
    }
    return self;
}

@end
