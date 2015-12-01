//
//  SendContactUsFormOperation.h
//  SECB
//
//  Created by Peter Mosaad on 10/28/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactUsForm.h"

@interface SendContactUsFormOperation : BaseOperation
{
    ContactUsForm* formData;
}

- (id)initWithFormData:(ContactUsForm*)form;

@end
