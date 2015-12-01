//
//  AboutUsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/21/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SuperViewController.h"

@interface AboutUsViewController : SuperViewController
{
    __weak IBOutlet UIScrollView *contentScrollView;
    __weak IBOutlet UILabel *title_1_Label;
    __weak IBOutlet UILabel *about_1_Label;
    __weak IBOutlet UILabel *title_2_Label;
    __weak IBOutlet UILabel *about_2_Label;
    
}
@end
