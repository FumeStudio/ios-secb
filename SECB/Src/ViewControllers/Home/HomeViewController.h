//
//  HomeViewController.h
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCard.h"
#import "EventCard.h"
#import "GetNewsOperation.h"
#import "MBCircularProgressBarView.h"

@interface HomeViewController : SuperViewController <NewsCardDelegate, EventCardDelegate, BaseOperationDelegate>
{
    __weak IBOutlet UILabel *serviceRequestsTitleLabel;
    __weak IBOutlet UILabel *closeRequestsTitleLabel;
    __weak IBOutlet UILabel *requestsTitleLabel_1;
    __weak IBOutlet UILabel *inboxRequestsTitleLabel;
    __weak IBOutlet UILabel *requestsTitleLabel_2;
    __weak IBOutlet UILabel *inProgressRequestsTitleLabel;
    __weak IBOutlet UILabel *requestsTitleLabel_3;
    __weak IBOutlet UILabel *latestNewsTitleLabel;
    
    
    __weak IBOutlet UIScrollView *contentsScrollView;
    __weak IBOutlet UIView *latestNewsViewContainer;
    
    __weak IBOutlet UIButton *viewAllNewsButton;
    __weak IBOutlet UIButton *viewAllEventsButton;
    
    __weak IBOutlet UIView *progressViewsContainer;
    __weak IBOutlet MBCircularProgressBarView *closeRequestsProgressView;
    __weak IBOutlet MBCircularProgressBarView *inboxRequestsProgressView;
    __weak IBOutlet MBCircularProgressBarView *inProgressRequestsProgressView;
    
    ///
    NSMutableArray* latestNews;
}
- (IBAction)viewAllNewsButtonPressed:(id)sender;
- (IBAction)viewAllEventsButtonPressed:(id)sender;
@end
