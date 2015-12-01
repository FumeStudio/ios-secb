//
//  GallariesViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/2/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "GallariesViewController.h"
#import "MediaBox.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "GetMediaGalleyContentOperation.h"

#import <XCDYouTubeKit/XCDYouTubeKit.h>

#import "MPMoviePlayerController+BackgroundPlayback.h"



@interface GallariesViewController ()
{
    int currentPageIndex;
}
@end

@implementation GallariesViewController

- (id)initWithMediaGallery:(MediaGallery*)gallery
{
    self = [GallariesViewController new];
    screenMode = ScreenModeAlbumDetails;
    currentMediaGallery = gallery;
    currentMediaType = gallery.mediaType;
    return self;
}

- (id)initWithMediaType:(MediaType)mediaType
{
    self = [GallariesViewController new];
    screenMode = ScreenModeAlbumsList;
    currentMediaType = mediaType;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    switch (screenMode) {
        case ScreenModeAlbumsList:
        {
            headerTitleLabel.text = (currentMediaType == MediaTypeImages)? LocalizedString(@"Images Gallery",) : LocalizedString(@"Video Gallery",);
            break;
        }
        case ScreenModeAlbumDetails:
        {
            headerTitleLabel.text = (currentMediaType == MediaTypeImages)? LocalizedString(@"Image Album",) : LocalizedString(@"Video Album",);
            break;
        }
        default:
            break;
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    galleriesScrollView.bottomRefreshControl = refreshControl;
    
    ///
    [self getMediaGalleries];
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Images Gallery", );
    
    [super refreshLocalization];
    
}

- (void)testRefresh:(UIRefreshControl *)refreshControl
{
    currentPageIndex ++;
    [self getMediaGalleries];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if(!viewAppearedBefor)
    {
        [self addGalleries];
        
        menuButton.hidden = screenMode == ScreenModeAlbumDetails;
        backButton.hidden = screenMode != ScreenModeAlbumDetails;
    }
    [super viewWillAppear:animated];
}

#pragma mark -

- (void)getMediaGalleries
{
    [galleriesScrollView showProgressWithMessage:@""];
    
    if(currentMediaGallery)
    {
        [GetMediaGalleyContentOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetMediaGalleyContentOperation alloc] initWithMediaGallery:currentMediaGallery pageIndex:currentPageIndex]];
    }
    else
    {
        [GetMediaGalleriesOperation addObserver:self];
        [BaseOperation queueInOperation:[[GetMediaGalleriesOperation alloc] initForMediaType:currentMediaType pageIndex:currentPageIndex]];
    }
}

- (void)addGalleries
{
    /// Remove old views
    for(UIView* view in galleriesScrollView.subviews)
        if([view isKindOfClass:[MediaBox class]])
            [view removeFromSuperview];
    
    //
    NSInteger count = dataSource.count;
    
    CGFloat original_X_Origin = (isIPhone)? 5 : 48;
    CGFloat original_Y_Origin = (isIPhone)? 5 : 15;
    
    CGFloat xOrigin, yOrigin;

    CGRect frame;
    for(int i = 0; i < count; i++)
    {
        MediaBox* box;

        box = [MediaBox boxForMediaItem:[dataSource objectAtIndex:i]];
        
        box.delegate = self;
        [box updateView];
        
        frame = box.frame;
        
        if(isIPhone)
        {
            xOrigin = (i%2 == 0)? 5 : frame.origin.x + frame.size.width + 10;
            yOrigin = (i%2 == 0 && i>1)? frame.origin.y + frame.size.height + 10 : original_Y_Origin;
        }
        else
        {
            frame.size = CGSizeMake(190, 159);
            xOrigin = original_X_Origin;
            xOrigin += (i%3) * frame.size.width;
            if(i%3)
                xOrigin += (i%3)*10;
            
            yOrigin = original_Y_Origin;
            yOrigin += (i/3)*frame.size.height;
            if(i>2)
                yOrigin += (i/3)*10;
                
        }
        
        frame.origin = CGPointMake(xOrigin, yOrigin);
        box.frame = frame;
        [galleriesScrollView addSubview:box];
    }
    galleriesScrollView.contentSize = CGSizeMake(0, frame.origin.y + frame.size.height+5);
}

