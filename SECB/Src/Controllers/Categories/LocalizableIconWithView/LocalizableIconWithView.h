//
//  LocalizableIconWithView.h
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalizableIconWithView : UIView
{
}

@property (strong, nonatomic) IBOutlet UIView *drawableView;
@property (strong, nonatomic) IBOutlet UIView *otherView;

- (void)invertViews;

@end
