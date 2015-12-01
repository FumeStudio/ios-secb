//
//  LocationEguideViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/22/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationEguideCard.h"

#import "FiltersView.h"

#import "GetELocationsOperation.h"

#import "GetEventsOperation.h"
#import "iPad_EGuideViewController.h"

@interface LocationEguideViewController : SuperViewController <UITableViewDataSource, UITableViewDataSource, EguideLocationCardDelegate, FilterViewDelegate, BaseOperationDelegate>
{
    __weak IBOutlet UITableView *locationsTableView;
    
    NSMutableArray* tableViewDataSource;
    NSMutableArray* locationTypes;
    NSMutableArray* locationCities;

    LocationsFilter* currentFilter;
}

@property(readonly) FiltersView* theFiltersView;

@property (weak) iPad_EGuideViewController* ipadContainerVC;

@end
