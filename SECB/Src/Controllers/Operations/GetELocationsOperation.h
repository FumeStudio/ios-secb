//
//  GetELocationsOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"
#import "ELocation+JSON.h"

@interface LocationsFilter : NSObject

@property (strong) NSString* name;
@property (strong) NSString* cityID;
@property (strong) NSMutableArray* selectedTypesIds;
@property (strong) NSString* capacityTo;
@property (strong) NSString* capacityFrom;
@property int pageIndex;


@end

@interface GetELocationsOperation : BaseOperation
{
    ELocation* currentLocation;
}

@property (strong) LocationsFilter* currentFilter;
@property BOOL isGettingLocationsList;
@property BOOL isGettingLocationsDetails;
@property BOOL isGettingLocationTypes;

- (id)initToGetLocationsWithFilters:(LocationsFilter*)filter;
- (id)initToGetLocationTypes;
- (id)initToGetDetailsOfLocation:(ELocation*)location;

+ (NSMutableArray*)allLocationTypes;
+ (NSMutableArray*)allLocations;

@end
