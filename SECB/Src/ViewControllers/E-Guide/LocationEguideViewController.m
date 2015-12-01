//
//  LocationEguideViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/22/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "LocationEguideViewController.h"
#import "NewsDetailsViewController.h"
#import "KeyValueCellTableViewCell.h"
#import "CheckMarkTableViewCell.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "EguideLocationDetailsViewController.h"

@interface LocationEguideViewController ()
{
}
@end

@implementation LocationEguideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getNextPage:) forControlEvents:UIControlEventValueChanged];
    locationsTableView.bottomRefreshControl = refreshControl;
    
    ///
    [self resetFilters];
    
    ///
    [self getLocationTypes];
    [self getLocationCities];
    [self getLocationsList];
}

- (void)resetFilters
{
    currentFilter = [[LocationsFilter alloc] init];
    currentFilter.selectedTypesIds = [NSMutableArray arrayWithObject:NewsCategoryAll];
    currentFilter.cityID = NewsCategoryAll;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [GetELocationsOperation removeObserver:self];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Location E-Guide", );
    
    [super refreshLocalization];
    
}


- (void)getNextPage:(UIRefreshControl *)refreshControl
{
    currentFilter.pageIndex ++;
    [self getLocationsList];
}

- (void)getLocationCities
{
    if([GetEventsOperation allEventCities].count)
        locationCities = [NSMutableArray arrayWithArray:[GetEventsOperation allEventCities]];
    else
    {
        [GetEventsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetEventsOperation alloc] initToGetEventCities]];
    }
}

- (void)getLocationTypes
{
    if([GetELocationsOperation allLocationTypes].count)
        locationTypes = [NSMutableArray arrayWithArray:[GetELocationsOperation allLocationTypes]];
    else
    {
        [GetELocationsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetELocationsOperation alloc] initToGetLocationTypes]];
    }
}

- (void)getLocationsList
{
    [locationsTableView showProgressWithMessage:@""];
    [GetELocationsOperation addObserver:self];
    GetELocationsOperation* newsOp = [[GetELocationsOperation alloc] initToGetLocationsWithFilters:currentFilter];
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

    LocationEguideCard* card = [LocationEguideCard cardForLocation:[tableViewDataSource objectAtIndex:index]];
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
            card = [LocationEguideCard cardForLocation:[tableViewDataSource objectAtIndex:index]];
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

- (void)didClickEguideLocationCard:(LocationEguideCard *)card
{
    if(isIPhone)
        [self.navigationController pushViewController:[[EguideLocationDetailsViewController alloc] initWithLocation:card.currentLocation] animated:YES];
    else
        [self.ipadContainerVC.navigationController pushViewController:[[EguideLocationDetailsViewController alloc] initWithLocation:card.currentLocation] animated:YES];
}

#pragma mark - FilterViewDelegate

- (FiltersView *)theFiltersView
{
    return filterView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self.view];
    if(CGRectContainsPoint(viewContrainer.frame, location) && filterViewIsPresented)
    {
        [self setFilterViewHidden:YES];
        return YES;
    }
    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

- (NSInteger)filtersTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    if(section == 1)
        return locationTypes.count;
    return 2;
}

- (UITableViewCell *)filtersTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if(indexPath.section == 0 || indexPath.section == 2)
    {
        NSString* title = @"";
        NSString* value = @"";
        if(indexPath.section == 0)
        {
            title = LocalizedString((indexPath.row == 0)? @"Location Name" : @"City", );
            if(indexPath.row == 0)
                value = (currentFilter.name.length)?currentFilter.name : LocalizedString(@"Any", );
            else
            {
                for(EventCity* city in locationCities)
                    if([city.ID isEqual:currentFilter.cityID])
                    {
                        value = (IsCurrentLangaugeArabic)? city.arTitle : city.enTitle;
                        break;
                    }
            }
        }
        else
        {
            title = LocalizedString((indexPath.row == 0)? @"From" : @"To",);
            value = (indexPath.row == 0)? currentFilter.capacityFrom : currentFilter.capacityTo;
            if(!value.length)
                value = LocalizedString(@"Any", );
        }
        
        cell = [[KeyValueCellTableViewCell alloc] initWithTitle:title value:value];
    }
    else if(indexPath.section == 1)
    {
        LocationType* type = [locationTypes objectAtIndex:indexPath.row];
        cell = [[CheckMarkTableViewCell alloc] initForEguideWithTitle:(IsCurrentLangaugeArabic)? type.arTitle : type.enTitle];
        for(NSString* selectedTypeId in currentFilter.selectedTypesIds)
            if([selectedTypeId isEqualToString:type.ID])
            {
                [(CheckMarkTableViewCell*)cell setChecked:YES];
                break;
            }
    }
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    return cell;
}

- (NSInteger)numberOfSectionsInFiltersTable:(UITableView *)tableView
{
    return 3;
}

