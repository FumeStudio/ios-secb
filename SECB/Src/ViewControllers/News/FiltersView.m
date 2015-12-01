//
//  FiltersView.m
//  SECB
//
//  Created by Peter Mosaad on 10/6/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "FiltersView.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetPicker.h"

@interface FiltersView ()
{
    NSDate* dateToBeSet;
}
@end

@implementation FiltersView


- (id)init
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"FiltersView" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    
    return self;
}

- (void)didMoveToSuperview
{
    if(isIPhone)
        [self setTableViewFrame];
    
    [applyFiltersButton setTitle:LocalizedString(@"Apply Filters", ) forState:UIControlStateNormal];
    
    // set header label text
    if([self.delegate respondsToSelector:@selector(filtersViewHeaderTitle)])
        headersTitleLabel.text = [self.delegate filtersViewHeaderTitle];
    
    NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:LocalizedString(@"Reset Filters",)];
    [temString addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:1]
                      range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSFontAttributeName value:resetFiltersButton.titleLabel.font range:(NSRange){0,[temString length]}];
    [temString addAttribute:NSForegroundColorAttributeName value:resetFiltersButton.titleLabel.textColor range:(NSRange){0,[temString length]}];
    [resetFiltersButton setAttributedTitle:temString forState:UIControlStateNormal];

}

- (void)setTableViewFrame
{
    CGFloat tableViewHeight = 0;
    for(int i = 0; i < [self numberOfSectionsInTableView:filtersTableView]; i++)
    {
        tableViewHeight += [self tableView:filtersTableView numberOfRowsInSection:i] * filtersTableView.rowHeight;
        tableViewHeight += [self tableView:filtersTableView heightForHeaderInSection:i];
    }
    CGRect frame = filtersTableView.frame;
    CGFloat maxHeight = self.superview.frame.size.height - 90 - frame.origin.y;
    frame.size.height = MIN(tableViewHeight, maxHeight);
    filtersTableView.bounces = tableViewHeight > maxHeight;
    filtersTableView.frame = frame;
    
    CGRect buttonFrame = applyFiltersButton.frame;
    buttonFrame.origin.y = frame.origin.y + frame.size.height + 10;
    applyFiltersButton.frame = buttonFrame;
    
    buttonFrame.origin.y += buttonFrame.size.height + 6;
    resetFiltersButton.frame = buttonFrame;
}

- (IBAction)applyFiltersButton:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didApplyFiltersPressed)])
        [self.delegate didApplyFiltersPressed];
}

- (IBAction)resetFilterButtonPressed:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didResetFiltersPressed)])
        [self.delegate didResetFiltersPressed];
}

- (void)refreshSelectedFilters
{
    [filtersTableView reloadData];
}

#pragma mark - TableViewMethods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.sectionHeaderHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate filtersTableView:filtersTableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.delegate filtersTable:filtersTableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.delegate numberOfSectionsInFiltersTable:filtersTableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.delegate filtersTable:tableView titleForHeaderInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate filtersTable:filtersTableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.delegate filtersTable:filtersTableView viewForHeaderInSection:section];
}

#pragma mark - 

- (void)showDataPickerWithTarget:(id)target withOptions:(NSMutableArray*)options initialSelectedIndex:(int)index
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([target respondsToSelector:@selector(didSelectItemAtIndex:)]) {
            [target performSelector:@selector(didSelectItemAtIndex:) withObject:[NSNumber numberWithInteger:selectedIndex]];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:options initialSelection:index doneBlock:done cancelBlock:cancel origin:self];
}

- (void)showDateWithTarget:(id)target selector:(SEL)selector
{
    
}

- (void)showDatePickerWithTarget:(id)target completionSelector:(SEL)selector OriginalDate:(NSDate*)date
{
    date = (date)? date : [NSDate date];
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:date target:target action:selector origin:self];
    [datePicker showActionSheetPicker];

//    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(timeWasSelected:element:) origin:self];
//    [datePicker showActionSheetPicker];

}

@end
