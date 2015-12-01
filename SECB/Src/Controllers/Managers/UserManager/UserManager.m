//
//  UserManager.m
//  Probooking
//
//  Created by Peter Mosaad on 1/12/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "UserManager.h"
#import "CacheManager.h"
#import "SignInOperation.h"

@interface UserManager ()
{
    BOOL didSendSendLocaitonToServer;
    NSString* mainServiceURL;
}
@end

@implementation UserManager

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadLastUserServiceURL];
        [self getLoggedInUser];
//        if(self.currentLoggedInUser)
//        {
//            [self performSilentLogin];
//        }
    }
    return self;
}

+(UserManager *)sharedInstance
{
    static UserManager *sharedInstance;
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (void)performSilentLogin
{
}

//called after login process success only else use updateUserDataWithUser
-(void)saveLoggedInUser
{
	NSData* loggedProfileData = [NSKeyedArchiver archivedDataWithRootObject:self.currentLoggedInUser];
	[[NSUserDefaults standardUserDefaults] setObject:loggedProfileData forKey:@"lastLoggedInUser"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateUserDataWithUser:(User *)updatedUser
{
    self.currentLoggedInUser = updatedUser;
    [self saveLoggedInUser];
}

-(void)getLoggedInUser
{
    NSData* loggedProfileData = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoggedInUser"];
	if (loggedProfileData)
    {
        self.currentLoggedInUser = [NSKeyedUnarchiver unarchiveObjectWithData:loggedProfileData];
        
        if(self.currentLoggedInUser)
        {
            [self performLoggedInUserProcedures];
        }
    }
}

-(void)removeLoggedInUser
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastLoggedInUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	self.currentLoggedInUser = nil;
}

- (void)signOut
{
    [self userDidLogOut];
}

-(bool)isUserLoggedIn
{
    return self.currentLoggedInUser && self.currentLoggedInUser.authToken;;
}

#pragma mark - CallBacks

- (void)performLoggedInUserProcedures
{
    ////
    
}

- (void)userDidSignIn:(User*)signedInUser
{
    self.currentLoggedInUser = signedInUser;
    [self saveLoggedInUser];
    
    [self performLoggedInUserProcedures];
}

- (void)userDidLogOut
{
    //// Delete current logged in user
    self.currentLoggedInUser = nil;
    //// Delete cached user
    [self removeLoggedInUser];
}

#pragma mark - Setting

-(void)saveLanguageSettingTo:(NSString *)language
{
    NSData* customLangData = [NSKeyedArchiver archivedDataWithRootObject:language];
	[[NSUserDefaults standardUserDefaults] setObject:customLangData forKey:@"customLanguage"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:language, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setAppLanguage
{
    NSString *language = @"";
    
    NSData* customLangData = [[NSUserDefaults standardUserDefaults] objectForKey:@"customLanguage"];
    if (customLangData)
        language = [NSKeyedUnarchiver unarchiveObjectWithData:customLangData];
    else
    {
        language = [[[NSLocale preferredLanguages] objectAtIndex:0] uppercaseString];
		//language = FRENCH_LANGUAGE;
        
        [self saveLanguageSettingTo:language];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:language, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - BaseOperationDelegate

- (void)operation:(BaseOperation*)operation succededWithObject:(id)object
{
}

- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info
{
    
}

#pragma mark - 

- (NSMutableDictionary*)serviceURLs
{
    return [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                              @"http://api.probooking.de/v1/",
                                                              @"http://develop.probooking.de/app_dev.php/v1/",
                                                              @"http://probooking.localhost.192.168.79.101.xip.io/app_dev.php/v1/",
                                                              nil]
                                                     forKeys:self.serviceURLsKeys];
    
}

- (NSArray*)serviceURLsKeys
{
    return [NSArray arrayWithObjects:
            @"ProdServer:",
            @"DevServer:",
            @"DevLocal:",
            nil];
}

- (void)loadLastUserServiceURL
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    mainServiceURL = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastUserServiceURL"];
}

- (void)setMainServiceURL:(NSString*)url
{
    if(url)
    {
        mainServiceURL = [NSString stringWithString:url];
        
        [[NSUserDefaults standardUserDefaults] setObject:mainServiceURL forKey:@"LastUserServiceURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)selecetedServiceURL
{
    if(!mainServiceURL)
        [self setMainServiceURL:[self.serviceURLs objectForKey:self.serviceURLsKeys.firstObject]];
    
    return mainServiceURL;
}

+ (BOOL)cookiesExpired
{
    NSArray* array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]];
    
    for(NSHTTPCookie* cookie in array)
        if([[NSDate date] compare:[cookie expiresDate]] != NSOrderedDescending)
            return NO;
    return YES;
}


+ (void)deleteSavedCookies
{
    NSArray* array = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://secb.linkdev.com"]];
    
    for(NSHTTPCookie* cookie in array)
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
}


@end