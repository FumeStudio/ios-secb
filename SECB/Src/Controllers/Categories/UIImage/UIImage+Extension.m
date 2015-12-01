//
//  UIImage+Extension.m
//  TechnicalTest
//

#import "UIImage+Extension.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (Extension)

- (UIImage*)scaleImage:(UIImage*)image ToSize:(CGSize)maximumSize
{
    CGSize imgSize = image.size;
    
    if(imgSize.width > maximumSize.width || imgSize.height > maximumSize.height)
    {
        BOOL scaleToWidth = imgSize.width > imgSize.height;
        
        CGSize newSize;
        
        if(scaleToWidth)
            newSize = CGSizeMake(maximumSize.width, ((maximumSize.width * imgSize.height) / imgSize.width));
        else
            newSize = CGSizeMake(((maximumSize.height * imgSize.width) / imgSize.height), maximumSize.height);
        
        // Create a graphics image context
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        
        // Tell the old image to draw in this new context, with the desired
        // new size
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
        // Get the new image from the context
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // End the context
        UIGraphicsEndImageContext();
        
        // Return the new image.
        return newImage;
    }
    return image;
}

@end