//
//  EventsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EventCard.h"

#import "CalendarMonthView.h"

#import "GetEventsOperation.h"


@interface EventsViewController : SuperViewController <UITableViewDataSource, UITableViewDataSource, EventCardDelegate, BaseOperationDelegate, CalendarViewDelegate>
{
    __weak IBOutlet UITableView *eventsTableView;
    
    __weak IBOutlet UIButton *viewAllEventsButton;
    
    NSMutableArray* tableViewDataSource;
    NSMutableArray* allEvents;
    
    CalendarMonthView* calendarView;
    
}

- (IBAction)viewAllEventsButtonPressed:(id)sender;


@end
