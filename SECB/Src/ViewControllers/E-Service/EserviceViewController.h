//
//  EserviceViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/21/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetEservicesOperation.h"
#import "EServiceCard.h"
#import "MBCircularProgressBarView.h"
#import "FiltersView.h"

@interface EserviceViewController : SuperViewController <BaseOperationDelegate, EServiceCardDelegate, FilterViewDelegate>
{
    __weak IBOutlet UIScrollView *cardsScrollView;
    
    __weak IBOutlet UILabel *closeRequestsTitleLabel;
    __weak IBOutlet UILabel *requestsTitleLabel_1;
    __weak IBOutlet UILabel *inboxRequestsTitleLabel;
    __weak IBOutlet UILabel *requestsTitleLabel_2;
    __weak IBOutlet UILabel *inProgressRequestsTitleLabel;
    __weak IBOutlet UILabel *requestsTitleLabel_3;

    __weak IBOutlet UILabel *servicesRequestsTitleLabel;
    
    __weak IBOutlet MBCircularProgressBarView *closeRequestsProgressView;
    __weak IBOutlet MBCircularProgressBarView *inboxRequestsProgressView;
    __weak IBOutlet MBCircularProgressBarView *inProgressRequestsProgressView;

    
    NSMutableArray* servicesArray;
    NSMutableArray* allRequestTypes;
    NSMutableArray* allWorkSpaceModes;
    
    EservicesFilters* currentFilter;
}



@end
