//
//  MenuView.m
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "MenuView.h"

@implementation MenuViewEntry

- (void)setSelected:(BOOL)selected
{
    self.entryIcon.highlighted = selected;
    self.entryLabel.textColor = (selected)? [UIColor colorWithRed:210.0/255.0 green:138.0/255.0 blue:48.0/255.0 alpha:1.0] : [UIColor whiteColor];
}

@end

@implementation MenuView

- (instancetype)init
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    
    [(MenuViewEntry*)menuEntryViews.firstObject setSelected:YES];
    
    return self;
}

- (void)setSelectedMenuItem:(MenuAction)selected
{
    if(!isIPhone)
        for(MenuViewEntry* entry in menuEntryViews)
            [entry setSelected:entry.tag==selected];
}

- (IBAction)menuItemButtonPressed:(UIButton*)sender
{
    [self.presentingViewController performMenueAction:(int)sender.tag];
}

- (void)refreshLocalization
{   
    homeLabel.text = LocalizedString(@"Home",);
    esrviceLabel.text = LocalizedString(@"E-Services",);
    newsLabel.text = LocalizedString(@"News",);
    eguideLabel.text = LocalizedString(@"E-Guide",);
    eventsLabel.text = LocalizedString(@"Events",);
    imagesLabel.text = LocalizedString(@"Images",);
    videosLabel.text = LocalizedString(@"Videos",);
    aboutUsLabel.text = LocalizedString(@"About Us",);
    contactUsLabel.text = LocalizedString(@"Contact Us",);
    languageLabel.text = (IsCurrentLangaugeArabic)? @"English" : @"عربي";
    signOutLabel.text = LocalizedString(@"Sign out",);
}

@end