#pragma mark - MediaBoxDelegate

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
    MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (finishReason == MPMovieFinishReasonPlaybackError)
    {
        NSString *title = NSLocalizedString(@"Video Playback Error", @"Full screen video error alert - title");
        NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
        NSString *message = [NSString stringWithFormat:@"%@\n%@ (%@)", error.localizedDescription, error.domain, @(error.code)];
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Full screen video error alert - cancel button");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alertView show];
    }
    
    NSNumber *value = [NSNumber numberWithInt:(isIPhone)? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)didSelectMediaBox:(MediaBox *)box
{
    MediaGallery* currentMediaItem = box.currentGallery;
    if(currentMediaItem.isFolder)
    {
        [self.navigationController pushViewController:[[GallariesViewController alloc] initWithMediaGallery:currentMediaItem] animated:YES];
    }
    else
    {
        if(currentMediaItem.mediaType == MediaTypeVideos)
        {
            NSString* videoID = currentMediaItem.youTubeVideoID;
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
            videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"PlayVideoInBackground"];
            videoPlayerViewController.preferredVideoQualities = @[ @(XCDYouTubeVideoQualitySmall240), @(XCDYouTubeVideoQualityMedium360) ];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
            [((UIWindow*)([UIApplication sharedApplication].windows.firstObject)).rootViewController presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        }
        else
        {
            // Create browser
            if(!currentMediaGallery || !currentMediaGallery.contents.count)
                currentMediaGallery = currentMediaItem;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = NO;
            browser.displayNavArrows = NO;
            browser.displaySelectionButtons = NO;
            browser.alwaysShowControls = YES;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = NO;
            browser.startOnGrid = NO;
            browser.enableSwipeToDismiss = NO;
            browser.autoPlayOnAppear = NO;
            if(currentMediaGallery.contents.count)
                [browser setCurrentPhotoIndex:[currentMediaGallery.contents indexOfObject:currentMediaItem]];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [((UIWindow*)([UIApplication sharedApplication].windows.firstObject)).rootViewController presentViewController:nc animated:YES completion:nil];
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    NSUInteger count = (currentMediaGallery.contents.count)? currentMediaGallery.contents.count : 1;
    return count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < currentMediaGallery.contents.count)
    {
        MediaGallery* gallery = [currentMediaGallery.contents objectAtIndex:index];
        return [MWPhoto photoWithURL:[NSURL URLWithString:gallery.galleryImgUrl]];
    }
    else
    {
        MWPhoto* photo = [MWPhoto photoWithURL:[NSURL URLWithString:currentMediaGallery.galleryImgUrl]];;
        return photo;
    }
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    return nil;
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [photoBrowser.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BaseOperationDelegate

- (void)operation:(GetMediaGalleriesOperation*)operation succededWithObject:(id)object
{
    if([operation isKindOfClass:[GetMediaGalleriesOperation class]])
    {
        if(operation.pageIndex)
            [dataSource addObjectsFromArray:object];
        else
            dataSource = [NSMutableArray arrayWithArray:object];
    }
    else if([operation isKindOfClass:[GetMediaGalleyContentOperation class]])
    {
        dataSource = [NSMutableArray arrayWithArray:currentMediaGallery.contents];
    }
    [galleriesScrollView.bottomRefreshControl endRefreshing];
    [self addGalleries];
    
    [[operation class] removeObserver:self];
    [galleriesScrollView hideProgress];
}

- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    [[operation class] removeObserver:self];
    [galleriesScrollView hideProgress];
    [error show];
}

@end
