//
//  SignUpViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/13/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : SuperViewController <UIWebViewDelegate>
{
    __weak IBOutlet UIWebView *signupWebView;
}
@end
