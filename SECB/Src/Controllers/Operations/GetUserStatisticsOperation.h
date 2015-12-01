//
//  GetUserStatisticsOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "BaseOperation.h"

@interface GetUserStatisticsOperation : BaseOperation
{
    User* currentUser;
}
- (id)initWithUser:(User*)user;
@end
