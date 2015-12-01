//
//  EServiceCard.m
//  SECB
//
//  Created by Peter Mosaad on 10/20/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EServiceCard.h"

@implementation EServiceCard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithEservice:(EService*)eservice
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"EServiceCard" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    
    self.currentEService = eservice;
    
    return self;
}

- (NSAttributedString*)attributedStringForTitle:(NSString*)title value:(NSString*)value
{
    UIColor* titleColor = [UIColor colorWithRed:18.0f/255.0f green:45.0f/255.0f blue:83.0f/255.0f alpha:1.0];
    UIColor* valueColor = [UIColor colorWithRed:106.0f/255.0f green:106.0f/255.0f blue:106.0f/255.0f alpha:1.0];
    UIFont* titleFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
    UIFont* valueFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
    NSMutableAttributedString* titleStr = [[NSMutableAttributedString alloc] initWithString:title
                                                                                 attributes:@{NSFontAttributeName : titleFont, NSForegroundColorAttributeName : titleColor}];
    // 1453
    NSAttributedString* valueStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@", value]
                                                                              attributes:@{NSFontAttributeName : valueFont, NSForegroundColorAttributeName : valueColor}];
    [titleStr appendAttributedString:valueStr];
    
    return titleStr;
}

- (void)updateCard
{

    calendarLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Date", ) value:[self.currentEService.date toStringWithFormat:@"dd MMM yyyy"]];
    statusLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Status", ) value:self.currentEService.status];
    numberLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Number", ) value:self.currentEService.number];
    typeLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Type", ) value:self.currentEService.type];
    
    int type = rand()%3;
    UIColor* color;
    switch (type) {
        case 0:
        color = [UIColor colorWithRed:238.0/255.0 green:64.0/255.0 blue:46.0/255.0 alpha:1.0];
        break;
        case 1:
        color = [UIColor colorWithRed:36.0/255.0 green:169.0/255.0 blue:223.0/255.0 alpha:1.0];
        break;
        case 2:
        color = [UIColor colorWithRed:126.0/255.0 green:194.0/255.0 blue:65.0/255.0 alpha:1.0];
        break;
        default:
        color = [UIColor colorWithRed:238.0/255.0 green:64.0/255.0 blue:46.0/255.0 alpha:1.0];
        break;
    }
    serviceTypeColorView.backgroundColor = color;
}

- (IBAction)cardTapped:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didClickEServiceCard:)])
        [self.delegate didClickEServiceCard:self];
        
}

@end
