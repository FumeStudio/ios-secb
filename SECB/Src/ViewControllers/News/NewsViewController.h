//
//  NewsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewsCard.h"

#import "FiltersView.h"

#import "GetNewsOperation.h"

@interface NewsViewController : SuperViewController <UITableViewDataSource, UITableViewDataSource, NewsCardDelegate, FilterViewDelegate, BaseOperationDelegate>
{
    __weak IBOutlet UITableView *newsTableView;
    
    NSMutableArray* tableViewDataSource;
    NSMutableArray* newsCategories;

    NewsFilter* currentFilter;
}
@end
