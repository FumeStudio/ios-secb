//
//
//  HTTPConnection.m
//  TechnicalTest
//

#import "HTTPConnection.h"

@implementation HTTPConnection

@synthesize delegate, receivedData, innerConnection;

#pragma mark -
#pragma mark General Methods

+ (id)connection {
    return [[HTTPConnection alloc] initWithDelegate:nil];
}

+ (id)connectionWithDelegate:(NSObject<HTTPConnectionDelegate>*)aDelegate {
	return [[HTTPConnection alloc] initWithDelegate:aDelegate];
}

- (id)initWithDelegate:(NSObject<HTTPConnectionDelegate>*)aDelegate {
	self = [self init];
	
	self.delegate = aDelegate;
	
	return self;
}

#pragma mark -
#pragma mark General Services

+ (NSMutableDictionary*) constructRemainingHeaders:(NSMutableDictionary*) headers :(NSData*)body
{
	if(!headers)
		headers = [NSMutableDictionary dictionary];
	if(body)
		[headers setObject:[NSString stringWithFormat:@"%ld", (unsigned long)[body length]] forKey:@"Content-Length"];
	else
		[headers setObject:@"0" forKey:@"Content-Length"];
	
	if(![headers objectForKey:@"Content-Type"])
		[headers setObject:@"application/json" forKey:@"Content-Type"];
	
	return headers;
}

- (void)cancel
{
	if (innerConnection) {
		[innerConnection cancel];
		self.innerConnection = nil;
	}
	self.delegate = nil;
}

#pragma mark -
#pragma mark Synchronous Requests

-(NSData*) sendSynchronousRequestByUrl:(NSString*)url Body:(NSData*)body RequestMethod:(NSString*)method HttpHeaders:(NSDictionary*)headers serverResponse:(NSURLResponse**)response ServerError:(NSError**)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	if(!(url&&method))
		return nil;
    
	NSURL *myWebserverURL = [NSURL URLWithString:url];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myWebserverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:ConnectionTimeoutInterval]; 

	[request setHTTPMethod:method];
	
	if(headers)
		headers = [HTTPConnection constructRemainingHeaders:[NSMutableDictionary dictionaryWithDictionary:headers] :body];
	else 
		headers = [HTTPConnection constructRemainingHeaders:[NSMutableDictionary dictionary] :body];
    
	if(headers)
	{
		[request setAllHTTPHeaderFields:headers];
	}
	
	if(body)
		[request setHTTPBody:body];
    
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    return data;
}

#pragma mark -
#pragma mark Asynchronous Requests

-(void) sendAsynchronousRequestByUrl:(NSString*)url Body:(NSData*)body RequestMethod:(NSString*)method HttpHeaders:(NSDictionary*)headers connectionDictionaryKeyString:(NSString*) connectionDictionaryKeyString {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
	if(!(url&&method))
		return ;

    NSURL *myWebserverURL = [NSURL URLWithString: url];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myWebserverURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:ConnectionTimeoutInterval]; 
	
	[request setHTTPMethod:method];
    
	if(headers)
		headers = [HTTPConnection constructRemainingHeaders:[NSMutableDictionary dictionaryWithDictionary:headers] :body];
	else 
		headers = [HTTPConnection constructRemainingHeaders:[NSMutableDictionary dictionary] :body];
    
    [request setAllHTTPHeaderFields:headers];
		
	if(body)
		[request setHTTPBody:body];
    
    self.innerConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:true];
}

#pragma mark -
#pragma mark NSURLConnection delegate


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    responseCode = (int)[response statusCode];

    if(self.delegate && [self.delegate respondsToSelector:@selector(didReceiveResponseWithCode:ResponseHeaders:)])
        [self.delegate didReceiveResponseWithCode:responseCode ResponseHeaders:[response allHeaderFields]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
	if (!receivedData) {
		self.receivedData = [[NSMutableData alloc]init];
	}
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
	if(delegate)
		[delegate didSucceedWithCode:responseCode Body:receivedData];
	
	self.receivedData = nil;
	self.innerConnection = nil;
	self.delegate = nil;
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	
	[error code];
	responseCode = -1;

	if(delegate)
		[delegate didFailWithError:&error];
	
	self.receivedData = nil;
	self.innerConnection = nil;
	self.delegate = nil;
	
	return;	
}


@end

