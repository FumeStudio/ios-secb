//
//  LoginSignupNavigationController.h
//  Probooking
//
//  Created by Peter on 8/27/14.
//
//

#import "BaseOperation.h"
#import "User.h"

@interface SignInOperation : BaseOperation
{
    User* currentUser;
}

- (id)initWithUser:(User *)user;

@end
