//
//  EGuideViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EGuideViewController.h"
#import "LocationEguideViewController.h"
#import "OrganizerEguideViewController.h"

@interface EGuideViewController ()

@end

@implementation EGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"E-Guide", );
    [organizerEguideButtonn setTitle:LocalizedString(@"Organizer’s E-Guide", ) forState:UIControlStateNormal];
    [locationEguideButton setTitle:LocalizedString(@"Location E-Guide", ) forState:UIControlStateNormal];
    
    [super refreshLocalization];
    
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

- (IBAction)locationEguideButtonPressed:(id)sender
{
    [self.navigationController pushViewController:[LocationEguideViewController new] animated:YES];
}

- (IBAction)organizerEguideButtonPressed:(id)sender
{
    [self.navigationController pushViewController:[OrganizerEguideViewController new] animated:YES];
}
@end
