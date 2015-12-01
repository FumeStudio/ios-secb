//
//  CalendarView.m
//  SECB
//
//  Created by Peter Mosaad on 10/03/15.
//
//

#import "CalendarMonthView.h"
#import "CustomTapGestureRecognizer.h"
#import "Event.h"

@interface CalendarMonthView()
{
    int currentMonth;
    int currentYear;
    
    UISwipeGestureRecognizer* leftGesture;
    UISwipeGestureRecognizer* rightGesture;
}
@end

@implementation CalendarMonthView

- (void)updateWithEventsList:(NSMutableArray*)events
{
    eventsList = [NSMutableArray arrayWithArray:events];
    UIView* daysLabelView = [self addDayLabelsForMonth:currentMonth year:currentYear];
    [self addSubview:daysLabelView];
    [self sendSubviewToBack:daysLabelView];
    [dayLabelsContainerView removeFromSuperview];
    dayLabelsContainerView = nil;
    dayLabelsContainerView = daysLabelView;
}

- (IBAction)previousMonthButtonPressed:(id)sender {
    [self swipe:rightGesture];
}

- (IBAction)nextMonthButtonPressed:(id)sender {
    [self swipe:leftGesture];
}

- (instancetype)initWithEventsList:(NSMutableArray*)events
{
    //// Initialize the View from the related XIB file
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CalendarMonthView" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    
    //// Add Swipe Gesture to move between months next/previous
    leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftGesture];
    rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightGesture];
    
    currentMonth = (int)[[NSDate date] month];
    currentYear = (int)[[NSDate date] year];
    
    //// Update the view with the selected service
    [self updateWithEventsList:events];
    
    return self;
}

- (void)swipe:(UISwipeGestureRecognizer*)sender
{
    /// Move between months next/previous according to swipe direction
    if(sender.direction == UISwipeGestureRecognizerDirectionRight)
        currentMonth--;
    else
        currentMonth++;
    if(currentMonth > 12)
    {
        currentMonth = 1;
        currentYear++;
    }
    else if(currentMonth < 1)
    {
        currentMonth = 12;
        currentYear--;
    }
    
    /// Update the view with the current month
    UIView* daysLabelView = [self addDayLabelsForMonth:currentMonth year:currentYear];
    CGRect frame = daysLabelView.frame;
    frame.origin.x = (sender.direction == UISwipeGestureRecognizerDirectionRight)? -1*frame.size.width : frame.size.width;
    //frame.origin.x = (sender.direction == UISwipeGestureRecognizerDirectionLeft)? dayLabelsContainerView.frame.origin.y - frame.size.height : dayLabelsContainerView.frame.origin.y + dayLabelsContainerView.frame.size.height;
    daysLabelView.frame = frame;
    daysLabelView.alpha = 0;
    [self addSubview:daysLabelView];
    [self sendSubviewToBack:daysLabelView];
    
    daysLabelView.alpha = 1.0;
    frame.origin.x = dayLabelsContainerView.frame.origin.x;
    
    CGRect frame2 = dayLabelsContainerView.frame;
    frame2.origin.x = (sender.direction == UISwipeGestureRecognizerDirectionRight)? self.frame.size.width : -1*frame2.size.width;
    
    [UIView animateWithDuration:0.5 animations:^(void){
        daysLabelView.frame = frame;
        dayLabelsContainerView.frame = frame2;
    } completion:^(BOOL done){
        if(done)
        {
            [dayLabelsContainerView removeFromSuperview];
            dayLabelsContainerView = nil;
            dayLabelsContainerView = daysLabelView;
            dayLabelsContainerView.frame = frame;
            
            ///
            if(self.delegate && [self.delegate respondsToSelector:@selector(didDisplayMonth:year:)])
                [self.delegate didDisplayMonth:currentMonth year:currentYear];
        }
    }];
}

- (void)dayPressed:(CustomTapGestureRecognizer*)sender
{
    /// Delegate user action to the view controller to update the view with the selected date
    if(self.delegate && [self.delegate respondsToSelector:@selector(refreshTableWithEventsList:)])
        [self.delegate refreshTableWithEventsList:[self eventsForDate:sender.attribute]];
}

