//
//  LocationEguideCard.m
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "LocationEguideCard.h"

@implementation LocationEguideCard

- (instancetype)init
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"LocationEguideCard" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];

    return self;
}

+ (LocationEguideCard*)cardForLocation:(ELocation*)location
{
    LocationEguideCard* card = [[LocationEguideCard alloc] init];
    card.currentLocation = location;
    return card;
}

- (void)updateCard
{
    [locationImageView setImageWithImageUrl:self.currentLocation.image andPlaceHolderImage:nil];
    nameLabel.text = self.currentLocation.name;
    descriptionLabel.text = self.currentLocation.locationDescription;
    spaceLabel.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"Space",), self.currentLocation.area];
    capacityLabel.text = [NSString stringWithFormat:@"%@: %@", LocalizedString(@"Capacity",), self.currentLocation.capacity];
}

- (IBAction)cardTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didClickEguideLocationCard:)])
        [self.delegate didClickEguideLocationCard:self];
}

@end
