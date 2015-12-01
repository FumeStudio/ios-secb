//
//  HTTPConnection.h
//  TechnicalTest
//

#import <UIKit/UIKit.h>

#define ConnectionTimeoutInterval 45

typedef enum HTTPStatusCode {
	//Informational		1xx
	HTTPStatusCodeContinue = 100,
	HTTPStatusCodeSwitchingProtocols = 101,
	
	//Successful		2xx
	HTTPStatusCodeOK = 200,
	HTTPStatusCodeCreated = 201,
	HTTPStatusCodeAccepted = 202,
	HTTPStatusCodeNonAuthoritativeInformation = 203,
	HTTPStatusCodeNoContent = 204,
	HTTPStatusCodeResetContent = 205,
	HTTPStatusCodePartialContent = 206,
	
	//Redirect			3xx
	HTTPStatusCodeMultipleChoices = 300,
	HTTPStatusCodeMovedPermanently = 301,
	HTTPStatusCodeFound = 302,
	HTTPStatusCodeSeeOther = 303,
	HTTPStatusCodeNotModified = 304,
	HTTPStatusCodeUseProxy = 305,
	HTTPStatusCodeUnused = 306,
	HTTPStatusCodeTemporaryRedirect = 307,
	
	//Client Error		4xx
	HTTPStatusCodeBadRequest = 400,
	HTTPStatusCodeUnauthorized = 401,
	HTTPStatusCodePaymentRequired = 402,
	HTTPStatusCodeForbidden = 403,
	HTTPStatusCodeNotFound = 404,
	HTTPStatusCodeMethodNotAllowed = 405,
	HTTPStatusCodeNotAcceptable = 406,
	HTTPStatusCodeProxyAuthenticationRequired = 407,
	HTTPStatusCodeRequestTimeOut = 408,
	HTTPStatusCodeConflict = 409,
	HTTPStatusCodeGone = 410,
	HTTPStatusCodeLengthRequired = 411,
	HTTPStatusCodePreconditionFailed = 412,
	HTTPStatusCodeRequestEntityTooLarge = 413,
	HTTPStatusCodeRequestURITooLong = 414,
	HTTPStatusCodeUnsupporteMediaType = 415,
	HTTPStatusCodeRequestedRangeNotSatisfiable = 416,
	HTTPStatusCodeExpectationFailed = 417,
	
	//Server Error		5xx
	HTTPStatusCodeInternalServerError = 500,
	HTTPStatusCodeNotImplemented = 501,
	HTTPStatusCodeBadGateway = 502,
	HTTPStatusCodeServiceUnavailable = 503,
	HTTPStatusCodeGatewayTimeout = 504,
	HTTPStatusCodeHTTPVersionNotSupported = 505
	
} HTTPStatusCode;


@protocol HTTPConnectionDelegate  <NSObject>

- (void)didSucceedWithCode:(HTTPStatusCode)code Body:(NSData*)body;
- (void)didFailWithError:(NSError**)error;

@optional
    - (void)didReceiveResponseWithCode:(HTTPStatusCode)code ResponseHeaders:(NSDictionary*)HTTPResponseHeaders;
@end


@interface HTTPConnection : NSObject <NSURLConnectionDataDelegate> {
	HTTPStatusCode responseCode;
	NSMutableData* receivedData;
	__weak id<HTTPConnectionDelegate> delegate;
	NSURLConnection* innerConnection;
}

@property (weak) id<HTTPConnectionDelegate> delegate;
@property (strong) NSMutableData* receivedData;
@property (strong) NSURLConnection* innerConnection;

+ (id)connection;
+ (id)connectionWithDelegate:(NSObject<HTTPConnectionDelegate>*)aDelegate;
- (id)initWithDelegate:(NSObject<HTTPConnectionDelegate>*)aDelegate;
+(NSMutableDictionary*) constructRemainingHeaders:(NSMutableDictionary*) headers :(NSData*)body;
-(NSData*) sendSynchronousRequestByUrl:(NSString*)url Body:(NSData*)body RequestMethod:(NSString*)method HttpHeaders:(NSDictionary*)headers serverResponse:(NSURLResponse**)response ServerError:(NSError**)error;
-(void) sendAsynchronousRequestByUrl:(NSString*)url Body:(NSData*)body RequestMethod:(NSString*)method HttpHeaders:(NSDictionary*)headers connectionDictionaryKeyString:(NSString*) connectionDictionaryKeyString;
- (void)cancel;

@end
