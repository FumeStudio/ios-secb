//
//  OrganizerEguideViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/22/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "OrganizerEguideViewController.h"
#import "NewsDetailsViewController.h"
#import "KeyValueCellTableViewCell.h"
#import "CheckMarkTableViewCell.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "EguideOrganizerDetailsViewController.h"
#import "UIAlertView+Bolcks.h"

@interface OrganizerEguideViewController ()
{
}
@end

@implementation OrganizerEguideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getNextPage:) forControlEvents:UIControlEventValueChanged];
    organizersTableView.bottomRefreshControl = refreshControl;
    
    ///
    [self resetFilters];
    
    ///
    [self getOrganizerCities];
    [self getOrganizersList];
}

- (void)resetFilters
{
    currentFilter = [[OrganizerFilter alloc] init];
    currentFilter.cityID = NewsCategoryAll;
    currentFilter.name = NewsCategoryAll;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [GetEOrganizersOperation removeObserver:self];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Organizers E-Guide", );
    
    [super refreshLocalization];
    
}

- (void)getNextPage:(UIRefreshControl *)refreshControl
{
    currentFilter.pageIndex ++;
    [self getOrganizersList];
}

- (void)getOrganizerCities
{
    if([GetEventsOperation allEventCities].count)
        allCities = [NSMutableArray arrayWithArray:[GetEventsOperation allEventCities]];
    else
    {
        [GetEventsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetEventsOperation alloc] initToGetEventCities]];
    }
}

- (void)getOrganizersList
{
    [organizersTableView showProgressWithMessage:@""];
    [GetEOrganizersOperation addObserver:self];
    GetEOrganizersOperation* newsOp = [[GetEOrganizersOperation alloc] initToGetOrganizersWithFilters:currentFilter];
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
    
    int  index = (int)indexPath.row;
    
    if(!isIPhone && index)
        index += 1;
    
    OrganizerEguideCard* card = [OrganizerEguideCard cardForOrganizer:[tableViewDataSource objectAtIndex:index]];
    card.delegate = self;
    [card updateCard];
    
    CGRect frame = card.frame;
    if(isIPhone)
    {
        frame.origin.x = (tableView.frame.size.width - frame.size.width)/2.0;
        frame.origin.y = (tableView.rowHeight - frame.size.height)/2.0;
    }
    else
    {
        frame.origin.x = 35;
    }
    card.frame = frame;
    [cell.contentView addSubview:card];
    
    if(!isIPhone)
    {
        index += 1;
        if(index < tableViewDataSource.count)
        {
            card = [OrganizerEguideCard cardForOrganizer:[tableViewDataSource objectAtIndex:index]];
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

#pragma mark  - LocationCardDelegate

- (void)didClickOrganizerEguideCard:(OrganizerEguideCard *)card
{
    if(isIPhone)
        [self.navigationController pushViewController:[[EguideOrganizerDetailsViewController alloc] initWithOrganizer:card.currentOrganizer] animated:YES];
    else
        [self.ipadContainerVC.navigationController pushViewController:[[EguideOrganizerDetailsViewController alloc] initWithOrganizer:card.currentOrganizer] animated:YES];
}

#pragma mark - FilterViewDelegate

- (FiltersView *)theFiltersView
{
    return filterView;
}

- (NSInteger)filtersTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)filtersTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    NSString* title = @"";
    NSString* value = @"";
    
    title = (indexPath.row == 0)? @"Organizer Name" : @"City";
    if(indexPath.row)
    {
        for(EventCity* city in allCities)
        {
            if([city.ID isEqual:currentFilter.cityID])
            {
                value = (IsCurrentLangaugeArabic)? city.arTitle : city.enTitle;
                break;
            }
        }
    }
    else
        value = currentFilter.name;
    
    cell = [[KeyValueCellTableViewCell alloc] initWithTitle:title value:value];

    
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    return cell;
}

- (NSInteger)numberOfSectionsInFiltersTable:(UITableView *)tableView
{
    return 1;
}

- (NSString *)filtersTable:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UIView *)filtersTable:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)filtersTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row)
    {
        NSMutableArray* cityTitles = [NSMutableArray array];
        int originalSelected = 0;
        for(EventCity* city in allCities)
        {
            [cityTitles addObject:(IsCurrentLangaugeArabic)? city.arTitle : city.enTitle];
            if([city.ID isEqual:currentFilter.cityID])
                [allCities indexOfObject:city];
        }
        [filterView showDataPickerWithTarget:self withOptions:cityTitles initialSelectedIndex:originalSelected];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Enter organizer name",)
                                                              message:nil delegate:self cancelButtonTitle:LocalizedString(@"Cancel",) otherButtonTitles:LocalizedString(@"OK",), nil];
        myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        if(![currentFilter.name isEqualToString:NewsCategoryAll])
            [myAlertView textFieldAtIndex:0].text = currentFilter.name;
            
        [myAlertView showWithCompletion:^(UIAlertView* alertView, NSInteger buttonIndex){
            if(buttonIndex !=alertView.cancelButtonIndex)
            {
                if([alertView textFieldAtIndex:0].text.length)
                    currentFilter.name = [alertView textFieldAtIndex:0].text;
                else
                    currentFilter.name = NewsCategoryAll;
                
                [self didFinishSelectingDate];
            }
        }];
    }
}

- (void)didSelectItemAtIndex:(NSNumber*)index
{
    currentFilter.cityID = ((EventCity*)([allCities objectAtIndex:index.integerValue])).ID;
    [self didFinishSelectingDate];
}

- (NSString*)filtersViewHeaderTitle
{
    return LocalizedString(@"Organizer Filter", );
}


- (void)didFinishSelectingDate
{
    [filterView refreshSelectedFilters];
}

- (void)didApplyFiltersPressed
{
    [self setFilterViewHidden:YES];
    currentFilter.pageIndex = 0;
    [self getOrganizersList];
}

- (void)didResetFiltersPressed
{
    [self resetFilters];
    [filterView refreshSelectedFilters];
    [self didApplyFiltersPressed];
}


#pragma mark - BaseOperationDelegate

- (void)operation:(GetEOrganizersOperation*)operation succededWithObject:(id)object
{
    if([operation isKindOfClass:[GetEventsOperation class]])
    {
        allCities = [NSMutableArray arrayWithArray:object];
        [filterView refreshSelectedFilters];
        [[operation class] removeObserver:self];
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
        
        [organizersTableView.bottomRefreshControl endRefreshing];
        [organizersTableView reloadData];
        [organizersTableView hideProgress];
        [[operation class] removeObserver:self];
    }
}

- (void)operation:(GetEOrganizersOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    if([operation isKindOfClass:[GetEOrganizersOperation class]])
    {
        [[operation class] removeObserver:self];
        [organizersTableView hideProgress];
        [error show];
    }
}

@end
