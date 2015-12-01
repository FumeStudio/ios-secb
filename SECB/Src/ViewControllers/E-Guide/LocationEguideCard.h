//
//  LocationEguideCard.h
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELocation.h"

@class LocationEguideCard;

@protocol EguideLocationCardDelegate <NSObject>
- (void)didClickEguideLocationCard:(LocationEguideCard*)card;

@end


@interface LocationEguideCard : LocalizableIconWithView
{
    __weak IBOutlet UIImageView *locationImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *capacityLabel;
    __weak IBOutlet UILabel *spaceLabel;
}

@property (strong) ELocation* currentLocation;
@property (weak) id<EguideLocationCardDelegate> delegate;

+ (LocationEguideCard*)cardForLocation:(ELocation*)location;
- (void)updateCard;

@end
