//
//  UserManager.h
//  Probooking
//
//  Created by Peter Mosaad on 1/12/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseOperation.h"
#import "User.h"

@interface UserManager : NSObject <BaseOperationDelegate>

@property (readonly)    bool isUserLoggedIn;
@property (strong)      User *currentLoggedInUser;

+(UserManager *)sharedInstance;


- (void)saveLoggedInUser;
- (void)updateUserDataWithUser:(User *)updatedUser;
- (void)getLoggedInUser;
- (void)removeLoggedInUser;

- (void)saveLanguageSettingTo:(NSString *)language;
- (void)setAppLanguage;

- (void)performSilentLogin;

- (void)userDidSignIn:(User*)aUser;
- (void)userDidLogOut;

- (void)signOut;

+ (void)deleteSavedCookies;
+ (BOOL)cookiesExpired;

@end