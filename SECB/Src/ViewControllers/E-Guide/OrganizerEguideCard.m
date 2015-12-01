//
//  OrganizerEguideCard.m
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "OrganizerEguideCard.h"

@implementation OrganizerEguideCard

- (instancetype)init
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"OrganizerEguideCard" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    
    return self;
}

+ (OrganizerEguideCard*)cardForOrganizer:(id)organizer
{
    OrganizerEguideCard* card = [[OrganizerEguideCard alloc] init];
    card.currentOrganizer = organizer;
    return card;
}

- (void)updateCard
{
    [organizerImageView setImageWithImageUrl:self.currentOrganizer.image andPlaceHolderImage:nil];
    nameLabel.text = self.currentOrganizer.name;
    descriptionLabel.text = self.currentOrganizer.organizerDescription;
}

- (IBAction)cardTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didClickOrganizerEguideCard:)])
        [self.delegate didClickOrganizerEguideCard:self];
}


@end
