//
//  EserviceDetailsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EService.h"

@interface EserviceDetailsViewController : SuperViewController <UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *serviceDetailsViewController;
    EService* currentEservice;
}

- (id)initWithEservice:(EService*)eservice;

@end
