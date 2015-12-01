//
//  ContactUsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/24/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "ContactUsViewController.h"
#import <MessageUI/MessageUI.h>

#define ContentHeight (isIPhone)? 627 : 919
#define ESCBCoordinates CLLocationCoordinate2DMake(24.7044594, 46.6563127)

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


@end

@implementation MapAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return ESCBCoordinates;
}

@end

@interface ContactUsViewController ()
{
    CGSize keyBoardSize;
}
@end

@implementation ContactUsViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    contentScrollView.contentSize = CGSizeMake(0, ContentHeight);

    [mapView addAnnotation:[MapAnnotation new]];
    [mapView setRegion:MKCoordinateRegionMakeWithDistance(ESCBCoordinates, 500, 500)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Contact Us", );
    bookAppointmentTitleLabel.text = LocalizedString(@"Wish to book an appointment with SECB representatives?\nplease complete the form below:", );
    bookAppointmentTitleLabel.textAlignment = (IsCurrentLangaugeArabic)? NSTextAlignmentRight  :NSTextAlignmentLeft;
    
    nameTextField.placeholder = LocalizedString(@"Your Name", );
    mobileTextField.placeholder = LocalizedString(@"Mobile Number", );
    orgnizationTextField.placeholder = LocalizedString(@"Organization", );
    emailTextField.placeholder = LocalizedString(@"Email Address", );
    jobTitleTextField.placeholder = LocalizedString(@"Job Title", );
    subjectTextField.placeholder = LocalizedString(@"Subject", );
    [sendButton setTitle:LocalizedString(@"Send", ) forState:UIControlStateNormal];
    
    [super refreshLocalization];
    
}


#pragma mark - MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    [view setImage:[UIImage imageNamed:@"contactUsMapPin"]];
    view.canShowCallout = NO;
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)sendButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    NSArray* textFields = [NSArray arrayWithObjects:nameTextField, mobileTextField,
                           orgnizationTextField,
                           emailTextField,
                           jobTitleTextField,
                           subjectTextField, nil];
    for(UITextField* textField in textFields)
        if(!textField.text.length)
        {
            [LocalizedString(@"All form fields are mandatory", ) show];
            return;
        }
    
    [SendContactUsFormOperation addObserver:self];
    [formView showProgressWithMessage:@""];
    
    ContactUsForm* form = [ContactUsForm new];
    form.username = nameTextField.text;
    form.phone = mobileTextField.text;
    form.email = emailTextField.text;
    form.organization = orgnizationTextField.text;
    form.jobTitle = jobTitleTextField.text;
    form.subject = subjectTextField.text;
    [BaseOperation queueInOperation:[[SendContactUsFormOperation alloc] initWithFormData:form]];
}

- (IBAction)sendEmailButtonPressed:(id)sender
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>) self;
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"info@ssecb.gov.sa"]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:nameTextField])
        [mobileTextField becomeFirstResponder];
    else if([textField isEqual:mobileTextField])
        [orgnizationTextField becomeFirstResponder];
    else if([textField isEqual:orgnizationTextField])
        [emailTextField becomeFirstResponder];
    else if([textField isEqual:emailTextField])
        [jobTitleTextField becomeFirstResponder];
    else if([textField isEqual:jobTitleTextField])
        [subjectTextField becomeFirstResponder];
    else if([textField isEqual:subjectTextField])
        [self sendButtonPressed:nil];

    return YES;
}

- (void)keyboardWillChange:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize contentSize = CGSizeMake(0, ContentHeight);
    
    if((keyboardFrame.origin.y < self.view.frame.size.height))
        contentSize.height += keyboardFrame.size.height;
    contentScrollView.contentSize = contentSize;
    
    float offset = (contentSize.height > ContentHeight)? (isIPhone)? 327 : 520 :0;
    [contentScrollView setContentOffset:CGPointMake(0, offset) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - BaseOperationDelegate
- (void)operation:(BaseOperation*)operation succededWithObject:(id)object
{
    [[operation class] removeObserver:self];
    [formView hideProgress];
    [LocalizedString(@"Your message have been sent successfully", ) show];
    nameTextField.text = @"";
    mobileTextField.text = @"";
    orgnizationTextField.text = @"";
    emailTextField.text = @"";
    jobTitleTextField.text = @"";
    subjectTextField.text = @"";
}
- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info;
{
    [[operation class] removeObserver:self];
    [formView hideProgress];
    [error show];
}


- (IBAction)mapViewTapped:(id)sender
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = ESCBCoordinates;
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"SECB"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
    
}


@end
