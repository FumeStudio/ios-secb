//
//  LoginSignupNavigationController.h
//  Probooking
//
//  Created by Peter on 8/27/14.
//
//

#import "SignInOperation.h"
#import "User+JSON.h"
#import "UserManager.h"


@implementation SignInOperation


- (id)initWithUser:(User *)user
{
    self = [super init];
    if(self)
    {
        currentUser = user;
    }
    
    return self;
}

- (id)doMain
{
    [self doSignInRequest];
    [UserManager sharedInstance].currentLoggedInUser = currentUser;
    [[UserManager sharedInstance] saveLoggedInUser];
    return currentUser;
}

- (NSData *)doSignInRequest
{
    /// construct URL and Create connection
    [UserManager deleteSavedCookies];
    
    NSString* url = @"http://secb.linkdev.com/_vti_bin/authentication.asmx";
    NSDictionary *headers = @{ @"content-type": @"text/xml; charset=utf-8" };
    
    NSString* xmlStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                        <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                        <soap:Body>\
                        <Login xmlns=\"http://schemas.microsoft.com/sharepoint/soap/\">\
                        <username>%@</username>\
                        <password>%@</password>\
                        </Login>\
                        </soap:Body>\
                        </soap:Envelope>", currentUser.username, currentUser.password];
    NSData *postData = [[NSData alloc] initWithData:[xmlStr dataUsingEncoding:NSUTF8StringEncoding]];
                                                     
    NSData* response = [BaseOperation doRequestWithHttpMethod:@"POST" URL:url requestBody:postData customHttpHeaders:headers forOperation:self];
    NSMutableData* webData = [NSMutableData dataWithBytes:[response bytes] length:[response length]];
    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@" , theXML) ;
    if([theXML rangeOfString:@"PasswordNotMatch"].length)
        [[self class] throughExceptionWithError:[NSError errorWithDomain:@"" code:405 userInfo:[NSDictionary dictionaryWithObject:LocalizedString(@"Password Not Match", ) forKey:NSLocalizedDescriptionKey]]];
    
    return nil;
}

- (BOOL)shouldProceed
{
    return YES;
}

@end
