//
//  GetEOrganizersOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/26/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"
#import "EOrganizer+JSON.h"

@interface OrganizerFilter : NSObject

@property (strong) NSString* name;
@property (strong) NSString* cityID;
@property int pageIndex;


@end

@interface GetEOrganizersOperation : BaseOperation
{
    
}

@property (strong) OrganizerFilter* currentFilter;

- (id)initToGetOrganizersWithFilters:(OrganizerFilter*)filter;

+ (NSMutableArray*)allOrganizers;

@end
