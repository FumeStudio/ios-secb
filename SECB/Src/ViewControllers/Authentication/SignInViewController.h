//
//  SignInViewController.h
//  SECB
//
//  Created by Peter Mosaad on 9/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCircularProgressBarView.h"

#import "SignInOperation.h"

@interface SignInViewController : SuperViewController <BaseOperationDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITextField *userNameTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UIButton *signInButton;
    __weak IBOutlet UIButton *forgetPasswordButton;    
    __weak IBOutlet LocalizableIconWithView *textFieldsContainerView;
}

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)forgetPasswordButtonPressed:(id)sender;
- (IBAction)signupButtonPressed:(id)sender;
@end
