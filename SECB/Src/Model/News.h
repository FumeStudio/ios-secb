//
//  News.h
//  SECB
//
//  Created by Peter Mosaad on 10/17/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property(strong) NSString* title;
@property(strong) NSDate* creationDate;
@property(strong) NSString* ID;
@property(strong) NSString* imageUrl;
@property(strong) NSString* newsCategory;
@property(strong) NSString* newsBrief;
@property(strong) NSString* newsBody;

@end


@interface NewsCategory : NSObject

@property(strong) NSString* arTitle;
@property(strong) NSString* enTitle;
@property(strong) NSString* ID;

@end