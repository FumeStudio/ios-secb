//
//  EService+JSON.h
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EService.h"

@interface EService (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;

@end

@interface EserviceRequestType (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;
- (void)getDataFromJsonObject:(NSDictionary*)json;

@end

@interface WorkSpaceMode (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;
- (void)getDataFromJsonObject:(NSDictionary*)json;

@end