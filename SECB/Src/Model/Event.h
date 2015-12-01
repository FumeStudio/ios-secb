//
//  Event.h
//  SECB
//
//  Created by Peter Mosaad on 10/17/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject <MKAnnotation>

@property (strong) NSString* ID;
@property (strong) NSDate* eventDate;
@property (strong) NSDate* EndDate;
@property (strong) NSString* eventSiteCity;
@property (strong) NSString* eventSiteName;
@property (strong) NSString* siteonMap;
@property (strong) NSString* eventDescription;
@property (strong) NSString* eventCategory;
@property (strong) NSString* eventSiteDescription;
@property (strong) NSString* eventTitle;
@property (strong) NSString* eventColor;

@property BOOL isAllDayEvent;
@property BOOL isRecurrence;

@end


@interface EventCategory : NSObject

@property(strong) NSString* arTitle;
@property(strong) NSString* enTitle;
@property(strong) NSString* ID;

@end

@interface EventCity : NSObject

@property(strong) NSString* arTitle;
@property(strong) NSString* enTitle;
@property(strong) NSString* ID;

@end