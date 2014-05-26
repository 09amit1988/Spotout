//
//  LocationDetailViewController.m
//  Lifester
//
//  Created by MAC240 on 3/11/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "RateProfileCell.h"
#import "SFAnnotation.h"
#import "MapViewController.h"
#import "JSON.h"
#import "Reachability.h"
#import "RatePlaceComment.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController

@synthesize lifeFeedPost;
//@synthesize venue;
@synthesize currentLocation;
@synthesize arrAllPhoto;
@synthesize arrComments;

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

//+ (CGFloat)annotationPadding;
//{
//    return 10.0f;
//}
//+ (CGFloat)calloutHeight;
//{
//    return 40.0f;
//}

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
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.arrAllPhoto = [[NSMutableArray alloc] init];
    self.arrComments = [[NSMutableArray alloc] init];
    
    DYRateView *rateview = [[DYRateView alloc] initWithFrame:CGRectMake(10, 56, 125, 30) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview.alignment = RateViewAlignmentLeft;
    rateview.editable = NO;
    rateview.delegate = self;
    rateview.rate = self.lifeFeedPost.averageRating;
    [detailView addSubview:rateview];
    
    lblLocationName.text = self.lifeFeedPost.locationName;
    [[mapView layer] setCornerRadius:2];
    
    if (lifeFeedPost.isAlreadyRated) {
        [imvDoneArrow setHidden:NO];
        [imvRatePlace setHidden:YES];
        [btnRatePlace setTitle:@"" forState:UIControlStateNormal];
        [btnRatePlace setTitle:@"" forState:UIControlStateHighlighted];
        [btnRatePlace setAlpha:0.65];
    } else {
        [imvDoneArrow setHidden:YES];
        [imvRatePlace setHidden:NO];
        [btnRatePlace setTitle:@"Rate Place" forState:UIControlStateNormal];
        [btnRatePlace setTitle:@"Rate Place" forState:UIControlStateHighlighted];
        [btnRatePlace setAlpha:1.0];
    }
    btnRatePlace.enabled = NO;
    
    //headerView.backgroundColor = [UIColor  colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    tblComments.tableHeaderView = headerView;
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    [self updateUI];
    
    [self setupMenuBarButtonItems];
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:self.lifeFeedPost.locationName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    
    imvLineCenter.frame = CGRectMake(imvLineCenter.frame.origin.x, imvLineCenter.frame.origin.y, imvLineCenter.frame.size.width, 0.7);
    imvLineBottom.frame = CGRectMake(imvLineBottom.frame.origin.x, imvLineBottom.frame.origin.y, imvLineBottom.frame.size.width, 0.7);
}

- (void)updateUI
{
    lblLocationType.text = lifeFeedPost.categoryType;
    lblAddress1.text = lifeFeedPost.address;
    if ([lifeFeedPost.state length]) {
        lblAddress2.text = [NSString stringWithFormat:@"%@, %@", lifeFeedPost.city, lifeFeedPost.state];
    } else {
        lblAddress2.text = [NSString stringWithFormat:@"%@", lifeFeedPost.city];
    }
    
    if (self.lifeFeedPost.isSharePicture) {
        [self.arrAllPhoto addObjectsFromArray:self.lifeFeedPost.arrPictures];
    }
    
    if ([self.arrAllPhoto count] > 0) {
        imvLocation.imageURL = [NSURL URLWithString:[self.arrAllPhoto objectAtIndex:0]];
        
        slide = 0;
        [NSTimer scheduledTimerWithTimeInterval:6.0
                                         target: self
                                       selector: @selector(changeSlideImage)
                                       userInfo: nil
                                        repeats: YES];
    } else {
        imvLocation.image = [UIImage imageNamed:@"Thumbnailimg1.jpeg"];
    }
    
    lblPictureCount.text = [NSString stringWithFormat:@"%d",self.arrAllPhoto.count];
    pageControl.numberOfPages = [self.arrAllPhoto count];
    
    SFAnnotation *sfAnnotation = [[SFAnnotation alloc] init];
    sfAnnotation.latitude = [NSNumber numberWithDouble:lifeFeedPost.latitude];
    sfAnnotation.longitude = [NSNumber numberWithDouble:lifeFeedPost.longitude];
    [mapView addAnnotation:sfAnnotation];
    
    // start off by default location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = lifeFeedPost.latitude;
    newRegion.center.longitude = lifeFeedPost.longitude;
    newRegion.span.latitudeDelta = 0.005; // 0.912872
    newRegion.span.longitudeDelta = 0.005; // 0.909863
    [mapView setRegion:newRegion animated:YES];
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.hidesBackButton = YES;
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
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%lf,%lf&daddr=%lf,%lf",currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, lifeFeedPost.latitude, lifeFeedPost.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (IBAction)btnInviteFriendAction:(id)sender
{
    
}

- (IBAction)btnRatePlaceAction:(id)sender
{
    if (lifeFeedPost.isAlreadyRated) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Are you sure that you want to remove rating ?"
                                                       delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
        [alert release];
    } else {
        [AddPlaceRatingOverlay showAlert:self.lifeFeedPost delegate:self withParentView:self.view withTag:1];
    }
}

