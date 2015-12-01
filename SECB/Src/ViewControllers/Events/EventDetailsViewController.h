//
//  EventDetailsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/4/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+JSON.h"

@interface EventDetailsViewController : SuperViewController <MKMapViewDelegate>
{
    __weak IBOutlet UILabel *dayLabel;
    __weak IBOutlet UILabel *monthLabel;
    __weak IBOutlet UILabel *eventTitleLabel;
    __weak IBOutlet UILabel *eventTimeLabel;
    __weak IBOutlet UILabel *eventLocationLabel;
    __weak IBOutlet UILabel *eventCategoryLabel;
    __weak IBOutlet UILabel *allDayEventTitleLabel;
    __weak IBOutlet UILabel *repeatedEventTitleLabel;
    
    __weak IBOutlet LocalizableIconWithView *allDayEventView;
    __weak IBOutlet LocalizableIconWithView *repeatedEventView;
    
    __weak IBOutlet UILabel *eventDetailsLabel;
    __weak IBOutlet MKMapView *locationMapView;
    
    __weak IBOutlet UIScrollView *contentScrollView;
    
    Event* currentEvent;
}

- (id)initWithEvent:(Event*)event;

@end
