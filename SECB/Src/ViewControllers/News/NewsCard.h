//
//  NewsCard.h
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@class NewsCard;

@protocol NewsCardDelegate <NSObject>

- (void)didClickNewsCard:(NewsCard*)card;

@end

@interface NewsCard : LocalizableIconWithView
{
    __weak IBOutlet UIImageView *newsImageView;
    __weak IBOutlet UILabel *newsTitleLabel;
    __weak IBOutlet UILabel *newsDescLabel;
    __weak IBOutlet UILabel *newsDateLabel;
    __weak IBOutlet UIImageView *arrowImageView;
    
}

@property(weak) id<NewsCardDelegate> delegate;
@property(weak) News* currentNews;

+ (NewsCard*)cardForNews:(News*)news;
- (void)updateCard;

- (IBAction)cardTapped:(id)sender;
@end
