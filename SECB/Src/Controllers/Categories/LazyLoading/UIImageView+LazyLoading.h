//
//  UIImageView+LazyLoading.h
//  TechnicalTest
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "DownloadImageOperation.h"

@interface UIImageView (LazyLoading) <DownloadImageOperationDelegate>

@property (nonatomic, strong) id associatedCheckSum;

- (void)setImageWithImageUrl:(NSString*)imageUrl andPlaceHolderImage:(UIImage *)image;

@end