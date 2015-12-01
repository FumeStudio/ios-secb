//
//  SuperViewController.h
//  Probooking
//
//  Created by Peter Mosaad on 1/12/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "FiltersView.h"

@interface SuperViewController : UIViewController <UIGestureRecognizerDelegate>
{
    BOOL viewAppearedBefor;
    
    __weak IBOutlet UIImageView* headerBgImgView;
    __weak IBOutlet UIImageView* bgImgView;
    
    __weak IBOutlet UIButton* menuButton;
    __weak IBOutlet UIButton* backButton;
    
    /// User for Menu Presentaion.
    __weak IBOutlet UIView *viewContrainer;
    
    __weak IBOutlet UILabel* headerTitleLabel;
    
    FiltersView* filterView;
    BOOL filterViewIsPresented;
    UIPopoverController* filtersPopover;
}

@property MenuAction currentSelectedMenuItem;

- (void)setFiltersView:(FiltersView*)filterV;

@property (strong) UINavigationController* iPadCustomNavigationController;

- (id)initWithDefaultNibFile;

- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

- (void)setMenuHidden:(BOOL)hidden;

- (void)performMenueAction:(MenuAction)action;

- (void)refreshLocalization;

- (IBAction)filtersButtonPressed:(UIButton*)sender;
- (void)setFilterViewHidden:(BOOL)hidden;

@end