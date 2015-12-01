//
//  CustomTapGestureRecognizer.h
//  Probooking
//
//  Created by Peter Mosaad on 12/24/14.
//
//

#import <UIKit/UIKit.h>

@interface CustomTapGestureRecognizer : UITapGestureRecognizer

@property(strong) id attribute;

+ (CustomTapGestureRecognizer*)callNumberGestureRecognizerForNumber:(NSString*)number;
+ (CustomTapGestureRecognizer*)openWebSiteGestureRecognizerForWebSite:(NSString*)WebSite;
+ (CustomTapGestureRecognizer*)openMapGestureRecognizerWithLocation:(CLLocationCoordinate2D)location;

@end
