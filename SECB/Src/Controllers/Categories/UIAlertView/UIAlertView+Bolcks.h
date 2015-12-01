//
//  UIAlertView+Bolcks.h
//  TechnicalTest
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Bolcks)

- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
