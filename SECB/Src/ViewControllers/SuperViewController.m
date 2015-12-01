//
//  SuperViewController.m
//  SECB
//
//  Created by Peter Mosaad on 1/12/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "SuperViewController.h"
#import "MenuView.h"
#import "CustomNavigationControllerViewController.h"
#import "HomeViewController.h"
#import "NewsViewController.h"
#import "EventsViewController.h"
#import "GallariesViewController.h"
#import "EserviceViewController.h"
#import "AboutUsViewController.h"
#import "EGuideViewController.h"
#import "ContactUsViewController.h"
#import "SignInViewController.h"
#import "GetNewsOperation.h"
#import "GetEventsOperation.h"
#import "iPad_EGuideViewController.h"

@interface SuperViewController ()
{
    MenuView* menu;
    BOOL menuIsPresented;
}
@end

@implementation SuperViewController

-(id)initWithDefaultNibFile
{
    return [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

#pragma mark - Orientation

//-(BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//    if(isIPhone)
//        return UIInterfaceOrientationPortrait;
//    else
//        return UIInterfaceOrientationLandscapeLeft;
//}
//
//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(isIPhone)
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    else
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - View life cycle

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!viewAppearedBefor)
    {        
        viewAppearedBefor = true;
    }
}

- (void)viewDidLoad
{
    UITapGestureRecognizer* tapgesture = [[UITapGestureRecognizer alloc] init];
    tapgesture.delegate = self;
    [self.view addGestureRecognizer:tapgesture];
    
    [self refreshLocalization];
    
    /// Add Swipe gestures for menu
    if(isIPhone)
    {
        UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(menuButtonPressed:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        swipe.delegate = self;
        [viewContrainer addGestureRecognizer:swipe];
        
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(menuButtonPressed:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        swipe.delegate = self;
        [viewContrainer addGestureRecognizer:swipe];
    }
    
    [super viewDidLoad];    
}

- (void)refreshLocalization
{
    [menu refreshLocalization];
    
    /// InvertViews
    //[self invertLocalizableViewsInView:self.view];
}

//- (UINavigationController *)navigationController
//{
//    if(isIPhone)
//        return super.navigationController;
//    else
//        return _iPadCustomNavigationController;
//}

- (void)invertLocalizableViewsInView:(UIView*)view
{
    if(![view respondsToSelector:@selector(invertViews)])
    {
        if(view.contentMode == UIViewContentModeLeft)
            view.contentMode = UIViewContentModeRight;
        else if(view.contentMode == UIViewContentModeRight)
            view.contentMode = UIViewContentModeLeft;
        if([view respondsToSelector:@selector(setTextAlignment:)])
        {
            NSTextAlignment current = ((UILabel*)(view)).textAlignment;
            if(current == NSTextAlignmentLeft)
                current = NSTextAlignmentRight;
            else if(current == NSTextAlignmentRight)
                current = NSTextAlignmentLeft;
            [(UILabel*)view setTextAlignment:current];
        }
    }

    for(UIView* sub in view.subviews)
    {
        if([sub respondsToSelector:@selector(invertViews)])
            [(LocalizableIconWithView*)sub invertViews];
        else
            [self invertLocalizableViewsInView:sub];
    }
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)previousViewController
{
    NSInteger myIndex = [self.navigationController.viewControllers indexOfObject:self];
    
    if ( myIndex != 0 && myIndex != NSNotFound ) {
        return [self.navigationController.viewControllers objectAtIndex:myIndex-1];
    } else {
        return nil;
    }
}

- (void)setMenuHidden:(BOOL)hidden
{
    CGRect frame = viewContrainer.frame;
    frame.origin.x = (hidden)? 0 : menu.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^(void){
        viewContrainer.frame = frame;
        //menu.alpha = (hidden)? 0 : 1;
    }completion:^(BOOL done){menuIsPresented = !hidden;}];
}

- (IBAction)menuButtonPressed:(id)sender
{
    if(!menu)
    {
        menu = [[MenuView alloc] init];
        menu.presentingViewController = self;
        if(isIPhone)
        {
            menu.contentSize = CGSizeMake(0, menu.frame.size.height);
            menu.scrollEnabled = true;
            CGRect frame = menu.frame;
            frame.size.height = self.view.frame.size.height;
            menu.frame = frame;
        }

        [menu refreshLocalization];
        [self.view addSubview:menu];
        [self.view sendSubviewToBack:menu];
    }
    
    [self setMenuHidden:menuIsPresented];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)performMenueAction:(MenuAction)action
{
    if(!isIPhone)
        [menu setSelectedMenuItem:action];
    
    if(action == self.currentSelectedMenuItem)
    {
        [self setMenuHidden:YES];
        return;
    }
    //[self setMenuHidden:YES];
    SuperViewController* viewControllerToBe = nil;
    switch (action) {
        case MenuActionHome:
        {
            viewControllerToBe = [HomeViewController new];
            break;
        }
        case MenuActionNews:
        {
            viewControllerToBe = [NewsViewController new];
            break;
        }
        case MenuActionEvents:
        {
            viewControllerToBe = [EventsViewController new];
            break;
        }
        case MenuActionImages:
        {
            viewControllerToBe = [[GallariesViewController alloc] initWithMediaType:MediaTypeImages];
            break;
        }
        case MenuActionVideos:
        {
            viewControllerToBe = [[GallariesViewController alloc] initWithMediaType:MediaTypeVideos];
            break;
        }
        case MenuActionEservice:
        {
            viewControllerToBe = [EserviceViewController new];
            break;
        }
        case MenuActionAboutUs:
        {
            viewControllerToBe = [AboutUsViewController new];
            break;
        }
        case MenuActionEguide:
        {
            viewControllerToBe = (isIPhone)? [EGuideViewController new] : [iPad_EGuideViewController new];
            break;
        }
        case MenuActionLanguage:
        {
            NSString* msg = (!IsCurrentLangaugeArabic)? @"Change language to English \n(Application Restart is Required)" : @"تغيير اللغة إلى العربية\n(عليك إعادة تشغيل التطبيق)";
            NSString* ysButton = (!IsCurrentLangaugeArabic)? @"Yes" : @"نعم";
            NSString* noButton = (!IsCurrentLangaugeArabic)? @"No" : @"لا";
            [msg showWithCancelButtonTitle:noButton OtherButtonTitle:ysButton Completion:^(BOOL cancelled){
                if(!cancelled)
                {
                    UILanguage langToBe = (IsCurrentLangaugeArabic)? UILanguageEnglish : UILanguageArabic;
                    SetAppLanguage(langToBe);
                    //[self refreshLocalization];
                    exit(0);
                }
            }];
            break;
        }
        case MenuActionContactUs:
        {
            viewControllerToBe = [ContactUsViewController new];
            break;
        }
        case MenuActionSignout:
        {
            NSString* msg = LocalizedString(@"Are you sure ?",);
            NSString* ysButton = LocalizedString(@"Yes",);
            NSString* noButton = LocalizedString(@"No",);
            [msg showWithCancelButtonTitle:noButton OtherButtonTitle:ysButton Completion:^(BOOL cancelled){
                if(!cancelled)
                {
                    // Delete all cookies
                    [UserManager deleteSavedCookies];
                    
                    /// ClearCachedData
                    [GetNewsOperation clearCachedData];
                    [GetEventsOperation clearCachedData];

                    /// show Login View
                    if(isIPhone)
                        [self.navigationController setViewControllers:[NSArray arrayWithObject:[SignInViewController new]] animated:YES];
                    else
                    {
                        UINavigationController* navigationController = [[CustomNavigationControllerViewController alloc] initWithRootViewController:[SignInViewController new]];
                        [navigationController setNavigationBarHidden:YES];

                        [UIView animateWithDuration:0.3 animations:^(void){[((UIWindow*)([UIApplication sharedApplication].windows.firstObject)) setRootViewController:navigationController];}];
                    }

                }
            }];
            break;
        }
        default:
            break;
    }

    if(!viewControllerToBe)
        [self setMenuHidden:YES];
    else
    {
        viewControllerToBe.currentSelectedMenuItem = action;
        self.currentSelectedMenuItem = action;
        if(isIPhone)
            [self.navigationController setViewControllers:[NSArray arrayWithObject:viewControllerToBe] animated:YES];
        else
            [self.iPadCustomNavigationController setViewControllers:[NSArray arrayWithObject:viewControllerToBe] animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
    {
        UISwipeGestureRecognizer* swipeGest = (UISwipeGestureRecognizer*)gestureRecognizer;
        if(swipeGest.direction == UISwipeGestureRecognizerDirectionRight && !menuIsPresented)
            return YES;
        else if(swipeGest.direction == UISwipeGestureRecognizerDirectionLeft && menuIsPresented)
            return YES;
        else
            return NO;
    }
    CGPoint location = [touch locationInView:self.view];
    
    
    if(CGRectContainsPoint(viewContrainer.frame, location))
    {
        if(filterViewIsPresented)
        {
            [self setFilterViewHidden:YES];
            return YES;
        }
        if(menuIsPresented)
        {
            [self setMenuHidden:YES];
            return YES;
        }
    }
    return NO;
}

#pragma mark - Filters

- (IBAction)filtersButtonPressed:(UIButton*)sender
{
    if(!filterView)
    {
        filterView = [[FiltersView alloc] init];
        
        filterView.delegate = self;
        
        if(isIPhone)
        {
            CGRect frame = filterView.frame;
            frame.origin.x = self.view.frame.size.width - frame.size.width;
            filterView.frame = frame;
            
            filterView.alpha = 0;
            [self.view addSubview:filterView];
            [self.view sendSubviewToBack:filterView];
            filterView.alpha = 1;
        }
    }
    
    if(isIPhone)
        [self setFilterViewHidden:filterViewIsPresented];
    else
    {
        if(!filtersPopover)
        {
            UIViewController* VC = [[UIViewController alloc] init];
            VC.view = filterView;
            filtersPopover = [[UIPopoverController alloc] initWithContentViewController:VC];
            filtersPopover.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"filterViewBG"]];
        }
        [filtersPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)setFilterViewHidden:(BOOL)hidden
{
    if(isIPhone)
    {
        CGRect frame = viewContrainer.frame;
        frame.origin.x = (hidden)? 0 : -1* filterView.frame.size.width;
        [UIView animateWithDuration:0.3 animations:^(void){
            viewContrainer.frame = frame;
            //menu.alpha = (hidden)? 0 : 1;
        }completion:^(BOOL done){filterViewIsPresented = !hidden;}];
    }
    else
    {
        [filtersPopover dismissPopoverAnimated:YES];
        filterViewIsPresented = !hidden;
    }
}

- (void)setFiltersView:(FiltersView*)filterV
{
    filterView = filterV;
}

@end