//
//  EServiceCard.h
//  SECB
//
//  Created by Peter Mosaad on 10/20/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EService.h"

@class EServiceCard;

@protocol EServiceCardDelegate <NSObject>
- (void)didClickEServiceCard:(EServiceCard*)card;

@end


@interface EServiceCard : UIView
{
    __weak IBOutlet UIView *serviceTypeColorView;
    
    __weak IBOutlet UILabel *calendarLabel;
    __weak IBOutlet UILabel *statusLabel;
    __weak IBOutlet UILabel *numberLabel;
    __weak IBOutlet UILabel *typeLabel;
}

@property(weak) id<EServiceCardDelegate> delegate;
@property(weak) EService* currentEService;

- (id)initWithEservice:(EService*)eservice;
- (void)updateCard;
- (IBAction)cardTapped:(id)sender;

@end
