//
//  GetEventsOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"
#import "Event+JSON.h"

@interface EventsFilter : NSObject
@property (strong) NSDate* from;
@property (strong) NSDate* to;
@property int pageIndex;
@property (strong) NSMutableArray* selectedCategoryIDs;
@property (strong) NSString* selectedCityID;
@end

@interface GetEventsOperation : BaseOperation
{
    
}

@property (strong) EventsFilter* currentFilter;
@property BOOL isGettingEventsList;
@property BOOL isGettingEventsCities;
@property BOOL isGettingEventsCategories;
@property (weak) Event* currentEvent;

- (id)initWithToGetEventsWithFilters:(EventsFilter*)filter;
- (id)initWithToGetDetailsOfEvent:(Event*)event;
- (id)initToGetEventsCategories;
- (id)initToGetEventCities;

+ (NSMutableArray*)allEventCategories;
+ (NSMutableArray*)allEventCities;
+ (NSMutableArray*)allEvents;

+ (void)clearCachedData;

@end
