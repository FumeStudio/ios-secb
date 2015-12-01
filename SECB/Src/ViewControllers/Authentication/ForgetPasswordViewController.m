//
//  ForgetPasswordViewController.m
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshLocalization
{
    emailTextField.placeholder = LocalizedString(@"Email Address", );
    [resetPasswordButton setTitle:LocalizedString(@"Reset Password", ) forState:UIControlStateNormal];
    
    [super refreshLocalization];
    
}

- (IBAction)resetPasswordButtonPressed:(id)sender
{
    if(emailTextField.text.length)
    {
        [self.view showProgressWithMessage:@""];
        [ForgetPasswordOperation addObserver:self];
        [BaseOperation queueInOperation:[[ForgetPasswordOperation alloc] initWithUserName:emailTextField.text]];
    }
    else
        [LocalizedString(@"Please enter user name" , ) show];    
}

#pragma mark - BaseOperationDelegate

- (void)operation:(BaseOperation*)operation succededWithObject:(id)object
{
    [LocalizedString(@"Password have been sent to your email address", ) showWithCancelButtonTitle:LocalizedString(@"OK", ) OtherButtonTitle:nil Completion:^(BOOL cancelled){[self.navigationController popViewControllerAnimated:YES];}];
    [[operation class] removeObserver:self];
    [self.view hideProgress];
}

- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    [error show];
    [[operation class] removeObserver:self];
    [self.view hideProgress];
}

@end