- (IBAction)btnShowPictureListingOverlayAction:(id)sender
{
    [PictureListingOverlay showAlert:self.arrAllPhoto delegate:self withTag:1 currentIndex:slide];
}

- (IBAction)btnMapSelectAction:(id)sender
{
    MapViewController *viewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
    viewController.lifeFeedPost = self.lifeFeedPost;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self callDeletePlaceRatingService:lifeFeedPost.placeReviewID];
    }
}

#pragma mark - Custom Metohd

- (void)changeSlideImage
{
    slide++;
    if(slide >= [self.arrAllPhoto count])//an array count perhaps
        slide = 0;
    
    [UIView transitionWithView:imvLocation
                      duration:1.75f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        imvLocation.imageURL = [NSURL URLWithString:[self.arrAllPhoto objectAtIndex:slide]];
                        pageControl.currentPage = slide;
                    } completion:NULL];
    
}
/*
- (void)getVenueDetailUsingFoursquare
{
    [appDelegate showActivity:self.view showOrHide:YES];
    [Foursquare2 venueGetDetail:lifeFeedPost.foursquareVenueID callback:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dict = result;
            FSConverter *converter = [[FSConverter alloc]init];
            self.venue = [converter convertObjectToVenue:[[dict valueForKey:@"response"] valueForKey:@"venue"] currentLocation:nil];
            
            lblLocationType.text = venue.categoryType;
            lblAddress1.text = venue.location.address;
            lblAddress2.text = venue.location.city;
            
            if (self.lifeFeedPost.isSharePicture) {
                [self.arrAllPhoto addObjectsFromArray:self.lifeFeedPost.arrPictures];
            }
            
            if ([self.venue.arrPhotos count] > 0) {
                [self.arrAllPhoto addObjectsFromArray:venue.arrPhotos];
            }
            
            if ([self.arrAllPhoto count] > 0) {
                imvLocation.imageURL = [NSURL URLWithString:[self.arrAllPhoto objectAtIndex:0]];
                
                slide = 0;
                [NSTimer scheduledTimerWithTimeInterval:6.0
                                                 target: self
                                               selector: @selector(changeSlideImage)
                                               userInfo: nil
                                                repeats: YES];
            } else {
                imvLocation.image = [UIImage imageNamed:@"Thumbnailimg1.jpeg"];
            }
            
            lblPictureCount.text = [NSString stringWithFormat:@"%d",self.arrAllPhoto.count];
            pageControl.numberOfPages = [self.arrAllPhoto count];
            
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
            
            [self callGetPlaceRatingWebService];
            
            //[appDelegate showActivity:self.view showOrHide:NO];
        } else {
            [self callGetPlaceRatingWebService];
//            [appDelegate showActivity:self.view showOrHide:NO];
        }
    }];
}
*/

