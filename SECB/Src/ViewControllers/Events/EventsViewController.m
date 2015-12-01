//
//  EventsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EventsViewController.h"
#import "CalendarMonthView.h"
#import "AllEventsViewController.h"
#import "EventDetailsViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:LocalizedString(@"View all Events",)];
    [temString addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:1]
                      range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSFontAttributeName value:viewAllEventsButton.titleLabel.font range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSForegroundColorAttributeName value:viewAllEventsButton.titleLabel.textColor range:(NSRange){0,[temString length]}];
    [viewAllEventsButton setAttributedTitle:temString forState:UIControlStateNormal];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Events", );
    
    [super refreshLocalization];
    
}


- (void)addCalenderView
{
    calendarView = [[CalendarMonthView alloc] initWithEventsList:nil];
    calendarView.delegate = self;
    CGRect frame = calendarView.frame;
    frame.origin.y = (isIPhone)? 64 : 78;
    frame.origin.x = (isIPhone)? 0 : 46;
    calendarView.frame = frame;
    [viewContrainer addSubview:calendarView];
    
    [self didDisplayMonth:(int)[NSDate date].month year:(int)[NSDate date].year];
}
- (void)viewWillAppear:(BOOL)animated
{
    if(!viewAppearedBefor)
    {
        [self addCalenderView];
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)getEventsFrom:(NSDate*)fDate to:(NSDate*)tDate
{
    EventsFilter* filter = [[EventsFilter alloc] init];
    filter.from = fDate;
    filter.to = tDate;
    [GetEventsOperation addObserver:self];
    [BaseOperation queueInOperation:[[GetEventsOperation alloc] initWithToGetEventsWithFilters:filter]];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(tableViewDataSource.count, 2);
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

- (IBAction)viewAllEventsButtonPressed:(id)sender
{
    [self.navigationController pushViewController:[AllEventsViewController new] animated:YES];
}

#pragma mark - CalendarViewDelegate

- (void)refreshTableWithEventsList:(NSMutableArray*)eventsList
{
    tableViewDataSource = [NSMutableArray arrayWithArray:eventsList];
    [eventsTableView reloadData];
}

- (void)didDisplayMonth:(int)month year:(int)year
{
    [calendarView showProgressWithMessage:@""];
    NSInteger currentMonth = month;
    NSInteger currentYear = year;
    NSInteger nextMonth = (currentMonth+1 <=12)? currentMonth+1 : 1;
    NSInteger nextYear = (nextMonth == 1)? currentYear++ : currentYear;
    [self getEventsFrom:[NSDate dateWithDay:1 month:currentMonth year:currentYear] to:[NSDate dateWithDay:1 month:nextMonth year:nextYear]];
}

#pragma BaseOperationDelegate

- (void)operation:(GetEventsOperation*)operation succededWithObject:(id)object
{
    if(operation.isGettingEventsList)
    {
        tableViewDataSource = [NSMutableArray arrayWithArray:object];
        [eventsTableView reloadData];
        [calendarView updateWithEventsList:tableViewDataSource];
    }
    [[operation class] removeObserver:self];
    [calendarView hideProgress];
}

- (void)operation:(GetEventsOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    if(operation.isGettingEventsList)
    {
        [[operation class] removeObserver:self];
        [calendarView hideProgress];
        [error show];
    }
}


@end