- (void)didMoveToSuperview
{
    dayLabelsContainerView.frame = CGRectMake(0, dayLabelsContainerView.frame.origin.y, self.frame.size.width, self.frame.size.height - dayLabelsContainerView.frame.origin.y);
}

- (void)calendarTimeSlotsUpdated
{
    /// Update the view with the current month
    UIView* daysLabelView = [self addDayLabelsForMonth:currentMonth year:currentYear];
    CGRect frame = daysLabelView.frame;;
    frame.origin.y = 66;
    daysLabelView.frame = frame;
    [dayLabelsContainerView.superview addSubview:daysLabelView];
    [dayLabelsContainerView removeFromSuperview];
    dayLabelsContainerView = nil;
    [self sendSubviewToBack:daysLabelView];
    dayLabelsContainerView = daysLabelView;
}

- (NSMutableArray*)eventsForDate:(NSDate*)date
{
    NSMutableArray* events = [NSMutableArray array];
    for(Event* event in eventsList)
        if([event.eventDate isEqualToDateIgnoringTime:date])
            [events addObject:event];
    return events;
}

- (UIView*)addDayLabelsForMonth:(int)month year:(int)year
{
    currentMonth = month;
    currentYear = year;
    
//    NSDate* date = [NSDate dateWithDay:30 month:currentMonth year:currentYear];
//    if([date isLaterThanDate:currentServiceCalendar.loadedTo])
//        [self performSelector:@selector(loadMoreTimeSlotsOfCalendar) withObject:nil afterDelay:0.5];
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, dayLabelsContainerView.frame.origin.y, self.frame.size.width, self.frame.size.height - dayLabelsContainerView.frame.origin.y)];
    container.clipsToBounds = YES;
    
    float maxYOrigin = 0;
    
    CGSize dayLabelSize =  (isIPhone)? CGSizeMake(32, 30) : CGSizeMake(34, 32);
    
    for(int j = 0; j < 1; j++)
    {
        /// Create a calender to be used for date calculations
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        /// Default calendar first day is satrday but I override that to match the Calendar PSD
        [calendar setFirstWeekday:2];
        /// Get The first date of the Month
        NSDateComponents* com = [[NSDateComponents alloc] init];
        [com setDay:1];
        [com setMonth:month + j];
        [com setYear:year];
        NSDate* firstOfTheMonth = [calendar dateFromComponents:com];
//        [currentMonthLabel setTitle:[firstOfTheMonth toStringWithFormat:@"MMMM yyyy"] forState:UIControlStateNormal];
        [self updateTopMonthsTitles];

        /// Get the number of the days of current month
        NSUInteger numberOfDaysInMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstOfTheMonth].length;
        /// Add the days of the month on the grid view
        BOOL monthStartsWithSunday = false;
        for(int i = 1; i <= numberOfDaysInMonth; i++)
        {
            /// Create a date object with the day month and year
            NSDateComponents* com = [[NSDateComponents alloc] init];
            [com setDay:i];
            [com setMonth:month + j];
            [com setYear:year];
            NSDate* currentDay = [calendar dateFromComponents:com];
            
            //// Get the Week and weekday inorder to place it in it's correct index
            NSCalendarUnit unitFlags =  NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit;
            NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:currentDay];
            NSInteger weekDay = [dateComponents weekday];
            NSInteger weekDayIndex = weekDay;
            NSInteger weekIndex = [dateComponents weekOfMonth];
            if(i==1)
            {
                if(weekDay == 1)
                    monthStartsWithSunday = YES;
                else
                    monthStartsWithSunday = false;
            }

            if(weekDay == 1)
                weekIndex ++;
            
            if(monthStartsWithSunday)
                weekIndex --;
            
            /// Index of the day label
            UILabel* guideLabelForCoordinates = (UILabel*)[weekDayLabels objectAtIndex:weekDayIndex-1];
            long xOrigin = guideLabelForCoordinates.frame.origin.x;
            if(isIPhone)
                xOrigin += 2;
            else
                xOrigin += (guideLabelForCoordinates.frame.size.width - dayLabelSize.width)/2.0;
            long yOrigin = (weekIndex*9) + (weekIndex-1)*dayLabelSize.height;
            if(j == 0)
                maxYOrigin = MAX(yOrigin, maxYOrigin);
            else
            {
                yOrigin += maxYOrigin + dayLabelSize.height;
            }
            
            /// Day number label
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, dayLabelSize.width, dayLabelSize.height)];
            label.userInteractionEnabled = true;
            label.text = [NSString stringWithFormat:@"%d", i];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [((UILabel*)([weekDayLabels objectAtIndex:weekDayIndex-1])).font fontWithSize:(isIPhone)?12:15];
            
            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            label.textColor = [UIColor whiteColor];
            [container addSubview:label];
            

            //// Add a gesture recognizer to handle the touches on the Day
            CustomTapGestureRecognizer* gesture = [[CustomTapGestureRecognizer alloc] initWithTarget:self action:@selector(dayPressed:)];
            gesture.attribute = currentDay;
            [label addGestureRecognizer:gesture];
            
            /// Check if the day contains an appointment booked by the user to add an orange line unde it.
            if([self eventsForDate:currentDay].count)/// if day contain events
            {
//                UIView* view = [[UIView alloc] initWithFrame:CGRectMake(label.frame.size.width/4.0, label.frame.size.height-2, label.frame.size.width/2.0, 2)];
//                view.backgroundColor = OrangeColor;
//                [label addSubview:view];
                label.layer.borderColor = [UIColor colorWithRed:229.0/255.0 green:149.0/255.0 blue:47.0/255.0 alpha:1.0].CGColor;
                label.layer.borderWidth = 1.0;
            }
            
            /// Mark today
            if([currentDay isToday])
            {
//                label.backgroundColor = [UIColor colorWithRed:140.0/255.0 green:150.0/255.0 blue:160.0/255.0 alpha:0.8];
//                label.textColor = [UIColor whiteColor];
//                label.layer.cornerRadius = label.frame.size.width/2.0;
//                label.clipsToBounds = YES;
                label.layer.borderColor = [UIColor colorWithRed:81.0/255.0 green:196.0/255.0 blue:212.0/255.0 alpha:1.0].CGColor;
                label.layer.borderWidth = 1.0;

            }
        }
    }
    return container;
}

