//
//  UIImageView+LazyLoading.m
//  TechnicalTest
//

#import "UIImageView+LazyLoading.h"
#import "AppDelegate.h"
#import "CacheManager.h"

@implementation UIImageView (LazyLoading)

static char kAssociatedObjectKey;

- (void)setImageWithImageUrl:(NSString*)imageUrl andPlaceHolderImage:(UIImage *)image
{
    //set placeHolder
    if (image)
        [self setImage:image];
    
    self.associatedCheckSum = imageUrl;
    
    UIImage* img = [[CacheManager sharedInstance] getImageOfUrl:imageUrl];
    if(img)
        [self operation:nil FinishedDownloadImage:img];
    else if (imageUrl)
    {
        [DownloadImageOperation addObserver:self forUrl:imageUrl];
        DownloadImageOperation* operation = [[DownloadImageOperation alloc] initWithImageURL:imageUrl andHeaders:nil andShouldSaveItAsJPG:NO];
        [DownloadImageOperation queueInOperation:operation];
    }
}

-(void)setAssociatedCheckSum:(id)object
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)associatedCheckSum
{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey);
}

#pragma mark - DownloadImageOperationDelegate

- (void)operation:(DownloadImageOperation*)operation FinishedDownloadImage:(UIImage*)image
{
	if (image)
	{
		//May same UIIamgeView request multiple Images URLs
		//For example Table cell that use Dequeue feature
		//So here i check isSameCheckSum to ensure this is the latest chechSum.
		bool isSameCheckSum = false;
		if (!operation) {
			isSameCheckSum = true;
		} else {
			if ([operation.imageURL isEqualToString:self.associatedCheckSum]) {
				isSameCheckSum = true;
			}
		}
		
		if (isSameCheckSum && image)
			[self setImage:image];
	}
	
    [DownloadImageOperation removeObserver:self forUrl:operation.imageURL];
}

- (void)operation:(DownloadImageOperation*)operation FailedToDownloadImageWithError:(NSError*)error
{
    [DownloadImageOperation removeObserver:self forUrl:operation.imageURL];
}

@end