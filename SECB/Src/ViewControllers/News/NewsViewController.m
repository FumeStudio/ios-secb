//
//  NewsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailsViewController.h"
#import "KeyValueCellTableViewCell.h"
#import "CheckMarkTableViewCell.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

@interface NewsViewController ()
{
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getNextPage:) forControlEvents:UIControlEventValueChanged];
    newsTableView.bottomRefreshControl = refreshControl;
    
    //
    self.currentSelectedMenuItem = MenuActionNews;

    ///
    [self resetFilters];
    
    ///
    [self getNewsCategories];
    [self getNewsList];
}

- (void)resetFilters
{
    currentFilter = [[NewsFilter alloc] init];
    currentFilter.selectedCategoryIDs = [NSMutableArray arrayWithObject:NewsCategoryAll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [GetNewsOperation removeObserver:self];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"News", );
    
    [super refreshLocalization];
    
}


- (void)getNextPage:(UIRefreshControl *)refreshControl
{
    currentFilter.pageIndex ++;
    [self getNewsList];
}

- (void)getNewsCategories
{
    
    if([GetNewsOperation allNewsCategories].count)
        newsCategories = [NSMutableArray arrayWithArray:[GetNewsOperation allNewsCategories]];
    else
    {
        [GetNewsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetNewsOperation alloc] initToGetNewsCategories]];
    }
}

- (void)getNewsList
{
    [newsTableView showProgressWithMessage:@""];
    [GetNewsOperation addObserver:self];
    GetNewsOperation* newsOp = [[GetNewsOperation alloc] initWithToGetNewsWithFilters:currentFilter];
    [BaseOperation queueInOperation:newsOp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (isIPhone)? tableViewDataSource.count : tableViewDataSource.count/2 + tableViewDataSource.count%2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    int  index = indexPath.row;
    
    if(!isIPhone && index)
        index += 1;
    
    NewsCard* card = [NewsCard cardForNews:[tableViewDataSource objectAtIndex:index]];
    card.delegate = self;
    [card updateCard];
    
    CGRect frame = card.frame;
    if(isIPhone)
    {
        frame.origin.x = (tableView.frame.size.width - frame.size.width)/2.0;
        frame.origin.y = (tableView.rowHeight - frame.size.height)/2.0;
        card.frame = frame;
    }
    [cell.contentView addSubview:card];
    
    
    if(!isIPhone)
    {
        index += 1;
        if(index < tableViewDataSource.count)
        {
            card = [NewsCard cardForNews:[tableViewDataSource objectAtIndex:index]];
            card.delegate = self;
            [card updateCard];
            
            CGRect frame2 = card.frame;
            frame2.origin.x = frame.origin.x + frame.size.width + 10;
            card.frame = frame2;
            [cell.contentView addSubview:card];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark  - NewsCardDelegate

- (void)didClickNewsCard:(NewsCard*)card
{
//    [GetNewsOperation addObserver:self];
//    [newsTableView showProgressWithMessage:@""];
//    GetNewsOperation* op = [[GetNewsOperation alloc] initWithToGetDetailsOfNews:card.currentNews];
//    [BaseOperation queueInOperation:op];
    [self.navigationController pushViewController:[[NewsDetailsViewController alloc] initWithNews:card.currentNews] animated:YES];
}

#pragma mark - FilterViewDelegate

- (NSInteger)filtersTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section)? newsCategories.count : 2;
}

- (UITableViewCell *)filtersTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if(indexPath.section == 0)
    {
        NSString* title = (indexPath.row)? LocalizedString(@"To",) : LocalizedString(@"From", );
        NSString* value = (indexPath.row)? [currentFilter.to toStringWithFormat:@"dd MMM yyyy"] : [currentFilter.from toStringWithFormat:@"dd MMM yyyy"];
        
        cell = [[KeyValueCellTableViewCell alloc] initWithTitle:title value:value];
    }
    else if(indexPath.section == 1)
    {
        NewsCategory* category = [newsCategories objectAtIndex:indexPath.row];
        
        cell = [[CheckMarkTableViewCell alloc] initWithTitle:(IsCurrentLangaugeArabic)? category.arTitle : category.enTitle];
        for(NSString* catID in currentFilter.selectedCategoryIDs)
        {
            if([catID isEqualToString:category.ID])
            {
                [(CheckMarkTableViewCell*)cell setChecked:YES];
                break;
            }
        }
    }
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    return cell;
}

- (NSInteger)numberOfSectionsInFiltersTable:(UITableView *)tableView
{
    return 2;
}

- (NSString *)filtersTable:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section)? LocalizedString(@"BY TYPE", ) : @"";
}

