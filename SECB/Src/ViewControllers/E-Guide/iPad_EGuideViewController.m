//
//  iPad_EGuideViewController.m
//  SECB
//
//  Created by Peter Mosaad on 11/13/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "iPad_EGuideViewController.h"
#import "LocationEguideViewController.h"
#import "OrganizerEguideViewController.h"

@interface iPad_EGuideViewController ()
{
    OrganizerEguideViewController* organizerEguideVC;
    LocationEguideViewController* locationEguideVC;
    UIView* currentDisplayedView;
}
@end

@implementation iPad_EGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    headerTitleLabel.text = LocalizedString(@"E-Guide", );
    
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filtersButtonPressed:(UIButton*)sender
{
    if(!filterView)
        filterView = [[FiltersView alloc] init];
    
    filterView.delegate = (segmentControl.selectedSegmentIndex)? organizerEguideVC : locationEguideVC;
    [organizerEguideVC setFiltersView:filterView];
    [locationEguideVC setFiltersView:filterView];
    
    if(filtersPopover)
        filtersPopover.contentViewController.view = filterView;

    [filterView refreshSelectedFilters];

    [super filtersButtonPressed:sender];
}

- (void)refreshView
{
    UIView* viewToBe = nil;
    if(segmentControl.selectedSegmentIndex)/// The Location Guide
    {
        if(!organizerEguideVC)
        {
            organizerEguideVC = [[OrganizerEguideViewController alloc] initWithDefaultNibFile];
            organizerEguideVC.ipadContainerVC = self;
            organizerEguideVC.view.alpha = 0;
            CGRect frame = organizerEguideVC.view.frame;
            frame.origin.y = 387;
            organizerEguideVC.view.frame = frame;
            [self.view addSubview:organizerEguideVC.view];
        }
        viewToBe = organizerEguideVC.view;
        
        filterView = organizerEguideVC.theFiltersView;
    }
    else
    {
        if(!locationEguideVC)
        {
            locationEguideVC = [[LocationEguideViewController alloc] initWithDefaultNibFile];
            locationEguideVC.ipadContainerVC = self;
            locationEguideVC.view.alpha = 0;
            CGRect frame = locationEguideVC.view.frame;
            frame.origin.y = 387;
            locationEguideVC.view.frame = frame;
            [self.view addSubview:locationEguideVC.view];

        }
        viewToBe = locationEguideVC.view;
        
        filterView = locationEguideVC.theFiltersView;
    }
    
    [UIView animateWithDuration:0.3 animations:^(void){
        viewToBe.alpha = 1.0;
        currentDisplayedView.alpha = 0.0;
    }completion:^(BOOL done){currentDisplayedView = viewToBe;}];
}

- (IBAction)segmentControlValueChanged:(id)sender
{
    [self refreshView];
}
@end
