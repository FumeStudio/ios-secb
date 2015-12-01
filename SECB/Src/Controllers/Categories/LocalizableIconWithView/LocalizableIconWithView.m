//
//  LocalizableIconWithView.m
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "LocalizableIconWithView.h"

@interface LocalizableIconWithView()
{
    BOOL adaptedBefore;
}

@end

@implementation LocalizableIconWithView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)invertTextAlignmentForView:(UIView*)view
{
    if([view respondsToSelector:@selector(setTextAlignment:)])
    {
        NSTextAlignment current = ((UILabel*)(view)).textAlignment;
        if(current == NSTextAlignmentLeft)
            current = NSTextAlignmentRight;
        else if(current == NSTextAlignmentRight)
            current = NSTextAlignmentLeft;
        [(UILabel*)view setTextAlignment:current];
    }
}

- (void)invertViews
{
    CGRect otherViewFrame = self.otherView.frame;
    CGRect iconFrame = self.drawableView.frame;
    iconFrame.origin.x = self.frame.size.width - (iconFrame.size.width + iconFrame.origin.x);
    otherViewFrame.origin.x = self.frame.size.width - (otherViewFrame.size.width + otherViewFrame.origin.x);
    self.otherView.frame = otherViewFrame;
    self.drawableView.frame = iconFrame;
    
    [self invertTextAlignmentForView:self.otherView];
    
    [self invertTextAlignmentForView:self.drawableView];
    
    /// Invert frames and text alignment for all subviews
    for(UIView* subView in self.otherView.subviews)
    {
        [self invertTextAlignmentForView:subView];
        
        if(subView.contentMode == UIViewContentModeLeft)
            subView.contentMode = UIViewContentModeRight;
        else if(subView.contentMode == UIViewContentModeRight)
            subView.contentMode = UIViewContentModeLeft;
        
        CGRect frame = subView.frame;
        frame.origin.x = self.otherView.frame.size.width - (subView.frame.size.width + subView.frame.origin.x);
        subView.frame = frame;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    BOOL isRTL = IsCurrentLangaugeArabic;
    if(!adaptedBefore && isRTL)
    {
        adaptedBefore = true;
        [self invertViews];
    }
}

@end
