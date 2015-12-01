//
//  EguideLocationDetailsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EguideLocationDetailsViewController.h"
#import "ElocationRoomCard.h"
#import <MessageUI/MessageUI.h>

#define FirstLocationCardOriginY (isIPhone)? 302 : 532

@interface EguideLocationDetailsViewController ()

@end

@implementation EguideLocationDetailsViewController

- (id)initWithLocation:(ELocation*)location
{
    self = [super initWithDefaultNibFile];
    currentLocation = location;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setLocationAttributesInView];
    [self getLocationDetails];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Location Details", );
    
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
    UIFont* titleFont = [UIFont fontWithName:@"HelveticaNeue" size:(isIPhone)?12.5 : 15];
    UIFont* valueFont = [UIFont fontWithName:@"HelveticaNeue" size:(isIPhone)?11 : 15];
    NSMutableAttributedString* titleStr = [[NSMutableAttributedString alloc] initWithString:title
                                                                                 attributes:@{NSFontAttributeName : titleFont, NSForegroundColorAttributeName : titleColor}];

    NSAttributedString* valueStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@", value]
                                                                   attributes:@{NSFontAttributeName : valueFont, NSForegroundColorAttributeName : valueColor}];
    [titleStr appendAttributedString:valueStr];
    
    return titleStr;
}

- (void)setLocationAttributesInView
{
    [locationImageView setImageWithImageUrl:currentLocation.image andPlaceHolderImage:nil];
    nameLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Name", ) value:currentLocation.name];
    typeLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Type", ) value:currentLocation.type];
    descriptionLabel.text = currentLocation.locationDescription;
    capacityLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Capacity", ) value:currentLocation.capacity];
    spaceLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Space", ) value:[NSString stringWithFormat:@"%@m",currentLocation.area]];
    addressLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Address", ) value:currentLocation.address];
    phoneNumberLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Phone Number", ) value:currentLocation.phone];
    emailLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"E-mail", ) value:currentLocation.email];
    websiteLabel.attributedText = [self attributedStringForTitle:LocalizedString(@"Website", ) value:currentLocation.webSite];
    
    float originY = FirstLocationCardOriginY;
    for(LocationRoom* aRoom in currentLocation.locationRooms)
    {
        ElocationRoomCard* roomCard = [ElocationRoomCard cardForRoom:aRoom];
        CGRect frame = roomCard.frame;
        frame.origin.y = originY;
        frame.origin.x = (isIPhone)? 5 : 47;
        roomCard.frame = frame;
        float padding = (isIPhone)? 5 : 15;
        originY = frame.origin.y + frame.size.height + padding;
        [contentScrollView addSubview:roomCard];
    }
    
    CGRect frame = locationContactInfoView.frame;
    frame.origin.y = originY;
    locationContactInfoView.frame = frame;
    
    contentScrollView.contentSize = CGSizeMake(0, frame.origin.y + frame.size.height + 5);
}

- (void)getLocationDetails
{
    [GetELocationsOperation addObserver:self];
    [viewContrainer showProgressWithMessage:@""];
    [BaseOperation queueInOperation:[[GetELocationsOperation alloc] initToGetDetailsOfLocation:currentLocation]];
}

#pragma mark - Actoins

- (IBAction)callNumber:(id)sender
{
    if(!currentLocation.phone)
        return;
    if(!isIPhone)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",currentLocation.phone]]];
}

- (IBAction)openWebSitePressed:(id)sender
{
    NSString* url = currentLocation.webSite;
    if([url rangeOfString:@"http://"].location == NSNotFound)
        url = [NSString stringWithFormat:@"http://%@",url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (IBAction)sendEmail:(id)sender
{
    if(!currentLocation.email)
        return;
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = (id<MFMailComposeViewControllerDelegate>) self;
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:currentLocation.email]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - BaseOperationDelegate

- (void)operation:(BaseOperation*)operation succededWithObject:(id)object
{
    [[BaseOperation class] removeObserver:self];
    [viewContrainer hideProgress];
    [self setLocationAttributesInView];
}

- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    [[BaseOperation class] removeObserver:self];
    [viewContrainer hideProgress];
    [error show];
}

@end
