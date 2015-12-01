//
//  SignUpViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/13/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [signupWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:LocalizedString(@"SignUpFormURL",)]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Signup", );
    
    [super refreshLocalization];
    
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
