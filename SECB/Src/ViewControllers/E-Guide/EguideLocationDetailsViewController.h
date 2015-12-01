//
//  EguideLocationDetailsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SuperViewController.h"
#import "ELocation.h"
#import "GetELocationsOperation.h"

@interface EguideLocationDetailsViewController : SuperViewController <BaseOperationDelegate>
{
    __weak IBOutlet UIImageView *locationImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *typeLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UILabel *capacityLabel;
    __weak IBOutlet UILabel *spaceLabel;
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UILabel *phoneNumberLabel;
    __weak IBOutlet UILabel *emailLabel;
    __weak IBOutlet UILabel *websiteLabel;
    
    __weak IBOutlet LocalizableIconWithView *locationContactInfoView;
    __weak IBOutlet UIScrollView *contentScrollView;
    
    
    
    ELocation* currentLocation;
}

- (id)initWithLocation:(ELocation*)location;
- (IBAction)openWebSitePressed:(id)sender;

@end
