//
//  Event+JSON.m
//  SECB
//
//  Created by Peter Mosaad on 10/17/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "Event+JSON.h"

@implementation Event (JSON)

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

        val = [json valueForKey:@"Title"];
        if([val isKindOfClass:[NSString class]])
            self.eventTitle = val;
        
        val = [json valueForKey:@"EventDate"];
        if([val isKindOfClass:[NSString class]])
        {
            self.eventDate = [NSDate dateFromString:val withFormat:@"MM/dd/yyyy HH:mm:ss"];            
        }

        val = [json valueForKey:@"EndDate"];
        if([val isKindOfClass:[NSString class]])
        {
            self.EndDate = [NSDate dateFromString:val withFormat:@"MM/dd/yyyy HH:mm:ss"];
        }

        
        val = [json valueForKey:@"EventSiteCity"];
        if([val isKindOfClass:[NSString class]])
            self.eventSiteCity = val;
        
        val = [json valueForKey:@"EventSiteName"];
        if([val isKindOfClass:[NSString class]])
            self.eventSiteName = val;
        
        val = [json valueForKey:@"SiteonMap"];
        if([val isKindOfClass:[NSString class]])
            self.siteonMap = val;
        
        val = [json valueForKey:@"Description"];
        if([val isKindOfClass:[NSString class]])
            self.eventDescription = val;
        
        val = [json valueForKey:@"EventCategory"];
        if([val isKindOfClass:[NSString class]])
            self.eventCategory = val;
        
        val = [json valueForKey:@"EventSiteDescription"];
        if([val isKindOfClass:[NSString class]])
            self.eventSiteDescription = val;

        val = [json valueForKey:@"EventColor"];
        if([val isKindOfClass:[NSString class]])
            self.eventColor = val;
        
        val = [json valueForKey:@"IsRecurrence"];
        if([val isKindOfClass:[NSNumber class]])
            self.isRecurrence = [(NSNumber*)val boolValue];
        
        val = [json valueForKey:@"IsAllDayEvent"];
        if([val isKindOfClass:[NSNumber class]])
            self.isAllDayEvent = [(NSNumber*)val boolValue];


    }
    
}

- (NSDictionary*)JSONObject
{
    return nil;
}

@end

@implementation EventCategory (JSON)

- (id)initWithJSONObject:(NSDictionary*)json
{
    self = [super init];
    id val;
    if([json isKindOfClass:[NSDictionary class]])
    {
        val = [json valueForKey:@"TitleArabic"];
        if([val isKindOfClass:[NSString class]])
            self.arTitle = val;
        
        val = [json valueForKey:@"TitleEnglish"];
        if([val isKindOfClass:[NSString class]])
            self.enTitle = val;
        
        val = [json valueForKey:@"ID"];
        if([val isKindOfClass:[NSString class]])
            self.ID = val;
    }
    return self;
}

@end

@implementation EventCity (JSON)

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
