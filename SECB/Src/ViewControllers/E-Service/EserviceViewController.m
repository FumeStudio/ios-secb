//
//  EserviceViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/21/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EserviceViewController.h"
#import "EServiceCard.h"
#import "EserviceDetailsViewController.h"
#import "KeyValueCellTableViewCell.h"
#import "CheckMarkTableViewCell.h"

@interface EserviceViewController ()
{
    
}
@end

@implementation EserviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self resetFilters];
    
    [self getEservicesList];
    [self getRequestTypes];
    [self getWorkSpaceModes];
}

- (void)resetFilters
{
    currentFilter = [EservicesFilters new];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"E-Services", );
    servicesRequestsTitleLabel.text = LocalizedString(@"Services Requests", );
    closeRequestsTitleLabel.text = LocalizedString(@"Closed", );
    requestsTitleLabel_1.text = LocalizedString(@"Requests", );
    inboxRequestsTitleLabel.text = LocalizedString(@"Inbox", );
    requestsTitleLabel_2.text = LocalizedString(@"Requests", );
    inProgressRequestsTitleLabel.text = LocalizedString(@"In Progress", );
    requestsTitleLabel_3.text = LocalizedString(@"Requests", );
    
    [super refreshLocalization];
}


- (void)getEservicesList
{
    [cardsScrollView showProgressWithMessage:@""];
    [GetEservicesOperation addObserver:self];
    [BaseOperation queueInOperation:[[GetEservicesOperation alloc] initToGetEservicesListWithFilters:currentFilter]];
}

- (void)getRequestTypes
{
    
    if([GetEservicesOperation allRequestTypes].count)
        allRequestTypes = [NSMutableArray arrayWithArray:[GetEservicesOperation allRequestTypes]];
    else
    {
        [GetEservicesOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetEservicesOperation alloc] initToGetRequestTypes]];
    }
}

- (void)getWorkSpaceModes
{
    
    if([GetEservicesOperation allWorkSpaceModes].count)
        allWorkSpaceModes = [NSMutableArray arrayWithArray:[GetEservicesOperation allWorkSpaceModes]];
    else
    {
        [GetEservicesOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetEservicesOperation alloc] initToGetWorkSpaceModes]];
    }
}


- (void)refreshProgressViewValues
{
    User* currentUser = [UserManager sharedInstance].currentLoggedInUser;
    float total = currentUser.inboxRequestsCounter + currentUser.inProgressRequestsCounter + currentUser.closedRequestsCounter;
    if(total)
    {
        float inboxVal = currentUser.inboxRequestsCounter / total;
        [inboxRequestsProgressView setValue:inboxVal*100 animateWithDuration:0.4];
        float closedVal = currentUser.closedRequestsCounter / total;
        [closeRequestsProgressView setValue:closedVal*100 animateWithDuration:0.4];
        float inProgVal = currentUser.inProgressRequestsCounter / total;
        [inProgressRequestsProgressView setValue:inProgVal*100 animateWithDuration:0.4];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshProgressViewValues];
    [super viewDidAppear:animated];
}

