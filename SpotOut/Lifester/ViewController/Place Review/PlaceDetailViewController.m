//
//  PlaceDetailViewController.m
//  Lifester
//
//  Created by MAC240 on 3/24/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "MapViewController.h"


@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

@synthesize venue;
@synthesize currentLocation;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
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
    
    [self setupMenuBarButtonItems];
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:self.venue.name];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = YES;
    [[mapView layer] setCornerRadius:2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    imvLineCenter.frame = CGRectMake(imvLineCenter.frame.origin.x, imvLineCenter.frame.origin.y, imvLineCenter.frame.size.width, 0.7);
    
    if (self.venue) {
        lblLocationName.text = venue.name;
        lblLocationType.text = venue.categoryType;
        lblAddress1.text = venue.location.address;
        lblAddress2.text = venue.location.city;
  
        if ([venue.arrPhotos count] > 0) {
            [IconDownloader loadImageFromLink:[venue.arrPhotos objectAtIndex:0] forImageView:imvLocation withPlaceholder:nil andContentMode:UIViewContentModeScaleAspectFill];
            
            slide = 0;
            [NSTimer scheduledTimerWithTimeInterval:6.0
                                             target: self
                                           selector: @selector(changeSlideImage)
                                           userInfo: nil
                                            repeats: YES];
        } else {
            imvLocation.image = [UIImage imageNamed:@"Thumbnailimg1.jpeg"];
        }
        
        lblPictureCount.text = [NSString stringWithFormat:@"%d",venue.arrPhotos.count];
        pageControl.numberOfPages = [venue.arrPhotos count];
        
        DYRateView *rateview = [[DYRateView alloc] initWithFrame:CGRectMake(10, 255, 125, 30) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
        rateview.alignment = RateViewAlignmentLeft;
        rateview.editable = NO;
//        rateview.delegate = self;
        rateview.rate = [venue.rating floatValue];
        [scrollView addSubview:rateview];
        
        SFAnnotation *sfAnnotation = [[SFAnnotation alloc] init];
        sfAnnotation.latitude = [NSNumber numberWithDouble:venue.location.coordinate.latitude];
        sfAnnotation.longitude = [NSNumber numberWithDouble:venue.location.coordinate.longitude];
        [mapView addAnnotation:sfAnnotation];
        
        // start off by default location
        MKCoordinateRegion newRegion;
        newRegion.center.latitude = venue.location.coordinate.latitude;
        newRegion.center.longitude = venue.location.coordinate.longitude;
        newRegion.span.latitudeDelta = 0.005; // 0.912872
        newRegion.span.longitudeDelta = 0.005; // 0.909863
        [mapView setRegion:newRegion animated:YES];
    }
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.rightBarButtonItems = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(0, 0, 13, 22);
    return [[UIBarButtonItem alloc] initWithCustomView:btnBack] ;
}

- (NSArray *)rightMenuBarButtonItem {
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 6, 56, 32);
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone.titleLabel setTextColor:[UIColor whiteColor]];
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
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}


#pragma mark - UIButton Methods

- (IBAction)btnDirectionAction:(id)sender
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%lf,%lf&daddr=%lf,%lf",currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, self.venue.location.coordinate.latitude, self.venue.location.coordinate.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (IBAction)btnShowPictureListingOverlayAction:(id)sender
{
    [PictureListingOverlay showAlert:venue.arrPhotos delegate:self withTag:1 currentIndex:slide];
}

- (IBAction)btnMapSelectAction:(id)sender
{
//    MapViewController *viewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
//    viewController.lifeFeedPost = self.;
//    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Custom Methods

- (void)changeSlideImage
{
    slide++;
    if(slide >= [venue.arrPhotos count])//an array count perhaps
        slide = 0;
    
    [UIView transitionWithView:imvLocation
                      duration:1.75f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        imvLocation.imageURL = [NSURL URLWithString:[venue.arrPhotos objectAtIndex:slide]];
                        pageControl.currentPage = slide;
                    } completion:NULL];
    
}

#pragma mark - MKMapViewDelegate

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
            annotationView.canShowCallout = NO;
            
            UIImage *flagImage = [UIImage imageNamed:@"location_map_icon.png"];
            annotationView.image = flagImage;
            annotationView.opaque = NO;
            
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
