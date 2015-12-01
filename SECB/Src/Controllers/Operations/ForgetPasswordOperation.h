//
//  ForgetPasswordOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/25/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"

@interface ForgetPasswordOperation : BaseOperation
{
    NSString* currentUserName;
}

- (id)initWithUserName:(NSString*)username;

@end
