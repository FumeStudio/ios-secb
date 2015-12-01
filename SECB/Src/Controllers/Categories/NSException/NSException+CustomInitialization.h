//
//  NSException+CustomInitialization.h
//  TechnicalTest
//

#import <Foundation/Foundation.h>

@interface NSException (CustomInitialization)

+ (NSException *)exceptionWithError:(NSError*)error;
- (NSError*)error;
@end
