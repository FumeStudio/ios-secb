//
//  EventCard.h
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+JSON.h"

@class EventCard;

@protocol EventCardDelegate <NSObject>
- (void)didClickEventCard:(EventCard*)card;

@end

@interface EventCard : LocalizableIconWithView
{
    __weak IBOutlet UILabel *dayLabel;
    __weak IBOutlet UILabel *monthLabel;
    __weak IBOutlet UILabel *eventTitleLabel;
    __weak IBOutlet UILabel *eventDescriptionLabel;
    __weak IBOutlet UILabel *eventTimeLabel;
    __weak IBOutlet UILabel *eventLocationLabel;
    __weak IBOutlet UILabel *eventCategoryLabel;
    
}

@property (weak) id<EventCardDelegate> delegate;
@property (weak) Event* currentEvent;

+ (EventCard*)cardForEvent:(Event*)event;
- (void)updateCard;

- (IBAction)cardTapped:(id)sender;


@end
