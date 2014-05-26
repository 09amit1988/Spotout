//
//  PlaceDetailViewController.h
//  Lifester
//
//  Created by MAC240 on 3/24/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"
#import "PictureListingOverlay.h"
#import "RootViewDelegate.h"
#import "FSVenue.h"
#import "DYRateView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "SFAnnotation.h"

@interface PlaceDetailViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, RootViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imvLocation;
    IBOutlet UILabel *lblLocationName;
    IBOutlet UILabel *lblLocationType;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress2;
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *lblPictureCount;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *imvLineCenter;
    
    int slide;
}
@property (nonatomic, retain) FSVenue *venue;
@property (nonatomic, retain) CLLocation *currentLocation;


- (IBAction)btnMapSelectAction:(id)sender;
- (IBAction)btnShowPictureListingOverlayAction:(id)sender;
- (IBAction)btnDirectionAction:(id)sender;

@end
