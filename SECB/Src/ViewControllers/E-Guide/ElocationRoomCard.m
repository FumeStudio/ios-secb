//
//  ElocationRoomCard.m
//  SECB
//
//  Created by Peter Mosaad on 10/31/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "ElocationRoomCard.h"

@implementation ElocationRoomCard

- (NSAttributedString*)attributedStringForTitle:(NSString*)title value:(NSString*)value
{
    UIColor* titleColor = [UIColor colorWithRed:18.0f/255.0f green:45.0f/255.0f blue:83.0f/255.0f alpha:1.0];
    UIColor* valueColor = [UIColor colorWithRed:106.0f/255.0f green:106.0f/255.0f blue:106.0f/255.0f alpha:1.0];
    UIFont* titleFont = [UIFont fontWithName:@"HelveticaNeue" size:(isIPhone)?12.5:15];
    UIFont* valueFont = [UIFont fontWithName:@"HelveticaNeue" size:(isIPhone)?11:15];
    NSMutableAttributedString* titleStr = [[NSMutableAttributedString alloc] initWithString:title
                                                                                 attributes:@{NSFontAttributeName : titleFont, NSForegroundColorAttributeName : titleColor}];
    
    NSAttributedString* valueStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@", value]
                                                                   attributes:@{NSFontAttributeName : valueFont, NSForegroundColorAttributeName : valueColor}];
    [titleStr appendAttributedString:valueStr];
    
    return titleStr;
}

- (void)updateCard
{
    roomTypeLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Room Type", ) value:self.currentRoom.roomType];
    roomCapacityLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Room Capacity", ) value:self.currentRoom.roomCapacity];
    roomSpaceLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Room Space", ) value:self.currentRoom.roomArea];
    numberOfRoomsLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Number of Rooms", ) value:self.currentRoom.roomsCount];
}

+ (ElocationRoomCard *)cardForRoom:(LocationRoom *)room
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ElocationRoomCard" owner:nil options:nil];
    ElocationRoomCard* card = [nibViews objectAtIndex:0];
    card.currentRoom = room;
    [card updateCard];
    
    return card;
}

@end