- (UIView *)filtersTable:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, headerView.frame.size.width-28, headerView.frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text =  (section)? LocalizedString(@"BY TYPE", ) : @"";
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    [headerView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    if(IsCurrentLangaugeArabic)
        titleLabel.textAlignment = NSTextAlignmentRight;

    
    return headerView;
}

- (void)filtersTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section)
    {
        if(!currentFilter.selectedCategoryIDs)
            currentFilter.selectedCategoryIDs = [NSMutableArray array];
        
        NewsCategory* selected = [newsCategories objectAtIndex:indexPath.row];
        if([selected.ID isEqualToString:NewsCategoryAll])
            currentFilter.selectedCategoryIDs = [NSMutableArray arrayWithObject:NewsCategoryAll];
        else
        {
            for(NSString* ID in currentFilter.selectedCategoryIDs)
                if([ID isEqualToString:NewsCategoryAll])
                {
                    [currentFilter.selectedCategoryIDs removeObject:ID];
                    break;
                }
            BOOL categoryAlreadyAdded = false;
            for(NSString* ID in currentFilter.selectedCategoryIDs)
            {
                if([ID isEqualToString:selected.ID])
                {
                    [currentFilter.selectedCategoryIDs removeObject:ID];
                    categoryAlreadyAdded = true;
                    break;
                }
            }
            if(!categoryAlreadyAdded)
                [currentFilter.selectedCategoryIDs addObject:selected.ID];

        }
        
        if(!currentFilter.selectedCategoryIDs.count)
            currentFilter.selectedCategoryIDs = [NSMutableArray arrayWithObject:NewsCategoryAll];
        [tableView reloadData];
    }
    else
    {
        if(indexPath.row)
            [filterView showDatePickerWithTarget:self completionSelector:@selector(didSelectToDate:) OriginalDate:currentFilter.to];
        else
            [filterView showDatePickerWithTarget:self completionSelector:@selector(didSelectFromDate:) OriginalDate:currentFilter.from];
    }
}

- (void)didSelectFromDate:(NSDate*)selectedDate
{
    currentFilter.from = selectedDate;
    [self didFinishSelectingDate];
}

- (void)didSelectToDate:(NSDate*)selectedDate
{
    currentFilter.to = selectedDate;
    [self didFinishSelectingDate];
}


- (void)didFinishSelectingDate
{
    [filterView refreshSelectedFilters];
}

- (void)didApplyFiltersPressed
{
    [self setFilterViewHidden:YES];
    currentFilter.pageIndex = 0;
    [self getNewsList];
}

- (void)didResetFiltersPressed
{
    [self resetFilters];
    [filterView refreshSelectedFilters];
    [self didApplyFiltersPressed];
}


- (NSString*)filtersViewHeaderTitle
{
    return LocalizedString(@"News Filter", );
}

#pragma mark - BaseOperationDelegate

- (void)operation:(GetNewsOperation*)operation succededWithObject:(id)object
{
    if(operation.isGettingNewsList)
    {
        if(operation.currentNews)
        {
            [self.navigationController pushViewController:[[NewsDetailsViewController alloc] initWithNews:operation.currentNews] animated:YES];
        }
        else
        {
            if(operation.currentFilter.pageIndex)
                [tableViewDataSource addObjectsFromArray:object];
            else
            {
                tableViewDataSource = [NSMutableArray arrayWithArray:object];
                if(!tableViewDataSource.count)
                    [NSLocalizedString(@"No data available", ) show];
            }
            [newsTableView.bottomRefreshControl endRefreshing];
            
            [newsTableView reloadData];
        }
        [newsTableView hideProgress];
    }
    else
    {
        newsCategories = [NSMutableArray arrayWithArray:object];
        [filterView refreshSelectedFilters];
    }
}

- (void)operation:(GetNewsOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    if(operation.isGettingNewsList)
    {
        [[operation class] removeObserver:self];
        [newsTableView hideProgress];
        [error show];
    }
}

@end
