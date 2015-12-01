//
//  GetELocationsOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetELocationsOperation.h"

@implementation LocationsFilter

@end

@implementation GetELocationsOperation


+ (NSMutableArray*)allLocationTypes
{
    static NSMutableArray* location_types;
    @synchronized(self) {
        if (location_types == nil) {
            location_types = [[NSMutableArray alloc] init];
        }
    }
    
    return location_types;
}

+ (NSMutableArray*)allLocations
{
    static NSMutableArray* all_locations;
    @synchronized(self) {
        if (all_locations == nil) {
            all_locations = [[NSMutableArray alloc] init];
        }
    }
    
    return all_locations;
}

- (id)initToGetLocationsWithFilters:(LocationsFilter*)filter
{
    self = [super init];
    self.isGettingLocationsList = YES;
    self.currentFilter = filter;
    return self;
}

- (id)initToGetDetailsOfLocation:(ELocation*)location
{
    self = [super init];
    self.isGettingLocationsDetails = YES;
    currentLocation = location;
    return self;
}

- (id)initToGetLocationTypes
{
    self = [super init];
    self.isGettingLocationTypes = YES;
    return self;
}


- (id)doMain
{
    NSData* response = [self doRequest];
    
    NSMutableArray* results = [self parseResponseFromHttpResponse:response];
    if(self.isGettingLocationsList)
    {
        [[[self class] allLocations] addObjectsFromArray:results];
    }
    else if(self.isGettingLocationsDetails)
    {
        return currentLocation;
    }
    else if(self.isGettingLocationTypes)
        [[[self class] allLocationTypes] addObjectsFromArray:results];

    return results;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url;
    if(self.isGettingLocationsList)
    {
        url = [NSString stringWithFormat:@"%@%@?lang=%@", Base_Service_URL, GetLocatoinsList_URLSuffix, LocalizedString(@"Lang_URL_Key",)];

        if(self.currentFilter.name)
            url = [url stringByAppendingFormat:@"&Name=%@", [self.currentFilter.name urlEncodedValue]];
        else
            url = [url stringByAppendingFormat:@"&Name=%@", @"All"];
        
        if(self.currentFilter.cityID)
            url = [url stringByAppendingFormat:@"&SiteCity=%@", self.currentFilter.cityID];
        else
            url = [url stringByAppendingFormat:@"&SiteCity=%@", NewsCategoryAll];
        
        if(self.currentFilter.selectedTypesIds.count)
            url = [url stringByAppendingFormat:@"&SiteType=%@", [self.currentFilter.selectedTypesIds componentsJoinedByString:@","]];
        else
            url = [url stringByAppendingFormat:@"&SiteType=%@", NewsCategoryAll];

        if(self.currentFilter.capacityTo)
            url = [url stringByAppendingFormat:@"&CapacityTo=%@", self.currentFilter.capacityTo];
        else
            url = [url stringByAppendingFormat:@"&CapacityTo=%@", NewsCategoryAll];
        
        if(self.currentFilter.capacityFrom)
            url = [url stringByAppendingFormat:@"&CapacityFrom=%@", self.currentFilter.capacityFrom];
        else
            url = [url stringByAppendingFormat:@"&CapacityFrom=%@", NewsCategoryAll];


        if(self.currentFilter.pageIndex)
            url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", self.currentFilter.pageIndex];
        else
            url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", 0];
    }
    else if(self.isGettingLocationsDetails)
    {
        url = [NSString stringWithFormat:@"%@%@?lang=%@&LocationID=%@", Base_Service_URL, GetLocationDetails_URLSuffix, LocalizedString(@"Lang_URL_Key",), currentLocation.ID];
    }
    else
        url = [NSString stringWithFormat:@"%@%@", Base_Service_URL, GetLocationTypes_URLSuffix];
    
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]]];
    NSDictionary *headers = @{ @"Cookie": [cookieHeaders objectForKey:@"Cookie"] };
    return [BaseOperation doRequestWithHttpMethod:@"GET" URL:url requestBody:nil customHttpHeaders:headers forOperation:self];
}

- (NSMutableArray*)parseResponseFromHttpResponse:(NSData*)response
{
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if([jsonArray isKindOfClass:[NSArray class]])
    {
        if(self.isGettingLocationsList)
        {
            NSMutableArray* locationsList = [NSMutableArray array];
            for(NSDictionary* json in jsonArray)
                [locationsList addObject:[[ELocation alloc] initWithJSONObject:json]];
            return locationsList;
        }
        else if(self.isGettingLocationsDetails)
        {
            [currentLocation getDataFromJsonObject:jsonArray.firstObject];
        }
        else
        {
            NSMutableArray* locationTypes = [NSMutableArray array];
            LocationType* category = [[LocationType alloc] init];
            category.arTitle = @"الكل";
            category.enTitle = @"All";
            category.ID = NewsCategoryAll;
            [locationTypes addObject:category];
            for(NSDictionary* json in jsonArray)
                [locationTypes addObject:[[LocationType alloc] initWithJSONObject:json]];
            return locationTypes;
        }
    }
    return nil;
}



@end
