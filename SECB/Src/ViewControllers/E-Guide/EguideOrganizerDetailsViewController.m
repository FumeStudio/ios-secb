//
//  EguideOrganizerDetailsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EguideOrganizerDetailsViewController.h"
#import "OrganizerEguideViewController.h"
#import <MessageUI/MessageUI.h>

@interface EguideOrganizerDetailsViewController ()

@end

@implementation EguideOrganizerDetailsViewController

- (id)initWithOrganizer:(EOrganizer*)organizer
{
    self = [super initWithDefaultNibFile];
    currentOrganizer = organizer;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setLocationAttributesInView];
    
    if(!isIPhone)
        [contentScrollView setContentSize:CGSizeMake(0, 775)];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Organizer Details", );
    
    [super refreshLocalization];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString*)attributedStringForTitle:(NSString*)title value:(NSString*)value
{
    UIColor* titleColor = [UIColor colorWithRed:18.0f/255.0f green:45.0f/255.0f blue:83.0f/255.0f alpha:1.0];
    UIColor* valueColor = [UIColor colorWithRed:106.0f/255.0f green:106.0f/255.0f blue:106.0f/255.0f alpha:1.0];
    UIFont* titleFont = [UIFont fontWithName:@"HelveticaNeue" size:12.5];
    UIFont* valueFont = [UIFont fontWithName:@"HelveticaNeue" size:11];
    NSMutableAttributedString* titleStr = [[NSMutableAttributedString alloc] initWithString:title
                                                                                 attributes:@{NSFontAttributeName : titleFont, NSForegroundColorAttributeName : titleColor}];

    NSAttributedString* valueStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@", value]
                                                                   attributes:@{NSFontAttributeName : valueFont, NSForegroundColorAttributeName : valueColor}];
    [titleStr appendAttributedString:valueStr];
    
    return titleStr;
}

- (void)setLocationAttributesInView
{
    [organizerImageView setImageWithImageUrl:currentOrganizer.image andPlaceHolderImage:nil];
    nameLabel.text = currentOrganizer.name;
    descriptionLabel.text = currentOrganizer.organizerDescription;
    addressLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Address", ) value:currentOrganizer.address];
    phoneNumberLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Phone Number", ) value:currentOrganizer.phone];
    emailLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"E-mail", ) value:currentOrganizer.email];
    websiteLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Website", ) value:currentOrganizer.webAddress];
}

#pragma mark - Actoins

- (IBAction)callNumber:(id)sender
{
    if(!currentOrganizer.phone)
        return;
    if(!isIPhone)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",currentOrganizer.phone]]];
}

- (IBAction)sendEmail:(id)sender
{
    if(!currentOrganizer.email)
        return;
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>) self;
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:currentOrganizer.email]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
