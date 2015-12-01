//
//  DownloadImageOperation.h
//  TechnicalTest
//
//  Created by Peter on 11/14/13.
//  Copyright (c) 2013 My Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseOperation.h"

@class DownloadImageOperation;

@protocol DownloadImageOperationDelegate <NSObject>
- (void)operation:(DownloadImageOperation*)operation FinishedDownloadImage:(UIImage*)image;
- (void)operation:(DownloadImageOperation*)operation FailedToDownloadImageWithError:(NSError*)error;
@end

@interface DownloadImageOperation : BaseOperation

@property (retain) NSString             *imageURL;
@property (strong) NSMutableDictionary  *requestHeaders;

@property bool shouldSaveAsJPG;

- (id)initWithImageURL:(NSString*)url andHeaders:(NSMutableDictionary *)headers andShouldSaveItAsJPG:(bool)saveAsJPG;
+ (void)addObserver:(id<DownloadImageOperationDelegate>)observer forUrl:(NSString *)url;
+ (void)removeObserver:(id<DownloadImageOperationDelegate>)observer forUrl:(NSString *)url;

@end