//
//  EventsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventCard.h"

#import "FiltersView.h"

#import "GetEventsOperation.h"

typedef enum EventsTypeFilter
{
    EventsTypeFilterAll,
    EventsTypeFilterEconomic,
    EventsTypeFilterPolitical,
    EventsTypeFilterPublic
}EventsTypeFilter;


@interface AllEventsViewController : SuperViewController <UITableViewDataSource, UITableViewDataSource, EventCardDelegate, FilterViewDelegate, BaseOperationDelegate>
{
    __weak IBOutlet UITableView *eventsTableView;
    
    NSMutableArray* tableViewDataSource;
    NSMutableArray* eventCategories;
    NSMutableArray* eventCities;
    
    EventsFilter* currentFilter;
}
@end
