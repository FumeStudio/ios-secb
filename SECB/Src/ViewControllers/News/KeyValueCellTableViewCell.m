//
//  KeyValueCellTableViewCell.m
//  SECB
//
//  Created by Peter Mosaad on 10/6/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "KeyValueCellTableViewCell.h"

@implementation KeyValueCellTableViewCell

- (id)initWithTitle:(NSString*)title value:(NSString*)value
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"KeyValueCellTableViewCell" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    if (self)
    {
        self.titleLabel.text = title;
        self.valueLabel.text = value;
    }
    return self;
}


//- (void)awakeFromNib
//{
//    self.titleLabel.text = titleStr;
//    self.valueLabel.text = valStr;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
