//
//  GetEservicesOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EService+JSON.h"

@interface EservicesFilters : NSObject

@property(strong) NSDate* fromDate;
@property(strong) NSDate* toDate;
@property(strong) NSString* status;
@property(strong) NSString* type;
@property(strong) NSString* requestNumber;
@property int pageIndex;

@end


@interface GetEservicesOperation : BaseOperation

@property (strong) EservicesFilters* currentFilter;

@property BOOL isGettingRequestTypes;
@property BOOL isGettingWorkSpaceModes;

+ (NSMutableArray*)allRequestTypes;
+ (NSMutableArray*)allWorkSpaceModes;


- (id)initToGetEservicesListWithFilters:(EservicesFilters*)filters;

- (id)initToGetWorkSpaceModes;
- (id)initToGetRequestTypes;

@end