- (void)callGetPlaceRatingWebService
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    flag = 1;
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"get_place_rating" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[NSString stringWithFormat:@"%@", self.lifeFeedPost.placeReviewID] forKey:@"place_review_id"];
//    [request setPostValue:@"224" forKey:@"places_review_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)callDeletePlaceRatingService:(NSNumber *)placeReviewID
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [appDelegate showActivity:self.view showOrHide:YES];
    flag = 2;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"delete_place_rating" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:placeReviewID forKey:@"place_review_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *receivedString = [request responseString];
    
    NSDictionary *responseObject = [receivedString JSONValue];
    NSDictionary *items = [responseObject objectForKey:@"raws"];
    
    if (flag == 1) {
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Time Line"]) {
            @try {
                NSMutableArray *arrTemp = [[[items valueForKey:@"status"] valueForKey:@"data"] objectAtIndex:0];
                [self.arrComments removeAllObjects];
                [tblComments reloadData];
                
                for (NSMutableDictionary *dictData in arrTemp) {
                    RatePlaceComment *placeComment = [[RatePlaceComment alloc] initWithDictionary:dictData];
                    int index = [self.arrComments count];
                    [self.arrComments addObject:placeComment];
                    
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:index inSection:0]; //ALSO TRIED WITH indexPathRow:0
                    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
                    [tblComments insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Exception ==== %@", exception);
            }
            @finally {
                
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    } else if (flag == 2) {
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Deleted Successfully"]) {
            self.lifeFeedPost.averageRating = [[items valueForKey:@"Average_rating"] floatValue];
            self.lifeFeedPost.isAlreadyRated = NO;
            
            [imvDoneArrow setHidden:YES];
            [imvRatePlace setHidden:NO];
            [btnRatePlace setTitle:@"Rate Place" forState:UIControlStateNormal];
            [btnRatePlace setTitle:@"Rate Place" forState:UIControlStateHighlighted];
            [btnRatePlace setAlpha:1.0];
            
            [self callGetPlaceRatingWebService];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    
    [appDelegate showActivity:self.view showOrHide:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [appDelegate showActivity:self.view showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
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



#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrComments count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simple=@"Simple";
    RateProfileCell *cell = (RateProfileCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RateProfileCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    
    RatePlaceComment *placeComment = [self.arrComments objectAtIndex:indexPath.row];
    
    DYRateView *rateview1 = [[DYRateView alloc] initWithFrame:CGRectMake(55, 35, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview1.editable = NO;
    rateview1.rate = placeComment.rating;
    [cell addSubview:rateview1];
    
    
    if (placeComment.hasProfilePicture) {
        cell.imvProfileUser.imageURL = [NSURL URLWithString:placeComment.profileImagePath];
    } else {
        cell.imvProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    cell.lblUserName.text = placeComment.username;
    cell.lblComment.text = placeComment.comment;
    cell.lblTimeDifference.text = placeComment.timeDifference;
    
    
    
    if ([placeComment.comment length] > 0) {
        [cell.lblComment setHidden:NO];
        float height = [placeComment.comment RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
        CGRect frame = CGRectMake(cell.lblComment.frame.origin.x, cell.lblComment.frame.origin.y, cell.lblComment.frame.size.width, height);
        cell.lblComment.frame = frame;
        
        float yOrigin = height + cell.lblComment.frame.origin.y;
        cell.imvClockIcon.frame = CGRectMake(cell.imvClockIcon.frame.origin.x, yOrigin+6.0, cell.imvClockIcon.frame.size.width, cell.imvClockIcon.frame.size.height);
        cell.lblTimeDifference.frame = CGRectMake(cell.lblTimeDifference.frame.origin.x, yOrigin, cell.lblTimeDifference.frame.size.width, cell.lblTimeDifference.frame.size.height);
    } else {
        [cell.lblComment setHidden:YES];
        
        float yOrigin = 53;
        cell.imvClockIcon.frame = CGRectMake(cell.imvClockIcon.frame.origin.x, yOrigin+6.0, cell.imvClockIcon.frame.size.width, cell.imvClockIcon.frame.size.height);
        cell.lblTimeDifference.frame = CGRectMake(cell.lblTimeDifference.frame.origin.x, yOrigin, cell.lblTimeDifference.frame.size.width, cell.lblTimeDifference.frame.size.height);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 153.0;
    RatePlaceComment *placeComment = [self.arrComments objectAtIndex:indexPath.row];
    if ([placeComment.comment length] > 0) {
        float height = [placeComment.comment RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
        return height + 78.0;
    } else {
        return 78.0;
    }
}

#pragma mark - Rootview Delegate

-(void)AlertDialogDidComplete:(id)view
{
    if ([view isKindOfClass:[AddPlaceRatingOverlay class]]) {
        AddPlaceRatingOverlay *overlay = (AddPlaceRatingOverlay*)view;
        self.lifeFeedPost.averageRating = overlay.averageRating;
        self.lifeFeedPost.isAlreadyRated = YES;
        
        [imvDoneArrow setHidden:NO];
        [imvRatePlace setHidden:YES];
        [btnRatePlace setTitle:@"" forState:UIControlStateNormal];
        [btnRatePlace setTitle:@"" forState:UIControlStateHighlighted];
        [btnRatePlace setAlpha:0.65];
        
        [self callGetPlaceRatingWebService];
    }
}

-(void)AlertDialogDidNotComplete:(id)view
{
    
}


@end
