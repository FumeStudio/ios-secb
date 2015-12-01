//
//  EOrganizer.m
//  SECB
//
//  Created by Peter Mosaad on 10/26/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EOrganizer.h"

@implementation EOrganizer

- (NSString*)address
{
    NSMutableString* address = [NSMutableString string];
    if(self.street)
        [address appendFormat:@"%@",self.street];
    if(self.district)
        [address appendFormat:@", %@",self.district];
    if(self.addressDescription)
        [address appendFormat:@", %@",self.addressDescription];
    if(self.city)
        [address appendFormat:@", %@",self.city];
    
    return address;
}

@end
