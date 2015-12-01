//
//  EventsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "AllEventsViewController.h"
#import "EventDetailsViewController.h"
#import "KeyValueCellTableViewCell.h"
#import "CheckMarkTableViewCell.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

@interface AllEventsViewController ()
{
}
@end

@implementation AllEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getNextPage:) forControlEvents:UIControlEventValueChanged];
    eventsTableView.bottomRefreshControl = refreshControl;
    
    //
    self.currentSelectedMenuItem = MenuActionNews;
    
    ///
    [self resetFilters];
    ///
    [self getEventCategories];
    [self getEventCities];
    [self getEventsList];
}

- (void)resetFilters
{
    currentFilter = [[EventsFilter alloc] init];
    currentFilter.selectedCategoryIDs = [NSMutableArray arrayWithObject:NewsCategoryAll];
    currentFilter.selectedCityID = NewsCategoryAll;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Events", );
    
    [super refreshLocalization];
    
}

- (void)getNextPage:(UIRefreshControl *)refreshControl
{
    currentFilter.pageIndex ++;
    [self getEventsList];
}

- (void)getEventCategories
{
    if([GetEventsOperation allEventCategories].count)
        eventCategories = [NSMutableArray arrayWithArray:[GetEventsOperation allEventCategories]];
    else
    {
        [GetEventsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetEventsOperation alloc] initToGetEventsCategories]];
    }
}

- (void)getEventCities
{
    if([GetEventsOperation allEventCities].count)
        eventCities = [NSMutableArray arrayWithArray:[GetEventsOperation allEventCities]];
    else
    {
        [GetEventsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetEventsOperation alloc] initToGetEventCities]];
    }
}


- (void)getEventsList
{
    [eventsTableView showProgressWithMessage:@""];
    [GetEventsOperation addObserver:self];
    GetEventsOperation* eventsOp = [[GetEventsOperation alloc] initWithToGetEventsWithFilters:currentFilter];
    [BaseOperation queueInOperation:eventsOp];
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    EventCard* card = [EventCard cardForEvent:[tableViewDataSource objectAtIndex:indexPath.row]];
    card.delegate = self;
    [card updateCard];
    
    CGRect frame = card.frame;
    frame.origin.x = (tableView.frame.size.width - frame.size.width)/2.0;
    frame.origin.y = (tableView.rowHeight - frame.size.height)/2.0;
    card.frame = frame;
    [cell.contentView addSubview:card];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark  - EventCardDelegate

- (void)didClickEventCard:(EventCard*)card
{
    [self.navigationController pushViewController:[[EventDetailsViewController alloc] initWithEvent:card.currentEvent] animated:YES];
}

#pragma mark - FilterViewDelegate

- (NSInteger)filtersTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section)? eventCategories.count : 3;
}

- (UITableViewCell *)filtersTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if(indexPath.section == 0)
    {
        NSString* title;
        NSString* value;
        if(!indexPath.row)
        {
            value = LocalizedString(@"All", );
            for(EventCity* city in eventCities)
            {
                if([city.ID isEqual:currentFilter.selectedCityID])
                {
                    value = (IsCurrentLangaugeArabic)? city.arTitle : city.enTitle;
                    break;
                }
            }
            title = LocalizedString(@"City",);
        }
        else
        {
            title = (indexPath.row == 2)? LocalizedString(@"To",) : LocalizedString(@"From", );
            value = (indexPath.row == 2)? [currentFilter.to toStringWithFormat:@"dd MMM yyyy"] : [currentFilter.from toStringWithFormat:@"dd MMM yyyy"];
        }
        
        cell = [[KeyValueCellTableViewCell alloc] initWithTitle:title value:value];
    }
    else if(indexPath.section == 1)
    {
        EventCategory* category = [eventCategories objectAtIndex:indexPath.row];
        
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
        
        EventCategory* selected = [eventCategories objectAtIndex:indexPath.row];
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
        {
            if(indexPath.row == 1)
                [filterView showDatePickerWithTarget:self completionSelector:@selector(didSelectFromDate:) OriginalDate:currentFilter.from];
            else
                [filterView showDatePickerWithTarget:self completionSelector:@selector(didSelectToDate:) OriginalDate:currentFilter.to];
        }
        else
        {
            NSMutableArray* cityTitles = [NSMutableArray array];
            int originalSelected = 0;
            for(EventCity* city in eventCities)
            {
                [cityTitles addObject:(IsCurrentLangaugeArabic)? city.arTitle : city.enTitle];
                if([city.ID isEqual:currentFilter.selectedCityID])
                    [eventCities indexOfObject:city];
            }
            [filterView showDataPickerWithTarget:self withOptions:cityTitles initialSelectedIndex:originalSelected];
        }
    }
}

- (NSString*)filtersViewHeaderTitle
{
    return LocalizedString(@"Events Filter", );
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

- (void)didSelectItemAtIndex:(NSNumber*)index
{
    currentFilter.selectedCityID = ((EventCity*)([eventCities objectAtIndex:index.integerValue])).ID;
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
    [self getEventsList];
}

- (void)didResetFiltersPressed
{
    [self resetFilters];
    [filterView refreshSelectedFilters];
    [self didApplyFiltersPressed];
}

#pragma mark - BaseOperationDelegate

- (void)operation:(GetEventsOperation*)operation succededWithObject:(id)object
{
    if(operation.isGettingEventsList)
    {
        if(operation.currentEvent)
        {
            [self.navigationController pushViewController:[[EventDetailsViewController alloc] initWithEvent:operation.currentEvent] animated:YES];
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
            [eventsTableView.bottomRefreshControl endRefreshing];
            
            [eventsTableView reloadData];
        }
        [eventsTableView hideProgress];
    }
    else if(operation.isGettingEventsCities)
    {
        eventCities = [NSMutableArray arrayWithArray:object];
    }
    else
    {
        eventCategories = [NSMutableArray arrayWithArray:object];
        [filterView refreshSelectedFilters];
    }
}

- (void)operation:(GetEventsOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    if(operation.isGettingEventsList)
    {
        [[operation class] removeObserver:self];
        [eventsTableView hideProgress];
        [error show];
    }
}

@end

