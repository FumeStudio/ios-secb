//
//  HomeViewController.m
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsViewController.h"
#import "NewsDetailsViewController.h"
#import "EventDetailsViewController.h"
#import "GetUserStatisticsOperation.h"
#import "GetEventsOperation.h"

@interface HomeViewController ()
{
    BOOL userStatRequestDone;
    BOOL newsRequestDone;
    BOOL eventsRequestDone;
}
@end

@implementation HomeViewController

- (BOOL)allRequestAreDone
{
    return userStatRequestDone && newsRequestDone && eventsRequestDone;
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Home", );
    serviceRequestsTitleLabel.text = LocalizedString(@"Services Requests", );
    closeRequestsTitleLabel.text = LocalizedString(@"Closed", );
    requestsTitleLabel_1.text = LocalizedString(@"Requests", );
    inboxRequestsTitleLabel.text = LocalizedString(@"Inbox", );
    requestsTitleLabel_2.text = LocalizedString(@"Requests", );
    inProgressRequestsTitleLabel.text = LocalizedString(@"In Progress", );
    requestsTitleLabel_3.text = LocalizedString(@"Requests", );
    latestNewsTitleLabel.text = LocalizedString(@"Latest News", );
    [super refreshLocalization];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:LocalizedString(@"View all News",)];
    [temString addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:1]
                      range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSFontAttributeName value:viewAllNewsButton.titleLabel.font range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSForegroundColorAttributeName value:viewAllNewsButton.titleLabel.textColor range:(NSRange){0,[temString length]}];
    [viewAllNewsButton setAttributedTitle:temString forState:UIControlStateNormal];
    
    temString=[[NSMutableAttributedString alloc]initWithString:LocalizedString(@"View all Events",)];
    [temString addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:1]
                      range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSFontAttributeName value:viewAllNewsButton.titleLabel.font range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSForegroundColorAttributeName value:viewAllNewsButton.titleLabel.textColor range:(NSRange){0,[temString length]}];
    [viewAllEventsButton setAttributedTitle:temString forState:UIControlStateNormal];

}

- (void)viewWillAppear:(BOOL)animated
{
    BOOL isDataLoaded = [GetEventsOperation allEvents].count || [GetNewsOperation allNews].count;
    if(!isDataLoaded)
        [viewContrainer showProgressWithMessage:@""];
    [self getEvents];
    [self getNews];
    [self getUserStatistics];
    
    [self refreshProgressViewValues];
    
    [super viewWillAppear:animated];
}

- (void)getEvents
{
    if([GetEventsOperation allEvents].count)
    {
        eventsRequestDone = YES;
        [self addEventCardWithEvent:[GetEventsOperation allEvents].firstObject];
    }
    else
    {
        [GetEventsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetEventsOperation alloc] initWithToGetEventsWithFilters:nil]];
    }
}

- (void)addEventCardWithEvent:(Event*)event
{
    EventCard* eventCard = [EventCard cardForEvent:event];
    CGRect frame = eventCard.frame;
    frame.origin.y = (isIPhone)? 182 : 234;
    frame.origin.x = (isIPhone)? 5 : 45;
    eventCard.frame = frame;
    eventCard.delegate = self;
    [contentsScrollView addSubview:eventCard];
}

- (void)getUserStatistics
{
    [GetUserStatisticsOperation addObserver:self];
    [BaseOperation queueInOperation:[[GetUserStatisticsOperation alloc] initWithUser:[UserManager sharedInstance].currentLoggedInUser]];
}

- (void)refreshProgressViewValues
{
    User* currentUser = [UserManager sharedInstance].currentLoggedInUser;
    float total = currentUser.inboxRequestsCounter + currentUser.inProgressRequestsCounter + currentUser.closedRequestsCounter;
    if(total)
    {
        float inboxVal = currentUser.inboxRequestsCounter / total;
        [inboxRequestsProgressView setValue:inboxVal*100 animateWithDuration:1];
        float closedVal = currentUser.closedRequestsCounter / total;
        [closeRequestsProgressView setValue:closedVal*100 animateWithDuration:1];
        float inProgVal = currentUser.inProgressRequestsCounter / total;
        [inProgressRequestsProgressView setValue:inProgVal*100 animateWithDuration:1];
    }
}