- (NSString *)filtersTable:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UIView *)filtersTable:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, headerView.frame.size.width-28, headerView.frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    if(section == 1)
        titleLabel.text = LocalizedString(@"LOCATION TYPE", );
    else if(section == 2)
        titleLabel.text = LocalizedString(@"TOTAL CAPACITY", );
    else
        titleLabel.text =@"";
    
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
        if(indexPath.section == 1)
        {
            if(!currentFilter.selectedTypesIds)
                currentFilter.selectedTypesIds = [NSMutableArray array];
            
            LocationType* selected = [locationTypes objectAtIndex:indexPath.row];
            if([selected.ID isEqualToString:NewsCategoryAll])
                currentFilter.selectedTypesIds = [NSMutableArray arrayWithObject:NewsCategoryAll];
            else
            {
                for(NSString* ID in currentFilter.selectedTypesIds)
                    if([ID isEqualToString:NewsCategoryAll])
                    {
                        [currentFilter.selectedTypesIds removeObject:ID];
                        break;
                    }
                BOOL categoryAlreadyAdded = false;
                for(NSString* ID in currentFilter.selectedTypesIds)
                {
                    if([ID isEqualToString:selected.ID])
                    {
                        [currentFilter.selectedTypesIds removeObject:ID];
                        categoryAlreadyAdded = true;
                        break;
                    }
                }
                if(!categoryAlreadyAdded)
                    [currentFilter.selectedTypesIds addObject:selected.ID];
            }
            
            if(!currentFilter.selectedTypesIds.count)
                currentFilter.selectedTypesIds = [NSMutableArray arrayWithObject:NewsCategoryAll];
            [tableView reloadData];
        }
        else
        {
            NSString* message = LocalizedString((indexPath.row)? @"Enter capacity to" : @"Enter capacity from", );
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:message
                                                                  message:nil delegate:self cancelButtonTitle:LocalizedString(@"Cancel",) otherButtonTitles:LocalizedString(@"OK",), nil];
            myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            NSString* value = (indexPath.row)? currentFilter.capacityTo : currentFilter.capacityFrom;
            if(value.length)
                [myAlertView textFieldAtIndex:0].text = value;
            [myAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
            
            [myAlertView showWithCompletion:^(UIAlertView* alertView, NSInteger buttonIndex){
                if(buttonIndex !=alertView.cancelButtonIndex)
                {
                    NSString* value = [myAlertView textFieldAtIndex:0].text;
                    if(!value.length)
                        value = NewsCategoryAll;
                    
                    if(indexPath.row)
                        currentFilter.capacityTo = value;
                    else
                        currentFilter.capacityFrom = value;
                    
                    [self didFinishSelectingDate];
                    [tableView reloadData];
                }
            }];
        }
    }
    else
    {
        if(indexPath.row)
        {
            NSMutableArray* cityTitles = [NSMutableArray array];
            int originalSelected = 0;
            for(EventCity* city in locationCities)
            {
                [cityTitles addObject:(IsCurrentLangaugeArabic)? city.arTitle : city.enTitle];
                if([city.ID isEqual:currentFilter.cityID])
                    [locationCities indexOfObject:city];
            }
            [filterView showDataPickerWithTarget:self withOptions:cityTitles initialSelectedIndex:originalSelected];
        }
        else
        {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:LocalizedString(@"Enter location name",)
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
                        currentFilter.name = LocalizedString(@"Any", );
                    
                    [self didFinishSelectingDate];
                }
            }];
        }
    }
}

- (NSString*)filtersViewHeaderTitle
{
    return LocalizedString(@"Location Filter", );
}

- (void)didFinishSelectingDate
{
    [filterView refreshSelectedFilters];
}

- (void)didApplyFiltersPressed
{
    [self setFilterViewHidden:YES];
    currentFilter.pageIndex = 0;
    [self getLocationsList];
}

- (void)didResetFiltersPressed
{
    [self resetFilters];
    [filterView refreshSelectedFilters];
    [self didApplyFiltersPressed];
}

- (void)didSelectItemAtIndex:(NSNumber*)index
{
    currentFilter.cityID = ((EventCity*)([locationCities objectAtIndex:index.integerValue])).ID;
    [self didFinishSelectingDate];
}



#pragma mark - BaseOperationDelegate

- (void)operation:(GetELocationsOperation*)operation succededWithObject:(id)object
{
    if([operation isKindOfClass:[GetEventsOperation class]])
    {
        locationCities = [NSMutableArray arrayWithArray:object];
        [filterView refreshSelectedFilters];
    }
    else
    {
        if(operation.isGettingLocationsList)
        {
            if(operation.currentFilter.pageIndex)
                [tableViewDataSource addObjectsFromArray:object];
            else
            {
                tableViewDataSource = [NSMutableArray arrayWithArray:object];
                if(!tableViewDataSource.count)
                    [NSLocalizedString(@"No data available", ) show];
            }
            [locationsTableView.bottomRefreshControl endRefreshing];
            
            [locationsTableView reloadData];
            
            [locationsTableView hideProgress];
        }
        else if(!operation.isGettingLocationsDetails)
        {
            locationTypes = [NSMutableArray arrayWithArray:object];
            [filterView refreshSelectedFilters];
        }
    }
}

- (void)operation:(GetELocationsOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    if([operation isKindOfClass:[GetELocationsOperation class]])
    {
        if(operation.isGettingLocationsList)
        {
            [[operation class] removeObserver:self];
            [locationsTableView hideProgress];
            [error show];
        }
    }
}

@end
