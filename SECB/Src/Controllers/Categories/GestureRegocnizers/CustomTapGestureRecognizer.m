//
//  CustomTapGestureRecognizer.m
//  Probooking
//
//  Created by Peter Mosaad on 12/24/14.
//
//

#import "CustomTapGestureRecognizer.h"

@implementation CustomTapGestureRecognizer

+ (CustomTapGestureRecognizer*)openMapGestureRecognizerWithLocation:(CLLocationCoordinate2D)location
{
    CustomTapGestureRecognizer* tgr = [[CustomTapGestureRecognizer alloc] init];
    [tgr addTarget:tgr action:@selector(openMap)];
    
    tgr.attribute = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    return tgr;
}


+ (CustomTapGestureRecognizer*)callNumberGestureRecognizerForNumber:(NSString*)number
{
    CustomTapGestureRecognizer* tgr = [[CustomTapGestureRecognizer alloc] init];
    [tgr addTarget:tgr action:@selector(callNumber)];
    tgr.attribute = number;
    return tgr;
}

+ (CustomTapGestureRecognizer*)openWebSiteGestureRecognizerForWebSite:(NSString*)webSite
{
    CustomTapGestureRecognizer* tgr = [[CustomTapGestureRecognizer alloc] init];
    [tgr addTarget:tgr action:@selector(openWebsite)];

    tgr.attribute = webSite;
    return tgr;
}


- (void)callNumber
{
    if(!isIPhone)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [self.attribute stringByReplacingOccurrencesOfString:@" "  withString:@""]]];
        [[UIApplication sharedApplication] openURL:url];        
    }
}

- (void)openWebsite
{
    NSURL *url = [NSURL URLWithString:self.attribute];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)openMap
{
    CLLocationCoordinate2D coordinate = ((CLLocation*)(self.attribute)).coordinate;
    
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
    {
        //using iOS6 native maps app
        [destination openInMapsWithLaunchOptions:nil];
    }
    else
    {
        //using iOS 5 which has the Google Maps application
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", coordinate.latitude, coordinate.longitude];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}


@end
