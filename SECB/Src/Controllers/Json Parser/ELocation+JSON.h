//
//  ELocation+JSON.h
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "ELocation.h"

@interface ELocation (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;
- (NSDictionary*)JSONObject;
- (void)getDataFromJsonObject:(NSDictionary*)json;

@end

@interface LocationRoom (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;

@end


@interface LocationType (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;

@end

@interface LocationCity (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;

@end


