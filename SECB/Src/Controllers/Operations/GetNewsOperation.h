//
//  GetNewsOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"
#import "News+JSON.h"

@interface NewsFilter : NSObject
@property (strong) NSDate* from;
@property (strong) NSDate* to;
@property int pageIndex;
@property (strong) NSMutableArray* selectedCategoryIDs;
@end

@interface GetNewsOperation : BaseOperation
{
    
}

@property (weak) NewsFilter* currentFilter;
@property BOOL isGettingNewsList;
@property BOOL isGettingNewsCategories;
@property (weak) News* currentNews;

- (id)initWithToGetNewsWithFilters:(NewsFilter*)filter;
- (id)initWithToGetDetailsOfNews:(News*)news;
- (id)initToGetNewsCategories;

+ (NSMutableArray*)allNewsCategories;
+ (NSMutableArray*)allNews;

+ (void)clearCachedData;

@end
