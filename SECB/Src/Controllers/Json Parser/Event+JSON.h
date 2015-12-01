//
//  Event+JSON.h
//  SECB
//
//  Created by Peter Mosaad on 10/17/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "Event.h"

@interface Event (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;
- (NSDictionary*)JSONObject;
- (void)getDataFromJsonObject:(NSDictionary*)json;

@end

@interface EventCategory (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;

@end

@interface EventCity (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;

@end


