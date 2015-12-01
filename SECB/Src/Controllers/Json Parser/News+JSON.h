//
//  News+JSON.h
//  SECB
//
//  Created by Peter Mosaad on 10/17/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "News.h"

@interface News (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;
- (NSDictionary*)JSONObject;
- (void)getDataFromJsonObject:(NSDictionary*)json;

@end

@interface NewsCategory (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;

@end
