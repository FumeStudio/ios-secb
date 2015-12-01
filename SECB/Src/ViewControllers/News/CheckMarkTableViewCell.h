//
//  CeckMarkTableViewCell.h
//  SECB
//
//  Created by Peter Mosaad on 10/6/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckMarkTableViewCell : UITableViewCell
{
    BOOL isEguideCell;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;

- (id)initWithTitle:(NSString*)title;
- (id)initForEguideWithTitle:(NSString*)title;
- (void)setChecked:(BOOL)checked;


@end
