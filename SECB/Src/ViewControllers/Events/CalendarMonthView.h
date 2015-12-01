//
//  CalendarView.h
//  SECB
//
//  Created by Peter Mosaad on 10/03/15.
//
//

#import <UIKit/UIKit.h>

@protocol CalendarViewDelegate <NSObject>

- (void)refreshTableWithEventsList:(NSMutableArray*)eventsList;
- (void)didDisplayMonth:(int)month year:(int)year;

@end

@interface CalendarMonthView : UIView
{
    IBOutletCollection(UILabel) NSArray *weekDayLabels;
    __weak IBOutlet UIView *dayLabelsContainerView;
    __weak IBOutlet UIButton *currentMonthLabel;
    __weak IBOutlet UIButton *nextMonthTitleButton;
    __weak IBOutlet UIButton *previousMonthTitleButton;
    
    NSMutableArray* eventsList;
}

@property(weak) id<CalendarViewDelegate> delegate;

- (instancetype)initWithEventsList:(NSMutableArray*)events;
- (void)updateWithEventsList:(NSMutableArray*)events;

- (IBAction)previousMonthButtonPressed:(id)sender;
- (IBAction)nextMonthButtonPressed:(id)sender;

@end
