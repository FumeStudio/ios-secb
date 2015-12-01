//
//  ELocation.m
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "ELocation.h"

@implementation ELocation

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

@implementation LocationRoom

@end


@implementation LocationType

@end


@implementation LocationCity

@end