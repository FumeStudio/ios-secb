//
//  DownloadImageOperation.m
//  TechnicalTest
//

#import "DownloadImageOperation.h"
#import "NSException+CustomInitialization.h"
#import "CacheManager.h"
#import "BaseOperation.h"
#import "UIImage+Extension.h"
#import "HTTPConnection.h"
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"

@implementation DownloadImageOperation

+ (NSMutableArray *)currentDownloadingUrls
{
    static NSMutableArray* currentDownloading;
    @synchronized(self) {
        if (currentDownloading == nil) {
            currentDownloading = [[NSMutableArray alloc] init];
        }
    }
    return currentDownloading;
}

+ (NSMutableDictionary *)urlsObservers
{
    static NSMutableDictionary* all_observers;
    @synchronized(self) {
        if (all_observers == nil) {
            all_observers = [[NSMutableDictionary alloc] init];
        }
    }
    return all_observers;
}

+ (NSMutableArray*)observersOfUrl:(NSString *)url
{
	NSMutableDictionary *all_observers = [self urlsObservers];
    
    NSMutableArray *observers = [all_observers objectForKey:url];
    
    if(!observers && url)
    {
        observers = [NSMutableArray array];
        [all_observers setObject:observers forKey:url];
    }
	
    return observers;
}

+(bool)isImageWithUrlInDownloadingQueue:(NSString *)url
{
	bool isDownloading = false;
	@try {
		NSMutableArray *arr = [self currentDownloadingUrls];
		NSMutableArray *currentDownloading = [NSMutableArray arrayWithArray:arr];
		
		
		for (NSString *theUrl in currentDownloading) {
			if ([theUrl isKindOfClass:[NSString class]] && [theUrl isEqualToString:url]) {
				isDownloading = true;
				break;
			}
		}
	}
	@catch (NSException *exception) {
        
	}
	@finally {
		return isDownloading;
	}
}

+(void)removeUrlOfDowloadingQueue:(NSString *)url
{
    NSMutableDictionary *all_observers = [self urlsObservers];
    
    if ([all_observers objectForKey:url])
        [all_observers removeObjectForKey:url];
    
    NSMutableArray* copy = [NSMutableArray arrayWithArray:[self currentDownloadingUrls]];
    for (NSString *theUrl in copy) {
        if ([theUrl isEqualToString:url]) {
            [[self currentDownloadingUrls] removeObject:theUrl];
            break;
        }
    }
}

+(void)addUrlToCurrentDownloadingUrls:(NSString *)url
{
    if (![self isImageWithUrlInDownloadingQueue:url]) {
        [[self currentDownloadingUrls] addObject:url];
    }
}

- (id)initWithImageURL:(NSString*)url andHeaders:(NSMutableDictionary *)headers andShouldSaveItAsJPG:(bool)saveAsJPG
{
    self = [super init];
    if (self)
    {
		self.shouldSaveAsJPG = saveAsJPG;
		
        if (headers)
            self.requestHeaders = headers;
        
        if(url)
            self.imageURL = url;
    }
    return self;
}

+ (BOOL)enuserRequestSuccesFromStatusCode:(HTTPStatusCode)statusCode HttpResponse:(NSDictionary*)headers resopnseData:(NSData*)responseData
{
//    NSError* error = nil;
//    if(!(statusCode == HTTPStatusCodeOK || statusCode == HTTPStatusCodeCreated))
//    {
//        int errorCode = 0;
//        
//        NSString* errorMsg = @"";
//        NSObject* temp = [headers objectForKey:@"Error-Code"];
//        if(temp)
//            errorCode = [(NSNumber*)temp intValue];
//        
//        temp = [headers objectForKey:@"Error-Msg"];
//        if(temp)
//            errorMsg = [NSString stringWithString:(NSString*)temp];
//        
//        if (statusCode == HTTPStatusCodeInternalServerError && [errorMsg isEqualToString:@""])
//            errorMsg = NSLocalizedString(@"ServerError500", @"");
//        
//        error = [NSError errorWithDomain:ServerErrorDomainName code:errorCode userInfo:[NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey]];
//    }
//    
//    if(error)
//    {
//        [BaseOperation throughExceptionWithError:error];
//        return false;
//    }
//    
    return true;
}

