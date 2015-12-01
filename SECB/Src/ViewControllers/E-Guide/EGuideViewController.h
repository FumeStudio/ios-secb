//
//  EGuideViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SuperViewController.h"

@interface EGuideViewController : SuperViewController
{
    __weak IBOutlet UIButton *organizerEguideButtonn;
    __weak IBOutlet UIButton *locationEguideButton;
    
}
- (IBAction)locationEguideButtonPressed:(id)sender;
- (IBAction)organizerEguideButtonPressed:(id)sender;
@end