- (void)setButton:(UIButton*)button text:(NSString*)text
{
    [button setTitle:text forState:UIControlStateNormal];
    CATransition *transition1 = [CATransition animation];
    transition1.duration = 1.0f;
    transition1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition1.type = kCATransitionFade;
    [button.layer addAnimation:transition1 forKey:nil];
}

- (void)updateTopMonthsTitles
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* com = [[NSDateComponents alloc] init];
    [com setDay:1];
    [com setMonth:currentMonth];
    [com setYear:currentYear];
    NSDate* firstOfTheMonth = [calendar dateFromComponents:com];
    
    [self setButton:currentMonthLabel text:[firstOfTheMonth toStringWithFormat:@"MMMM yyyy"]];
    
    int tempMonth = currentMonth+1;
    int tempYear = currentYear;
    if(tempMonth > 12)
    {
        tempMonth = 1;
        tempYear = currentYear + 1;
    }
    [com setMonth:tempMonth];
    [com setYear:tempYear];
    firstOfTheMonth = [calendar dateFromComponents:com];
    [self setButton:nextMonthTitleButton text:[firstOfTheMonth toStringWithFormat:@"MMMM yyyy"]];
    
    tempMonth = currentMonth-1;
    tempYear = currentYear;
    if(tempMonth < 1)
    {
        tempMonth = 12;
        tempYear = currentYear - 1;
    }
    [com setMonth:tempMonth];
    [com setYear:tempYear];
    firstOfTheMonth = [calendar dateFromComponents:com];
    [self setButton:previousMonthTitleButton text:[firstOfTheMonth toStringWithFormat:@"MMMM yyyy"]];
}

@end