- (UIImage*)downLoadImage
{
    __block UIImage *theImage = [[CacheManager sharedInstance] getImageOfUrl:self.imageURL];
    
    if ((!theImage) && self.imageURL) //not cached
    {
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:self.imageURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            NSData* dat =[NSData dataWithContentsOfFile:[filePath path]];
            theImage = [UIImage imageWithData:dat];
            dispatch_semaphore_signal(sema);
        }];
        
        [downloadTask resume];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.imageURL]];
//        [request setRequestHeaders:self.requestHeaders];
//        [request setDownloadDestinationPath:imagePath];
//        [request startSynchronous];
//        
//        if(request.error)
//            [BaseOperation throughExceptionWithError:request.error];
//        else
//            [DownloadImageOperation enuserRequestSuccesFromStatusCode:[request responseStatusCode] HttpResponse:[request responseHeaders] resopnseData:[request responseData]];
        
        
        
        //// Scale image to Max Size
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        CGSize size =((UIWindow*)([[UIApplication sharedApplication].windows objectAtIndex:0])).frame.size;
        CGSize maximumSize = CGSizeMake(size.width*screenScale, size.height*screenScale);
        
        theImage = [theImage scaleImage:theImage ToSize:maximumSize];
        [[CacheManager sharedInstance] saveImage:theImage withUrl:self.imageURL andShouldSaveItAsJPG:self.shouldSaveAsJPG];
    }
    
    return theImage;
}

- (void)main
{
    if (![[self class] isImageWithUrlInDownloadingQueue:self.imageURL])
    {
        NSError* error;
        UIImage* operationResult;
        
        [[self class] addUrlToCurrentDownloadingUrls:self.imageURL];
        
        @try
        {
            operationResult = [self downLoadImage];
        }
        @catch (NSException *exception)
        {
            error = [exception error];
            if(!error)
                error = [NSError errorWithDomain:@"UnHandledError" code:-1 userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:exception.name, exception, nil] forKeys:[NSArray arrayWithObjects:NSLocalizedDescriptionKey, @"Exception", nil]]];
        }
        @finally
        {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self forKey:@"operation"];
            if(operationResult)
                [params setObject:operationResult forKey:@"operationResult"];
            
            if(error)
                [params setObject:error forKey:@"error"];
            
            [self performSelectorOnMainThread:@selector(notify:) withObject:params waitUntilDone:YES];
        }
    }
}



- (void)notifyObserversOfOperation:(DownloadImageOperation*)operation WithImage:(UIImage*)operationResult error:(NSError*)error
{    
    NSMutableArray* copy = [NSMutableArray arrayWithArray:[[self class] observersOfUrl:self.imageURL]];
    
    for(id<DownloadImageOperationDelegate>obs in copy)
    {
        if(!error && [obs respondsToSelector:@selector(operation:FinishedDownloadImage:)])
            [obs operation:self FinishedDownloadImage:operationResult];
        else if([obs respondsToSelector:@selector(operation:FailedToDownloadImageWithError:)])
            [obs operation:self FailedToDownloadImageWithError:error];
    }
    
    [[self class] removeUrlOfDowloadingQueue:self.imageURL];
}

- (void)notify:(NSDictionary*)params
{
    DownloadImageOperation* operation = [params objectForKey:@"operation"];
    UIImage* operationResult = [params objectForKey:@"operationResult"];
    NSError* error = [params objectForKey:@"error"];
    [self notifyObserversOfOperation:operation WithImage:operationResult error:error];
}

- (BOOL)isConcurrent
{
    return YES;
}

#pragma mark -
+ (void)addObserver:(id<DownloadImageOperationDelegate>)observer forUrl:(NSString *)url
{
    if(url && (![[[self class] observersOfUrl:url] containsObject:observer]))
        [[[self class] observersOfUrl:url] addObject:observer];
}

+(void)removeObserver:(id<DownloadImageOperationDelegate>)observer forUrl:(NSString *)url
{
    if(url && (![[[self class] observersOfUrl:url] containsObject:observer]))
        [[[self class] observersOfUrl:url] removeObject:observer];
}

@end