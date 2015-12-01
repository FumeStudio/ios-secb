//
//  NewsCard.m
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "NewsCard.h"

@implementation NewsCard

- (instancetype)init
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"NewsCard" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    
    return self;
}


+ (NewsCard*)cardForNews:(News*)news
{
    NewsCard* card = [[NewsCard alloc] init];
    card.currentNews = news;
    
    return card;
}

- (void)updateCard
{
    newsTitleLabel.text = self.currentNews.title;
    newsDescLabel.text = self.currentNews.newsBrief;
    [newsImageView setImageWithImageUrl:self.currentNews.imageUrl andPlaceHolderImage:nil];
    if(IsCurrentLangaugeArabic)
    {
        newsDateLabel.text = [NSString stringWithFormat:@"%@ %@", LocalizedString(@"ago", ), [[NSDate date] timeStringToDate:self.currentNews.creationDate]];
        arrowImageView.image = [UIImage imageNamed:@"newsCardArrowButton_ar.png"];
    }
    else
        newsDateLabel.text = [NSString stringWithFormat:@"%@ %@", [[NSDate date] timeStringToDate:self.currentNews.creationDate], LocalizedString(@"ago", )];
}

- (IBAction)cardTapped:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didClickNewsCard:)])
        [self.delegate didClickNewsCard:self];
}

@end
