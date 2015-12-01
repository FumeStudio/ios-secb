//
//  SignInViewController.m
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SignInViewController.h"
#import "HomeViewController.h"
#import "ForgetPasswordViewController.h"
#import "SignUpViewController.h"
#import "AppDelegate.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:LocalizedString(@"Forgot password ?",)];
    [temString addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:1]
                      range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSFontAttributeName value:forgetPasswordButton.titleLabel.font range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSForegroundColorAttributeName value:forgetPasswordButton.titleLabel.textColor range:(NSRange){0,[temString length]}];
    [forgetPasswordButton setAttributedTitle:temString forState:UIControlStateNormal];
}

- (void)refreshLocalization
{
    userNameTextField.placeholder = LocalizedString(@"username", );
    passwordTextField.placeholder = LocalizedString(@"password", );
    [signInButton setTitle:LocalizedString(@"Login", ) forState:UIControlStateNormal];
    [registerButton setTitle:LocalizedString(@"Sign up", ) forState:UIControlStateNormal];
    
    [super refreshLocalization];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ButtonActions

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:viewContrainer];
    if(!CGRectContainsPoint(textFieldsContainerView.frame, location))
        [self.view endEditing:YES];
    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

- (IBAction)signupButtonPressed:(id)sender
{
    [self.navigationController pushViewController:[SignUpViewController new] animated:YES];
}


- (IBAction)loginButtonPressed:(id)sender
{
    if(userNameTextField.text.length && passwordTextField.text.length)
    {
        [self.view showProgressWithMessage:@""];
        [SignInOperation addObserver:self];
        User* userToBe = [[User alloc] init];
        userToBe.username = userNameTextField.text;
        userToBe.password = passwordTextField.text;
        [BaseOperation queueInOperation:[[SignInOperation alloc] initWithUser:userToBe]];
    }
    else
        [LocalizedString(@"Please enter a valid credentials",) show];
}

- (IBAction)forgetPasswordButtonPressed:(id)sender
{
    [self.navigationController pushViewController:[ForgetPasswordViewController new] animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:userNameTextField])
        [passwordTextField becomeFirstResponder];
    else
        [self loginButtonPressed:nil];
    
    return YES;
}

#pragma mark - BaseOperationDelegate

- (void)operation:(BaseOperation*)operation succededWithObject:(id)object
{
    if(isIPhone)
        [self.navigationController setViewControllers:[NSArray arrayWithObject:[HomeViewController new]] animated:YES];
    else
        [(AppDelegate*)[UIApplication sharedApplication].delegate setHomeViewController];
    
    [[operation class] removeObserver:self];
    [self.view hideProgress];
}

- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    [[operation class] removeObserver:self];
    [self.view hideProgress];
    [error show];
}

@end
