//
//  ElocationRoomCard.h
//  SECB
//
//  Created by Peter Mosaad on 10/31/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELocation.h"

@interface ElocationRoomCard : LocalizableIconWithView
{
    __weak IBOutlet UILabel *roomTypeLabel;
    __weak IBOutlet UILabel *roomCapacityLabel;
    __weak IBOutlet UILabel *roomSpaceLabel;
    __weak IBOutlet UILabel *numberOfRoomsLabel;
}

@property(strong) LocationRoom* currentRoom;

+ (ElocationRoomCard*)cardForRoom:(LocationRoom*)room;

@end
