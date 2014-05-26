//
//  MapViewController.m
//  Lifester
//
//  Created by MAC240 on 3/14/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "MapViewController.h"
#import "SFAnnotation.h"


@interface MapViewController ()

@end

@implementation MapViewController

@synthesize currentLocation;
@synthesize lifeFeedPost;


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self viewDidUnload];
    self.currentLocation = nil;
    self.lifeFeedPost = nil;
}

- (void)dealloc
{
    [super dealloc];
    [currentLocation release];
    [lifeFeedPost release];
    
    locationManager.delegate = nil;
    [locationManager release];
    mapView.delegate = nil;
    [mapView release];
}

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:self.lifeFeedPost.locationName];
    mapView.showsUserLocation = YES;
    [self setupMenuBarButtonItems];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
//    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//    MKUserTrackingBarButtonItem *trackButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:mapView];
//    [trackButton setTarget:self];
//    //[trackButton setAction:@selector(startShowingUserHeading:)];
//    [trackButton setAction:@selector(startShowingUserHeading:)];
//    
//    [toolbar setItems:[NSArray arrayWithObjects:flexSpace, trackButton, nil] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    
    SFAnnotation *sfAnnotation = [[SFAnnotation alloc] init];
    sfAnnotation.latitude = [NSNumber numberWithDouble:lifeFeedPost.latitude];
    sfAnnotation.longitude = [NSNumber numberWithDouble:lifeFeedPost.longitude];
    sfAnnotation.title = self.lifeFeedPost.locationName;
    
    NSString *subtitle = @"";
    if (self.lifeFeedPost.address) {
        subtitle = [subtitle stringByAppendingFormat:@"%@", self.lifeFeedPost.address];
    }
    if (self.lifeFeedPost.city) {
        subtitle = [subtitle stringByAppendingFormat:@", %@", self.lifeFeedPost.city];
    }
    
    sfAnnotation.subtitle = subtitle;
    [mapView addAnnotation:sfAnnotation];
    
    // start off by default location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.lifeFeedPost.latitude;
    newRegion.center.longitude = self.lifeFeedPost.longitude;
    newRegion.span.latitudeDelta = 0.005; // 0.912872
    newRegion.span.longitudeDelta = 0.005; // 0.909863
    [mapView setRegion:newRegion animated:YES];
    
    [mapView selectAnnotation:sfAnnotation animated:YES];
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItems = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(0, 0, 13, 22);
    return [[UIBarButtonItem alloc] initWithCustomView:btnBack];
}

- (NSArray *)rightMenuBarButtonItem {
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 6, 80, 32);
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDone setTitle:@"Directions" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [btnDone addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnDone] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
}

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%lf,%lf&daddr=%lf,%lf",currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, self.lifeFeedPost.latitude, self.lifeFeedPost.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

#pragma mark - UIButton Methods



#pragma mark - Custom Method


#pragma mark - MKMapViewDelegate

//- (IBAction)startShowingUserHeading:(id)sender
//{
//    if (mapView.userTrackingMode == 0) {
//        [mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
//    } else if (mapView.userTrackingMode == 1) {
//        [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    } else if (mapView.userTrackingMode == 2) {
//        [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
//    }
//}
//
//- (void)mapView:(MKMapView *)mapView1 didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
//{
//    if (mapView.userTrackingMode == 0) {
//        [mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
//    } else if (mapView.userTrackingMode == 1) {
//        [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    } else if (mapView.userTrackingMode == 2) {
//        [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
//    }
//}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[SFAnnotation class]])   // for City of San Francisco
    {
        static NSString* SFAnnotationIdentifier = @"SFAnnotationIdentifier";
        MKPinAnnotationView* pinView =
        (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        if (!pinView)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            
            UIImage *flagImage = nil;
            
            switch (lifeFeedPost.feedType) {
                case ACTIVITY_TYPE:
                    flagImage = [UIImage imageNamed:@"map-icon-activity.png"];
                    break;
                case OFFER_TYPE:
                    flagImage = [UIImage imageNamed:@"map-icon-offer.png"];
                    break;
                case EVENT_TYPE:
                    flagImage = [UIImage imageNamed:@"map-icon-event.png"];
                    break;
                default:
                    break;
            }
            
            annotationView.image = flagImage;
            annotationView.opaque = NO;
            
            UIImage *shadowImage = [UIImage imageNamed:@"map-icon-shadow.png"];
            UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map-icon-shadow.png"]] autorelease];
            imageView.frame = CGRectMake(6.0, 32.5, shadowImage.size.width, shadowImage.size.height);
            [annotationView addSubview:imageView];
            
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}


@end
