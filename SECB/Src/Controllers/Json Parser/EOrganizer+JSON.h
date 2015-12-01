//
//  EOrganizer+JSON.h
//  SECB
//
//  Created by Peter Mosaad on 10/26/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EOrganizer.h"

@interface EOrganizer (JSON)

- (id)initWithJSONObject:(NSDictionary*)json;
- (void)getDataFromJsonObject:(NSDictionary*)json;

@end
