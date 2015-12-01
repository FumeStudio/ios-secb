//
//  User.h
//  Probooking
//
//  Created by Peter Mosaad on 12/15/14.
//  Copyright (c) 2014 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (strong) NSString *ID;
@property (strong) NSString *firstName;
@property (strong) NSString *lastName;
@property (strong) NSString *authToken;
@property (strong) NSString *email;
@property (strong) NSString *username;
@property (strong) NSString *password;
@property (strong) NSString *phone;

@property int inProgressRequestsCounter;
@property int closedRequestsCounter;
@property int inboxRequestsCounter;

@end