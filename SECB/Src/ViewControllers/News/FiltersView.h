//
//  FiltersView.h
//  SECB
//
//  Created by Peter Mosaad on 10/6/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate <NSObject>
- (void)didApplyFiltersPressed;
- (void)didResetFiltersPressed;
- (NSInteger)filtersTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)filtersTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInFiltersTable:(UITableView *)tableView;
- (NSString *)filtersTable:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (void)filtersTable:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)filtersTable:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (NSString*)filtersViewHeaderTitle;

@optional
- (void)didSelectItemAtIndex:(NSNumber*)index;

@end

@interface FiltersView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UILabel *headersTitleLabel;
    __weak IBOutlet UITableView *filtersTableView;
    __weak IBOutlet UIButton *applyFiltersButton;
    __weak IBOutlet UIButton *resetFiltersButton;
    
    id currentFilterObject;
}

@property (weak) id<FilterViewDelegate> delegate;

- (IBAction)applyFiltersButton:(id)sender;
- (IBAction)resetFilterButtonPressed:(id)sender;

- (void)setTableViewFrame;

- (void)refreshSelectedFilters;

- (void)showDatePickerWithTarget:(id)target completionSelector:(SEL)selector OriginalDate:(NSDate*)date;

- (void)showDataPickerWithTarget:(id)target withOptions:(NSMutableArray*)options initialSelectedIndex:(int)index;

@end
