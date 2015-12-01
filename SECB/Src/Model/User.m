//
//  User.m
//  Probooking
//
//  Created by Peter Mosaad on 12/15/14.
//  Copyright (c) 2014 All rights reserved.
//

#import "User.h"
@implementation User


//// Serialization of the object for caching
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
	}
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.username forKey:@"username"];
}

@end
