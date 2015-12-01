//
//  ContactUsViewController.h
//  SECB
//
//  Created by Peter Mosaad on 10/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SuperViewController.h"
#import "SendContactUsFormOperation.h"

@interface ContactUsViewController : SuperViewController <UITextFieldDelegate, BaseOperationDelegate, UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *contentScrollView;
    
    __weak IBOutlet UILabel *bookAppointmentTitleLabel;
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIView *formView;
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UITextField *mobileTextField;
    __weak IBOutlet UITextField *orgnizationTextField;
    __weak IBOutlet UITextField *emailTextField;
    __weak IBOutlet UITextField *jobTitleTextField;
    __weak IBOutlet UITextField *subjectTextField;
    
    __weak IBOutlet UIButton *sendButton;
}
- (IBAction)sendButtonPressed:(id)sender;
- (IBAction)sendEmailButtonPressed:(id)sender;
@end
