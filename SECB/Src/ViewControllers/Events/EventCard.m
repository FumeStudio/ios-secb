//
//  EventCard.m
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EventCard.h"

@implementation EventCard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"EventCard" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    
    return self;
}


+ (EventCard*)cardForEvent:(Event*)event
{
    EventCard* card = [[EventCard alloc] init];
    card.currentEvent = event;
    [card updateCard];
    return card;
}

- (void)updateCard
{
    dayLabel.text = [self.currentEvent.eventDate toStringWithFormat:@"dd"];
    monthLabel.text = [self.currentEvent.eventDate toStringWithFormat:@"MMM"];
    eventTitleLabel.text = self.currentEvent.eventTitle;
    eventDescriptionLabel.text = self.currentEvent.eventDescription;
    eventTimeLabel.text = [self.currentEvent.eventDate toStringWithFormat:@"HH:mm"];
    eventLocationLabel.text = self.currentEvent.eventSiteCity;
    eventCategoryLabel.text = self.currentEvent.eventCategory;;
}

- (IBAction)cardTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didClickEventCard:)])
        [self.delegate didClickEventCard:self];
}

@end
