//
//  UIView+Loading.h
//  TechnicalTest
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#define BaseIndicatorSize 30.0

@interface UIView (Loading)

- (MBProgressHUD*)showProgressWithMessage:(NSString*)message;
- (void)hideProgress;

@end
