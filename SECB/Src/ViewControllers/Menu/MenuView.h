//
//  MenuView.h
//  SECB
//
//  Created by Peter Mosaad on 9/29/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SuperViewController;

typedef enum MenuAction
{
    MenuActionHome,
    MenuActionEservice,
    MenuActionNews,
    MenuActionEguide,
    MenuActionEvents,
    MenuActionImages,
    MenuActionVideos,
    MenuActionAboutUs,
    MenuActionContactUs,
    MenuActionLanguage,
    MenuActionSignout
}MenuAction;

@interface MenuViewEntry : UIView

@property (strong, nonatomic) IBOutlet UIImageView *entryIcon;
@property (strong, nonatomic) IBOutlet UILabel *entryLabel;

@end

@interface MenuView : UIScrollView
{
    __weak IBOutlet UILabel *homeLabel;
    __weak IBOutlet UILabel *esrviceLabel;
    __weak IBOutlet UILabel *newsLabel;
    __weak IBOutlet UILabel *eguideLabel;
    __weak IBOutlet UILabel *eventsLabel;
    __weak IBOutlet UILabel *imagesLabel;
    __weak IBOutlet UILabel *videosLabel;
    __weak IBOutlet UILabel *aboutUsLabel;
    __weak IBOutlet UILabel *contactUsLabel;
    __weak IBOutlet UILabel *languageLabel;
    __weak IBOutlet UILabel *signOutLabel;
    IBOutletCollection(MenuViewEntry) NSArray *menuEntryViews;
}

@property (assign) SuperViewController* presentingViewController;

- (IBAction)menuItemButtonPressed:(id)sender;

- (void)refreshLocalization;

- (void)setSelectedMenuItem:(MenuAction)selected;

@end
