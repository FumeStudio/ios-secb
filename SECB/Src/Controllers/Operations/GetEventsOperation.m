    //
//  GetEventsOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetEventsOperation.h"

@implementation EventsFilter

@end

@implementation GetEventsOperation


+ (NSMutableArray*)allEventCategories
{
    static NSMutableArray* event_categories;
    @synchronized(self) {
        if (event_categories == nil) {
            event_categories = [[NSMutableArray alloc] init];
        }
    }
    
    return event_categories;
}

+ (NSMutableArray*)allEventCities
{
    static NSMutableArray* event_cities;
    @synchronized(self) {
        if (event_cities == nil) {
            event_cities = [[NSMutableArray alloc] init];
        }
    }
    
    return event_cities;
}

+ (NSMutableArray*)allEvents
{
    static NSMutableArray* all_events;
    @synchronized(self) {
        if (all_events == nil) {
            all_events = [[NSMutableArray alloc] init];
        }
    }
    
    return all_events;
}

- (id)initWithToGetEventsWithFilters:(EventsFilter*)filter
{
    self = [super init];
    self.isGettingEventsList = YES;
    self.currentFilter = filter;
    return self;
}

- (id)initWithToGetDetailsOfEvent:(Event*)event
{
    self = [super init];
    self.isGettingEventsList = YES;
    self.currentEvent = event;
    return self;
}

- (id)initToGetEventsCategories
{
    self = [super init];
    self.isGettingEventsCategories = true;
    return self;
}

- (id)initToGetEventCities
{
    self = [super init];
    self.isGettingEventsCities = true;
    return self;
}

+ (void)clearCachedData
{
    [[self allEvents] removeAllObjects];
}


- (id)doMain
{
    NSData* response = [self doRequest];
    
    NSMutableArray* results = [self parseResponseFromHttpResponse:response];
    if(self.isGettingEventsList)
    {
        if(![[self class] allEvents].count)
            [[[self class] allEvents] addObjectsFromArray:results];
    }
    else if(self.isGettingEventsCategories)
        [[[self class] allEventCategories] addObjectsFromArray:results];

    return results;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url;
    if(self.isGettingEventsList)
    {
        url = [NSString stringWithFormat:@"%@%@?lang=%@", Base_Service_URL, GetEventsList_URLSuffix, LocalizedString(@"Lang_URL_Key",)];
        if(self.currentEvent)
            url = [url stringByAppendingFormat:@"&EventID=%@", self.currentEvent.ID];
        else
            url = [url stringByAppendingString:@"&EventID=All"];
        
        if(self.currentFilter.from)
            url = [url stringByAppendingFormat:@"&FromDate=%@", [self.currentFilter.from toStringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss" Locale:[NSLocale localeWithLocaleIdentifier:@"EN"]]];
        else
            url = [url stringByAppendingFormat:@"&FromDate=%@", @"null"];
        if(self.currentFilter.to)
            url = [url stringByAppendingFormat:@"&ToDate=%@", [self.currentFilter.to toStringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss" Locale:[NSLocale localeWithLocaleIdentifier:@"EN"]]];
        else
            url = [url stringByAppendingFormat:@"&ToDate=%@", @"null"];
        if(self.currentFilter.selectedCategoryIDs)
            url = [url stringByAppendingFormat:@"&EventCategory=%@", [self.currentFilter.selectedCategoryIDs componentsJoinedByString:@","]];
        else
            url = [url stringByAppendingFormat:@"&EventCategory=%@", NewsCategoryAll];
        if(self.currentFilter.selectedCityID)
            url = [url stringByAppendingFormat:@"&EventCity=%@", self.currentFilter.selectedCityID];
        else
            url = [url stringByAppendingFormat:@"&EventCity=%@", NewsCategoryAll];

        if(self.currentFilter.pageIndex)
            url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", self.currentFilter.pageIndex];
        else
            url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", 0];
    }
    else if(self.isGettingEventsCities)
    {
        url = [NSString stringWithFormat:@"%@%@", Base_Service_URL, GetEventCitiesList_URLSuffix];
    }
    else
        url = [NSString stringWithFormat:@"%@%@", Base_Service_URL, GetEventCategories_URLSuffix];
    
    NSDictionary *headers = nil;
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]]];
    
    if([cookieHeaders objectForKey:@"Cookie"])
        headers = @{ @"Cookie": [cookieHeaders objectForKey:@"Cookie"] };
    return [BaseOperation doRequestWithHttpMethod:@"GET" URL:url requestBody:nil customHttpHeaders:headers forOperation:self];
}

- (NSMutableArray*)parseResponseFromHttpResponse:(NSData*)response
{
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if([jsonArray isKindOfClass:[NSArray class]])
    {
        if(self.isGettingEventsList)
        {
            if(self.currentEvent)
            {
                [self.currentEvent getDataFromJsonObject:jsonArray.firstObject];
            }
            else
            {
                NSMutableArray* newsList = [NSMutableArray array];
                for(NSDictionary* json in jsonArray)
                    [newsList addObject:[[Event alloc] initWithJSONObject:json]];
                return newsList;
            }
        }
        else if(self.isGettingEventsCities)
        {
            NSMutableArray* eventCities = [NSMutableArray array];
            EventCity* city = [[EventCity alloc] init];
            city.arTitle = @"الكل";
            city.enTitle = @"All";
            city.ID = NewsCategoryAll;
            [eventCities addObject:city];

            for(NSDictionary* json in jsonArray)
                [eventCities addObject:[[EventCity alloc] initWithJSONObject:json]];
            return eventCities;
        }
        else
        {
            NSMutableArray* eventCategories = [NSMutableArray array];
            EventCategory* category = [[EventCategory alloc] init];
            category.arTitle = @"الكل";
            category.enTitle = @"All";
            category.ID = NewsCategoryAll;
            [eventCategories addObject:category];
            for(NSDictionary* json in jsonArray)
                [eventCategories addObject:[[EventCategory alloc] initWithJSONObject:json]];
            return eventCategories;
        }
    }
    return nil;
}



@end