- (void)getNews
{
    if([GetNewsOperation allNews].count)
    {
        latestNews = [NSMutableArray arrayWithArray:[GetNewsOperation allNews]];
        [self addNewsCards];
        eventsRequestDone = YES;
    }
    else
    {
        [GetNewsOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetNewsOperation alloc] initWithToGetNewsWithFilters:nil]];
    }
}

- (void)addNewsCards
{
    int maxNewsCount = ([UIScreen mainScreen].bounds.size.height > 480)? 2 : 1;
    CGFloat originY = (isIPhone)? ([UIScreen mainScreen].bounds.size.height > 480)? 46 : 40 : 0;
    CGFloat originX = (isIPhone)? 9 : 0;
    for(int i = 0; (i < maxNewsCount && i < latestNews.count); i++)
    {
        NewsCard* newsCard = [NewsCard cardForNews:[latestNews objectAtIndex:i]];
        newsCard.delegate = self;
        [newsCard updateCard];
        CGRect frame = newsCard.frame;
        frame.origin.y = originY;
        frame.origin.x = originX;
        newsCard.frame = frame;
        if(isIPhone)
            originY += frame.size.height + 10;
        else
            originX += frame.size.width + 10;
        [latestNewsViewContainer addSubview:newsCard];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)viewAllNewsButtonPressed:(id)sender
{
    if(isIPhone)
        [super performMenueAction:MenuActionNews];
    else
    {
        SuperViewController* vc = (SuperViewController*)((UIWindow*)([UIApplication sharedApplication].windows.firstObject)).rootViewController;
        [vc performMenueAction:MenuActionNews];        
    }
}

- (IBAction)viewAllEventsButtonPressed:(id)sender
{
    if(isIPhone)
        [super performMenueAction:MenuActionEvents];
    else
    {
        SuperViewController* vc = (SuperViewController*)((UIWindow*)([UIApplication sharedApplication].windows.firstObject)).rootViewController;
        [vc performMenueAction:MenuActionEvents];
    }
}

#pragma mark  - NewsCardDelegate

- (void)didClickNewsCard:(NewsCard*)card
{
    [self.navigationController pushViewController:[[NewsDetailsViewController alloc] initWithNews:card.currentNews] animated:YES];
}

#pragma mark  - EventCardDelegate

- (void)didClickEventCard:(EventCard*)card
{
    [self.navigationController pushViewController:[[EventDetailsViewController alloc] initWithEvent:card.currentEvent] animated:YES];
}

#pragma mark - BaseOperationDelegate
- (void)operation:(BaseOperation*)operation succededWithObject:(id)object
{
    if([operation isKindOfClass:[GetNewsOperation class]])
    {
        latestNews = [NSMutableArray arrayWithArray:object];
        [self addNewsCards];
        newsRequestDone = YES;
    }
    else if([operation isKindOfClass:[GetUserStatisticsOperation class]])
    {
        [self refreshProgressViewValues];
        userStatRequestDone = YES;
    }
    else if([operation isKindOfClass:[GetEventsOperation class]])
    {
        if([object count])
            [self addEventCardWithEvent:[object objectAtIndex:0]];
        eventsRequestDone = YES;
    }
    if([self allRequestAreDone])
        [viewContrainer hideProgress];
    
    [[operation class] removeObserver:self];
}
- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    [[operation class] removeObserver:self];
    [error show];
    
    if([operation isKindOfClass:[GetNewsOperation class]])
        newsRequestDone = YES;
    else if([operation isKindOfClass:[GetUserStatisticsOperation class]])
        userStatRequestDone = YES;
    else if([operation isKindOfClass:[GetEventsOperation class]])
        eventsRequestDone = YES;
    
    if([self allRequestAreDone])
        [viewContrainer hideProgress];
    
}

@end
