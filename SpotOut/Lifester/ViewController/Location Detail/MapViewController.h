//
//  MapViewController.h
//  Lifester
//
//  Created by MAC240 on 3/14/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FSVenue.h"
#import "LifeFeedPost.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet MKMapView *mapView;
}
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) LifeFeedPost *lifeFeedPost;

@end
