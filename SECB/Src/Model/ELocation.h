//
//  ELocation.h
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELocation : NSObject

@property (strong) NSString* ID;
@property (strong) NSString* name;
@property (strong) NSString* image;
@property (strong) NSString* location;
@property (strong) NSString* capacity;
@property (strong) NSString* area;
@property (strong) NSString* phone;
@property (strong) NSString* email;
@property (strong) NSString* city;
@property (strong) NSString* type;
@property (strong) NSString* street;
@property (strong) NSString* addressDescription;
@property (strong) NSString* locationDescription;
@property (strong) NSString* featuresAndResources;
@property (strong) NSString* district;
@property (strong) NSString* webSite;

@property (strong) NSMutableArray* locationRooms;

@property (readonly) NSString* address;

@end

@interface LocationRoom : NSObject

@property (strong) NSString* roomArea;
@property (strong) NSString* roomCapacity;
@property (strong) NSString* roomsCount;
@property (strong) NSString* roomType;

@end

@interface LocationType : NSObject

@property(strong) NSString* arTitle;
@property(strong) NSString* enTitle;
@property(strong) NSString* ID;

@end

@interface LocationCity : NSObject

@property(strong) NSString* arTitle;
@property(strong) NSString* enTitle;
@property(strong) NSString* ID;

@end