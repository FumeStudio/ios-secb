//
//  ForgetPasswordViewController.h
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgetPasswordOperation.h"

@interface ForgetPasswordViewController : SuperViewController <BaseOperationDelegate>
{
    __weak IBOutlet UIButton *resetPasswordButton;
    __weak IBOutlet UITextField *emailTextField;
}
- (IBAction)resetPasswordButtonPressed:(id)sender;
@end
