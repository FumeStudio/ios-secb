//
//  OrganizerEguideCard.h
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EOrganizer.h"

@class OrganizerEguideCard;

@protocol OrganizerEguideCardDelegate <NSObject>
- (void)didClickOrganizerEguideCard:(OrganizerEguideCard*)card;

@end


@interface OrganizerEguideCard : LocalizableIconWithView
{
    __weak IBOutlet UIImageView *organizerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *descriptionLabel;
}

@property (weak) id<OrganizerEguideCardDelegate> delegate;
@property (weak) EOrganizer* currentOrganizer;

+ (OrganizerEguideCard*)cardForOrganizer:(EOrganizer*)organizer;
- (void)updateCard;

@end
