//
//  NSStringCategories.h
//  TechnicalTest
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Additions)

+ (NSString*)stringFromTimeInterval:(NSTimeInterval)interval WithFormat:(NSString*)format;
+ (NSString*)stringFromDate:(NSDate*)date WithFormat:(NSString*)format;

- (BOOL)isValidEmailFormat;
- (BOOL)isWhiteSpace;

- (void)showWithButtonTitle:(NSString*)buttonTitle;
- (void)showWithButtonTitle:(NSString*)buttonTitle Delegate:(NSObject<UIAlertViewDelegate>*)delegate;
- (void)showWithCancelButtonTitle:(NSString*) cancelButton OtherButtonTitle:(NSString*)buttonTitle Completion:(void(^)(BOOL cancel))completion;
- (void)showWithDelegate:(NSObject<UIAlertViewDelegate>*)delegate;
- (void)showWithTitle:(NSString*)title;
- (void)show;

- (NSString*)numberingFormated;

- (NSString*)urlEncodedValue;

+ (NSString*)randomNumericStringWithLength:(int)len;
+ (NSString*)randomAlphaNumericStringWithLength:(int)len;
+ (NSString*)randomStringWithLength:(int)len;

- (BOOL)isValidUrl;
- (BOOL) isNullNSString;
- (CGSize)sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

+ (NSString *)alphanumericCharsOfString:(NSString *)string;
+ (NSString *)alphanumericCharsOfString:(NSString *)string andKeepAdditionalChars:(NSString *)additionalChars;
+ (NSString *)replaceWidthWith:(float)width andHeightWith:(float)height forImageURL:(NSString *)imageUrl;

@end