- (void)addCards
{
    int count = (int)servicesArray.count;
    float originY = 0;
    for(int i = 0; i < count; i++)
    {
        EServiceCard* card = [[EServiceCard alloc] initWithEservice:[servicesArray objectAtIndex:i]];
        card.delegate = self;
        [card updateCard];
        CGRect frame = card.frame;
        frame.origin.y = originY;
        card.frame = frame;
        
        originY = frame.origin.y + frame.size.height + 5;
        
        [cardsScrollView addSubview:card];
    }
    cardsScrollView.contentSize = CGSizeMake(0, originY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FilterViewDelegate

- (NSInteger)filtersTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else if(section == 1)
        return allRequestTypes.count;
    else
        return allWorkSpaceModes.count;
}

- (UITableViewCell *)filtersTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    
    if(indexPath.section == 0)
    {
        NSString* title = (indexPath.row)? LocalizedString(@"To",) : LocalizedString(@"From", );
        NSString* value = (indexPath.row)? [currentFilter.toDate toStringWithFormat:@"dd MMM yyyy"] : [currentFilter.fromDate toStringWithFormat:@"dd MMM yyyy"];
        
        cell = [[KeyValueCellTableViewCell alloc] initWithTitle:title value:value];
    }
    else if(indexPath.section == 1)
    {
        EserviceRequestType* requestType = [allRequestTypes objectAtIndex:indexPath.row];
        
        cell = [[CheckMarkTableViewCell alloc] initWithTitle:requestType.value];
            if([currentFilter.type isEqualToString:requestType.key])
                [(CheckMarkTableViewCell*)cell setChecked:YES];
    }
    else
    {
        WorkSpaceMode* workSpaceMode = [allWorkSpaceModes objectAtIndex:indexPath.row];
        
        cell = [[CheckMarkTableViewCell alloc] initWithTitle:(IsCurrentLangaugeArabic)? workSpaceMode.arTitle : workSpaceMode.enTitle];
        if([currentFilter.status isEqualToString:workSpaceMode.ID])
            [(CheckMarkTableViewCell*)cell setChecked:YES];
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
    if(section == 1)
        return LocalizedString(@"BY TYPE", );
    else if(section == 2)
        return LocalizedString(@"BY STATUS", );
    return  @"";
}

- (UIView *)filtersTable:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, headerView.frame.size.width-28, headerView.frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text =  (section == 1)? LocalizedString(@"BY TYPE", ) : LocalizedString(@"BY STATUS", );
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    [headerView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    if(IsCurrentLangaugeArabic)
        titleLabel.textAlignment = NSTextAlignmentRight;
    
    
    return headerView;
}

- (void)filtersTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        EserviceRequestType* requestType = [allRequestTypes objectAtIndex:indexPath.row];
        currentFilter.type = requestType.key;
        [tableView reloadData];
    }
    else if(indexPath.section == 2)
    {
        WorkSpaceMode* workSpaceMode = [allWorkSpaceModes objectAtIndex:indexPath.row];
        currentFilter.status = workSpaceMode.ID;
        [tableView reloadData];
    }
    else
    {
        if(indexPath.row)
            [filterView showDatePickerWithTarget:self completionSelector:@selector(didSelectToDate:) OriginalDate:currentFilter.toDate];
        else
            [filterView showDatePickerWithTarget:self completionSelector:@selector(didSelectFromDate:) OriginalDate:currentFilter.fromDate];
    }
}

- (void)didSelectFromDate:(NSDate*)selectedDate
{
    currentFilter.fromDate = selectedDate;
    [self didFinishSelectingDate];
}

- (void)didSelectToDate:(NSDate*)selectedDate
{
    currentFilter.toDate = selectedDate;
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
    [self getEservicesList];
}

- (void)didResetFiltersPressed
{
    [self resetFilters];
    [filterView refreshSelectedFilters];
    [self didApplyFiltersPressed];
}


- (NSString*)filtersViewHeaderTitle
{
    return LocalizedString(@"E-Service Filter", );
}

#pragma mark - BaseOperationDelegate
- (void)operation:(GetEservicesOperation*)operation succededWithObject:(id)object
{
    if(operation.isGettingRequestTypes)
    {
        allRequestTypes = [NSMutableArray arrayWithArray:object];
        [filterView refreshSelectedFilters];
    }
    else if(operation.isGettingWorkSpaceModes)
    {
        allWorkSpaceModes = [NSMutableArray arrayWithArray:object];
        [filterView refreshSelectedFilters];
    }
    else
    {
        servicesArray = [NSMutableArray arrayWithArray:object];
        [self addCards];
        [[operation class] removeObserver:self];
        [cardsScrollView hideProgress];
    }
}

- (void)operation:(GetEservicesOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    if(operation.isGettingRequestTypes && !operation.isGettingWorkSpaceModes)
    {
        [[operation class] removeObserver:self];
        [cardsScrollView hideProgress];
        [error show];
    }
}

#pragma mark - EServiceCardDelegate

- (void)didClickEServiceCard:(EServiceCard*)card
{
    [self.navigationController pushViewController:[[EserviceDetailsViewController alloc] initWithEservice:card.currentEService] animated:YES];
}


@end
