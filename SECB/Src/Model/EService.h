//
//  EService.h
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EService : NSObject

@property(strong) NSString* name;
@property(strong) NSDate* date;
@property(strong) NSString* status;
@property(strong) NSString* number;
@property(strong) NSString* type;
@property(strong) NSString* detailsURL;

@end

@interface RequestType : NSObject

@property(strong) NSString* key;
@property(strong) NSString* value;

@end


@interface EserviceRequestType : NSObject

@property(strong) NSString* key;
@property(strong) NSString* value;

@end

@interface WorkSpaceMode : NSObject

@property(strong) NSString* arTitle;
@property(strong) NSString* enTitle;
@property(strong) NSString* ID;

@end

