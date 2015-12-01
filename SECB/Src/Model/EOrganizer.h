//
//  EOrganizer.h
//  SECB
//
//  Created by Peter Mosaad on 10/26/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOrganizer : NSObject

@property(strong) NSString* name;
@property(strong) NSString* image;
@property(strong) NSString* city;
@property(strong) NSString* location;
@property(strong) NSString* phone;
@property(strong) NSString* email;
@property(strong) NSString* fax;
@property(strong) NSString* webAddress;
@property(strong) NSString* addressDescription;
@property(strong) NSString* organizerDescription;
@property(strong) NSString* district;
@property(strong) NSString* street;

@property (readonly) NSString* address;

@end
