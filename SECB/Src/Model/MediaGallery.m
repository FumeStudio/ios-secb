//
//  MediaGallery.m
//  SECB
//
//  Created by Peter Mosaad on 10/14/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "MediaGallery.h"

@implementation MediaGallery

- (NSString*)youTubeVideoID
{
    NSString *regexString = @"^(?:http(?:s)?://)?(?:www\\.)?(?:m\\.)?(?:youtu\\.be/|youtube\\.com/(?:(?:watch)?\\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user)/))([^\?&\"'>]+)";
    
    NSError *error;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:regexString
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self.galleryImgUrl
                                                    options:0
                                                      range:NSMakeRange(0, [self.galleryImgUrl length])];
    
    if (match && match.numberOfRanges == 2) {
        NSRange videoIDRange = [match rangeAtIndex:1];
        NSString *videoID = [self.galleryImgUrl substringWithRange:videoIDRange];
        
        return videoID;
    }
    return @"";
}

@end
