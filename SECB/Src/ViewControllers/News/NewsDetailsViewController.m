//
//  NewsDetailsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/4/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "NewsDetailsViewController.h"

@interface NewsDetailsViewController ()

@end

@implementation NewsDetailsViewController

- (id)initWithNews:(News*)news
{
    self = [super initWithDefaultNibFile];
    
    currentNews = news;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self updateView];
    
    [self getNewsDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"News Details", );
    
    [super refreshLocalization];
    
}


- (void)updateView
{
    newsTitleLabel.text = currentNews.title;
    if(IsCurrentLangaugeArabic)
        newsTitleLabel.textAlignment = NSTextAlignmentRight;
    newsTextLabel.attributedText = [[NSAttributedString alloc] initWithData:[currentNews.newsBody dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                               documentAttributes:nil error:nil];
    CGFloat width = newsTextLabel.frame.size.width;
    [newsTextLabel sizeToFit];
    CGRect afrme = newsTextLabel.frame;
    afrme.size.width = width;
    newsTextLabel.frame = afrme;

    
    if(IsCurrentLangaugeArabic)
        newsTextLabel.textAlignment = NSTextAlignmentRight;
    
    newsDateLabel.text = [currentNews.creationDate toStringWithFormat:@"dd MMM yyyy"];
    if(IsCurrentLangaugeArabic)
        newsDateLabel.textAlignment = NSTextAlignmentRight;

    [newsImageView setImageWithImageUrl:currentNews.imageUrl andPlaceHolderImage:nil];
    contentScrollView.contentSize = CGSizeMake(0, newsTextLabel.frame.origin.y + newsTextLabel.frame.size.height + 5);
}

- (void)getNewsDetails
{
    [GetNewsOperation addObserver:self];
    [viewContrainer showProgressWithMessage:@""];
    GetNewsOperation* op = [[GetNewsOperation alloc] initWithToGetDetailsOfNews:currentNews];
    [BaseOperation queueInOperation:op];
}

- (IBAction)shareButtonPressed:(UIButton*)sender
{
    NSString *textToShare = [NSString stringWithFormat:@"%@\n%@", currentNews.title, currentNews.newsBrief];
    UIImage *imageToShare = newsImageView.image;
    NSArray *itemsToShare = @[textToShare, imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypeAirDrop];
    
    if ( [activityVC respondsToSelector:@selector(popoverPresentationController)] ) {
        // iOS8
        activityVC.popoverPresentationController.sourceView = sender;
    }
  
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - BaseOperationDelegate
- (void)operation:(BaseOperation*)operation succededWithObject:(id)object
{
    [self updateView];
    [[operation class] removeObserver:self];
    [viewContrainer hideProgress];
}
- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    [[operation class] removeObserver:self];
    [viewContrainer hideProgress];
    [error show];
}

@end
