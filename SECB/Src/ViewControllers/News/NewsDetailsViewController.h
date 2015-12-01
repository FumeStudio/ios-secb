//
//  NewsDetailsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/4/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "GetNewsOperation.h"

@interface NewsDetailsViewController : SuperViewController <BaseOperationDelegate>
{
    __weak IBOutlet UIScrollView *contentScrollView;
    __weak IBOutlet UIImageView *newsImageView;
    __weak IBOutlet UILabel *newsTitleLabel;
    __weak IBOutlet UILabel *newsDateLabel;
    __weak IBOutlet UILabel *newsTextLabel;
    
    News* currentNews;
}

- (id)initWithNews:(News*)news;

@end
