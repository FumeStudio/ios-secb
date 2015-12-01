//
//  EserviceDetailsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EserviceDetailsViewController.h"

@interface EserviceDetailsViewController ()

@end

@implementation EserviceDetailsViewController

- (id)initWithEservice:(EService*)eservice
{
    self = [super initWithDefaultNibFile];
    currentEservice = eservice;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL* url = [NSURL URLWithString:currentEservice.detailsURL];
    [serviceDetailsViewController loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"E-Services Form", );
    
    [super refreshLocalization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [webView showProgressWithMessage:@""];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView hideProgress];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [error show];
    [webView hideProgress];
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
