//
//  BasicOperation.h
//  TechnicalTest
//

#import <Foundation/Foundation.h>
#import "NSErrorCategories.h"
#import "Constants.h"

@class BaseOperation;

@protocol BaseOperationDelegate <NSObject>
- (void)operation:(BaseOperation*)operation succededWithObject:(id)object;
- (void)operation:(BaseOperation*)operation failedWithError:(NSError*)error userInfo:(id)info;
@optional
- (void)operationStartedWithOperation:(BaseOperation*)operation ;
@end

@interface BaseOperation : NSOperation

@property (readonly) BOOL needsAuthentication;

@property int operationTag;

+ (NSMutableArray*)observers;

+ (void)queueInOperation:(BaseOperation*)op;

+ (void)addObserver:(id<BaseOperationDelegate>)observer;
+ (void)removeObserver:(id<BaseOperationDelegate>)observer;

+ (void)throughExceptionWithError:(NSError*)error;

+ (void)notifyObserversOfOperation:(BaseOperation*)operation Withobject:(id)operationResult error:(NSError*)error;

- (id)doMain;

+ (NSData*)doRequestWithHttpMethod:(NSString*)method URL:(NSString*)url requestBody:(NSData*)body customHttpHeaders:(NSDictionary*) headers forOperation:(BaseOperation*)operation;
@end