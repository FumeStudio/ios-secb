//
//  EguideOrganizerDetailsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SuperViewController.h"
#import "EOrganizer.h"

@interface EguideOrganizerDetailsViewController : SuperViewController
{
    __weak IBOutlet UIImageView *organizerImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UILabel *phoneNumberLabel;
    __weak IBOutlet UILabel *emailLabel;
    __weak IBOutlet UILabel *websiteLabel;
    
    __weak IBOutlet UIScrollView *contentScrollView;
    
    EOrganizer* currentOrganizer;
}

- (id)initWithOrganizer:(EOrganizer*)organizer;

@end
