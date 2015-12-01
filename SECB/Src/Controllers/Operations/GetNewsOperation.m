//
//  GetNewsOperation.m
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GetNewsOperation.h"

@implementation NewsFilter

@end

@implementation GetNewsOperation


+ (NSMutableArray*)allNewsCategories
{
    static NSMutableArray* news_categories;
    @synchronized(self) {
        if (news_categories == nil) {
            news_categories = [[NSMutableArray alloc] init];
        }
    }
    
    return news_categories;
}

+ (NSMutableArray*)allNews
{
    static NSMutableArray* all_news;
    @synchronized(self) {
        if (all_news == nil) {
            all_news = [[NSMutableArray alloc] init];
        }
    }
    
    return all_news;
}

- (id)initWithToGetNewsWithFilters:(NewsFilter*)filter
{
    self = [super init];
    self.isGettingNewsList = YES;
    self.currentFilter = filter;
    return self;
}

- (id)initWithToGetDetailsOfNews:(News*)news
{
    self = [super init];
    self.isGettingNewsList = YES;
    self.currentNews = news;
    return self;
}

- (id)initToGetNewsCategories
{
    self = [super init];
    self.isGettingNewsCategories = YES;
    return self;
}

+ (void)clearCachedData
{
    [[self allNews] removeAllObjects];
}

- (id)doMain
{
    NSData* response = [self doRequest];
    
    NSMutableArray* results = [self parseResponseFromHttpResponse:response];
    if(self.isGettingNewsList && ![[self class] allNews].count)
    {
        [[[self class] allNews] addObjectsFromArray:results];
    }
    else if(self.isGettingNewsCategories)
        [[[self class] allNewsCategories] addObjectsFromArray:results];

    return results;
}

- (NSData *)doRequest
{
    /// construct URL and Create connection
    NSString* url;
    if(self.isGettingNewsList)
    {
        url = [NSString stringWithFormat:@"%@%@?Lang=%@", Base_Service_URL, GetNewsList_URLSuffix, LocalizedString(@"Lang_URL_Key",)];
        if(self.currentNews)
            url = [url stringByAppendingFormat:@"&NewsID=%@", self.currentNews.ID];
        else
            url = [url stringByAppendingString:@"&NewsID=All"];
        
        if(self.currentFilter.from)
            url = [url stringByAppendingFormat:@"&fromDate=%@", [self.currentFilter.from toStringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss" Locale:[NSLocale localeWithLocaleIdentifier:@"EN"]]];
        else
            url = [url stringByAppendingFormat:@"&fromDate=%@", @"null"];
        if(self.currentFilter.to)
            url = [url stringByAppendingFormat:@"&toDate=%@", [self.currentFilter.to toStringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss" Locale:[NSLocale localeWithLocaleIdentifier:@"EN"]]];
        else
            url = [url stringByAppendingFormat:@"&toDate=%@", @"null"];
        if(self.currentFilter.selectedCategoryIDs)
            url = [url stringByAppendingFormat:@"&NewsCategory=%@", [self.currentFilter.selectedCategoryIDs componentsJoinedByString:@","]];
        else
            url = [url stringByAppendingFormat:@"&NewsCategory=%@", NewsCategoryAll];
        if(self.currentFilter.pageIndex)
            url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", self.currentFilter.pageIndex];
        else
            url = [url stringByAppendingFormat:@"&pageSize=20&pageIndex=%d", 0];
    }
    else
        url = [NSString stringWithFormat:@"%@%@", Base_Service_URL, GetNewsCategories_URLSuffix];
    
    NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]]];
    NSDictionary *headers = @{ @"Cookie": [cookieHeaders objectForKey:@"Cookie"] };
    return [BaseOperation doRequestWithHttpMethod:@"GET" URL:url requestBody:nil customHttpHeaders:headers forOperation:self];
}

- (NSMutableArray*)parseResponseFromHttpResponse:(NSData*)response
{
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if([jsonArray isKindOfClass:[NSArray class]])
    {
        if(self.isGettingNewsList)
        {
            if(self.currentNews)
            {
                [self.currentNews getDataFromJsonObject:jsonArray.firstObject];
            }
            else
            {
                NSMutableArray* newsList = [NSMutableArray array];
                for(NSDictionary* json in jsonArray)
                    [newsList addObject:[[News alloc] initWithJSONObject:json]];
                return newsList;
            }
        }
        else
        {
            NSMutableArray* newsCategories = [NSMutableArray array];
            NewsCategory* category = [[NewsCategory alloc] init];
            category.arTitle = @"الكل";
            category.enTitle = @"All";
            category.ID = NewsCategoryAll;
            [newsCategories addObject:category];
            for(NSDictionary* json in jsonArray)
                [newsCategories addObject:[[NewsCategory alloc] initWithJSONObject:json]];
            return newsCategories;
        }
    }
    return nil;
}



@end
