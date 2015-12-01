//
//  NSStringCategories.m
//  TechnicalTest
//


#import "NSStringCategories.h"

#define letters  @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define numbers  @"0123456789"
#define alphaNumeric @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789"


@implementation NSString (Additions)

+ (NSString*)stringFromTimeInterval:(NSTimeInterval)interval WithFormat:(NSString*)format {
	int minutes = floor(interval / 60.0);
	
	int seconds = floor(interval) - (minutes*60);
	
	return [NSString stringWithFormat:format, minutes, seconds];
}

+ (NSString*)stringFromDate:(NSDate*)date WithFormat:(NSString*)format
{
	NSDateFormatter* dateFormater = [[NSDateFormatter alloc]init];
    
    NSString* lang = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
    NSRange range = [format rangeOfString:@"dd"];
    if([lang isEqualToString:@"DE"] && range.location != NSNotFound && ![format isEqualToString:@"dd"])
        format = [format stringByReplacingOccurrencesOfString:@"dd" withString:@"dd."];
    [dateFormater setLocale:[NSLocale localeWithLocaleIdentifier:[[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString]]];
    
	[dateFormater setDateFormat:format];
	NSString* string = [dateFormater stringFromDate:date];
	return string;
}


- (void)showWithButtonTitle:(NSString*)buttonTitle Delegate:(NSObject<UIAlertViewDelegate>*)delegate
{
    if(!buttonTitle)
        buttonTitle = [LocalizedString(@"ok", @"") uppercaseString];
	
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:self
                                                   delegate:delegate
                                          cancelButtonTitle:nil
                                          otherButtonTitles:buttonTitle, nil];
    [alert show];
}

- (void)showWithCancelButtonTitle:(NSString*) cancelButton OtherButtonTitle:(NSString*)buttonTitle Completion:(void(^)(BOOL cancel))completion
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:self delegate:nil cancelButtonTitle:(cancelButton)?cancelButton : NSLocalizedString(@"Cancel",) otherButtonTitles:buttonTitle, nil];
    [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        completion(buttonIndex == alertView.cancelButtonIndex);
    }];
}

- (void)showWithTitle:(NSString*)title
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:self
                                                   delegate:nil
                                          cancelButtonTitle:[LocalizedString(@"ok", @"") uppercaseString]
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showWithDelegate:(NSObject<UIAlertViewDelegate>*)delegate 
{
    [self showWithButtonTitle:nil Delegate:delegate];
}

- (void)showWithButtonTitle:(NSString*)buttonTitle
{
    [self showWithButtonTitle:buttonTitle Delegate:nil];
}

- (void)show {
	[self showWithDelegate:nil];
}

- (NSString*)numberingFormated
{
    if([self doubleValue] == 0)
        return @"-";
    NSNumberFormatter* NF = [[NSNumberFormatter alloc]init];
    [NF setAlwaysShowsDecimalSeparator:YES];
    [NF setNumberStyle:NSNumberFormatterCurrencyStyle];
    [NF setCurrencyCode:@""];
    [NF setCurrencyDecimalSeparator:@","];
    [NF setCurrencySymbol:@""];
    [NF setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [NF setCurrencyGroupingSeparator:@" "];
    [NF setMaximumFractionDigits:2];
	[NF setMinimumFractionDigits:2];
	[NF setMaximumSignificantDigits:2];
	[NF setMinimumSignificantDigits:2];
	[NF setMinusSign:@"- "];
    NSString* num = [NF stringFromNumber:[NSNumber numberWithFloat:[self doubleValue]]];
    num = ([self doubleValue] > 0) ? [NSString stringWithFormat:@"+ %@", num] : num;
    num = [num stringByReplacingOccurrencesOfString:@"(" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@")" withString:@""];
    num = [num stringByReplacingOccurrencesOfString:@"- " withString:@""];
    if([self doubleValue] < 0)
        return [NSString stringWithFormat:@"- %@", num];
    return num;
}


- (NSComparisonResult)compareAsIntValues:(NSString*)otherObject
{
    if(!self)
        return NSOrderedDescending;
    if(!otherObject)
        return NSOrderedAscending;
    return [[NSNumber numberWithDouble:[self doubleValue]] compare:[NSNumber numberWithDouble:[otherObject doubleValue]]];
}

- (NSString*)urlEncodedValue
{
    NSString *result = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return result;
}

- (BOOL) isNullNSString
{
	return (self == (id)[NSNull null] || self.length == 0  ||
			[self isEqualToString:@"nil"] || [self isEqualToString:@"null"]);
}

- (BOOL)isValidEmailFormat
{
	BOOL stricterFilter = YES;
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:self];
}

- (BOOL)isWhiteSpace
{
    if(self.length == 0 || ![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

+(NSString *) genRandStringLength: (int) len fromSTR:(NSString*)source{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [source characterAtIndex: arc4random() % [source length]]];
    }
    
    return randomString;
}

+ (NSString*)randomNumericStringWithLength:(int)len
{
    return [NSString genRandStringLength:len fromSTR:numbers];
}
+ (NSString*)randomAlphaNumericStringWithLength:(int)len
{
    return [NSString genRandStringLength:len fromSTR:alphaNumeric];
}
+ (NSString*)randomStringWithLength:(int)len
{
    return [NSString genRandStringLength:len fromSTR:letters];
}

- (BOOL)isValidUrl
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

- (CGSize)sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size {
	CGRect rect = [self boundingRectWithSize:size
									 options:NSStringDrawingUsesLineFragmentOrigin
								  attributes:@{NSFontAttributeName : font}
									 context:nil];
	
	return rect.size;
}

+ (NSString *)alphanumericCharsOfString:(NSString *)string;
{
    NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet alphanumericCharacterSet];
    NSCharacterSet *charactersToRemove = [charactersToKeep invertedSet];
    return [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
}

+ (NSString *)alphanumericCharsOfString:(NSString *)string andKeepAdditionalChars:(NSString *)additionalChars
{
    NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet alphanumericCharacterSet];
    if (additionalChars && additionalChars.length > 0) {
        [charactersToKeep addCharactersInString:additionalChars];
    }
    
    NSCharacterSet *charactersToRemove = [charactersToKeep invertedSet];
    return [[string componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
}

+(NSString *)replaceWidthWith:(float)width andHeightWith:(float)height forImageURL:(NSString *)imageUrl
{
    if (imageUrl) {
        NSString *widthString;
        
        if ([imageUrl rangeOfString:@"{width}"].location != NSNotFound) {
            widthString = [NSString stringWithFormat:@"%i", (int)width*2];
            imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"{width}" withString:widthString];
        }
        
        if ([imageUrl rangeOfString:@"{height}"].location != NSNotFound) {
            NSString *heightString = [NSString stringWithFormat:@"%i",(int)height*2];
            imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"{height}" withString:heightString];
        }
        
        return imageUrl;
    }
    
    return @"";
}

@end