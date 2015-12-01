//
//  AboutUsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/21/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    contentScrollView.contentSize = CGSizeMake(0, 460);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"About Us", );
    
    [super refreshLocalization];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
