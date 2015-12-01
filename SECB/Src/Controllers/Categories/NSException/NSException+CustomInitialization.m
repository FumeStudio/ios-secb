//
//  NSException+CustomInitialization.m
//  TechnicalTest
//

#import "NSException+CustomInitialization.h"

@implementation NSException (CustomInitialization)

+ (NSException *)exceptionWithError:(NSError*)error
{
    NSException* ex = [NSException exceptionWithName:@"" reason:@"" userInfo:[NSDictionary dictionaryWithObject:error forKey:@"Error"]];
    return ex;
}

- (NSError*)error
{
    return [self.userInfo objectForKey:@"Error"];
}

@end
