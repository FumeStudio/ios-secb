//
//  OrganizerEguideViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/22/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrganizerEguideCard.h"

#import "FiltersView.h"

#import "GetEOrganizersOperation.h"
#import "GetEventsOperation.h"
#import "iPad_EGuideViewController.h"

@interface OrganizerEguideViewController : SuperViewController <UITableViewDataSource, UITableViewDataSource, OrganizerEguideCardDelegate, FilterViewDelegate, BaseOperationDelegate>
{
    __weak IBOutlet UITableView *organizersTableView;
    
    NSMutableArray* tableViewDataSource;
    NSMutableArray* allCities;

    OrganizerFilter* currentFilter;
}

@property(readonly) FiltersView* theFiltersView;

@property (weak) iPad_EGuideViewController* ipadContainerVC;

@end
