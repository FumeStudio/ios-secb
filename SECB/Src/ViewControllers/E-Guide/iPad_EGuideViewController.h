//
//  iPad_EGuideViewController.h
//  SECB
//
//  Created by Peter Mosaad on 11/13/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iPad_EGuideViewController : SuperViewController
{
    __weak IBOutlet UISegmentedControl *segmentControl;
    
}
- (IBAction)segmentControlValueChanged:(id)sender;

@end
