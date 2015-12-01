//
//  KeyValueCellTableViewCell.h
//  SECB
//
//  Created by Peter Mosaad on 10/6/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyValueCellTableViewCell : UITableViewCell
{
    NSString* titleStr;
    NSString* valStr;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (id)initWithTitle:(NSString*)title value:(NSString*)value;

@end
