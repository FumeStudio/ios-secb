//
//  User+JSON.h
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "User.h"

@interface User (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;
- (NSDictionary*)JSONObject;
- (void)getDataFromJsonObject:(NSDictionary*)json;

@end
