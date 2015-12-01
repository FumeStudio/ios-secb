//
//  EventDetailsViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/4/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController

- (id)initWithEvent:(Event*)event
{
    self = [super initWithDefaultNibFile];
    currentEvent = event;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshLocalization
{
    headerTitleLabel.text = LocalizedString(@"Event Details", );
    allDayEventTitleLabel.text = LocalizedString(@"All Day Event", );
    repeatedEventTitleLabel.text = LocalizedString(@"Repeated Event", );
    
    [super refreshLocalization];
    
}


- (void)updateView
{
    dayLabel.text = [currentEvent.eventDate toStringWithFormat:@"dd"];
    monthLabel.text = [currentEvent.eventDate toStringWithFormat:@"MMM"];
    eventTitleLabel.text = currentEvent.eventTitle;
    eventTimeLabel.text = [currentEvent.eventDate toStringWithFormat:@"HH:mm"];
    eventLocationLabel.text = currentEvent.eventSiteCity;
    eventCategoryLabel.text = currentEvent.eventCategory;
    
    allDayEventView.hidden = !currentEvent.isAllDayEvent;
    repeatedEventView.hidden = !currentEvent.isRecurrence;

    eventDetailsLabel.text = currentEvent.eventDescription;
    if(IsCurrentLangaugeArabic)
    {
        eventDetailsLabel.textAlignment = NSTextAlignmentRight;
    }
    CGFloat width = eventDetailsLabel.frame.size.width;
    [eventDetailsLabel sizeToFit];
    CGRect afrme = eventDetailsLabel.frame;
    afrme.size.width = width;
    eventDetailsLabel.frame = afrme;
    
    CGRect frame = locationMapView.frame;
    frame.origin.y = eventDetailsLabel.frame.size.height + eventDetailsLabel.frame.origin.y + 10;
    frame.size.height = 108;
    locationMapView.frame = frame;
    contentScrollView.contentSize = CGSizeMake(0, frame.origin.y + frame.size.height + 5);
    
    [locationMapView addAnnotation:currentEvent];
    [locationMapView setRegion:MKCoordinateRegionMakeWithDistance(currentEvent.coordinate, 500, 500)];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    [view setImage:[UIImage imageNamed:@"maprMarker"]];
    view.canShowCallout = NO;
    return view;
}

- (IBAction)mapViewTapped:(id)sender
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate = currentEvent.coordinate;
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:currentEvent.eventTitle];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }

}
@end
