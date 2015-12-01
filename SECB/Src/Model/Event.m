//
//  Event.m
//  SECB
//
//  Created by Peter Mosaad on 10/17/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "Event.h"

@implementation Event

- (CLLocationCoordinate2D)coordinate
{
    NSArray* components = [self.siteonMap componentsSeparatedByString:@","];
    if(components.count >= 1)
        return CLLocationCoordinate2DMake([components.firstObject doubleValue], [[components objectAtIndex:1] doubleValue]);
    return CLLocationCoordinate2DMake(0, 0);
}

@end


@implementation EventCategory

@end

@implementation EventCity

@end