//
//  CeckMarkTableViewCell.m
//  SECB
//
//  Created by Peter Mosaad on 10/6/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "CheckMarkTableViewCell.h"

@implementation CheckMarkTableViewCell

- (id)initWithNibName:(NSString*)nibName title:(NSString*)title
{

    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    if (self)
    {
        self.titleLabel.text = title;
    }
    return self;
}

- (id)initWithTitle:(NSString*)title
{
    self = [self initWithNibName:@"CheckMarkTableViewCell" title:title];
    [self setChecked:false];
    return self;
}

- (id)initForEguideWithTitle:(NSString*)title
{
    self = [self initWithNibName:@"EguideCheckMarkTableViewCell" title:title];
    isEguideCell = YES;
    [self setChecked:false];
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChecked:(BOOL)checked
{
    if(isEguideCell)
    {
        self.checkMarkImageView.hidden = false;
        self.checkMarkImageView.image = [UIImage imageNamed:(checked)? @"eguide_Filter_Selected.png" : @"eguide_Filter_UnSelected.png"];
    }
    else
        self.checkMarkImageView.hidden = !checked;
}

@end
