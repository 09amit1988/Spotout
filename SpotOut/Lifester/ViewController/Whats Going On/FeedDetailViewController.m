//
//  FeedDetailViewController.m
//  Lifester
//
//  Created by MAC240 on 4/10/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "JSON.h"
#import "LocationDetailViewController.h"


@interface FeedDetailViewController ()

@end


@implementation FeedDetailViewController

@synthesize feedPost;
@synthesize lifeFeedID;
@synthesize currentLocation;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.feedPost = nil;
    self.currentLocation = nil;
    locationManager = nil;
}

- (void)dealloc
{
    [super dealloc];
    
    locationManager.delegate = nil;
    [locationManager release];
    [scrollView release];
    [profileView release];
}


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
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Feed Detail"];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 685);
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    [self callLifeFeedDetailService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [[likeCommentView layer] setBorderWidth:0.7];
    [[likeCommentView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItems = [self leftMenuBarButtonItem];
}

- (NSArray *)leftMenuBarButtonItem {
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = 0;
    
    UIButton *btnMainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMainMenu setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [btnMainMenu addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnMainMenu.frame = CGRectMake(0, 0, 13, 22);
    
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnMainMenu] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, backButtonItem, nil];
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"people-near-you-icon.png"] forState:UIControlStateNormal];
    rightbtn.frame = CGRectMake(0, 0, 25, 22);
    [rightbtn addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:rightbtn] ;
}

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    
}

#pragma mark - Current Location Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

#pragma mark - UIButton Action

- (void)btnFirstLocationNameAction:(id)sender
{
    LocationDetailViewController *viewController = [[[LocationDetailViewController alloc] initWithNibName:@"LocationDetailViewController" bundle:nil] autorelease];
    viewController.lifeFeedPost = self.feedPost;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)btnPlacePostImageAction:(id)sender
{
    [PictureListingOverlay showAlert:feedPost.arrPictures delegate:self withTag:1 currentIndex:0];
}

- (void)btnLinkAction:(id)sender
{
    NSString *link = feedPost.link;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://"]])
    {
        NSString *str = link;
        if ([str rangeOfString:@"http"].location == NSNotFound) {
            NSString *webURL= [NSString stringWithFormat:@"http://%@",str];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
        } else {
            NSString *webURL= [NSString stringWithFormat:@"%@",str];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please check Your Internet Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)btnRatePlaceAction:(id)sender
{
    if (feedPost.isAlreadyRated) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Are you sure that you want to remove rating ?"
                                                       delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
        [alert release];
    } else {
        [AddPlaceRatingOverlay showAlert:feedPost delegate:self withParentView:self.view withTag:1];
    }
}

- (IBAction)btnLikeAction:(id)sender
{
    
}

- (IBAction)btnCommentAction:(id)sender
{
    
}

- (IBAction)btnShareAction:(id)sender
{
    
}

- (IBAction)btnRePostAction:(id)sender
{
    
}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"YES");
        [self callDeletePlaceRatingService:feedPost.placeReviewID];
    }
}

#pragma mark - Custom Methods

- (void)updateUIPerFeedType
{
    DYRateView *rateview = [[DYRateView alloc] initWithFrame:CGRectMake(56, 32, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview.editable = NO;
    rateview.rate = self.feedPost.profileRating;
    [profileView addSubview:rateview];
    
    [imvProfileUser setClipsToBounds: YES];
    [[imvProfileUser layer] setMasksToBounds:YES];
    [[imvProfileUser layer] setCornerRadius:imvProfileUser.frame.size.width/2.0];
    if (feedPost.hasProfilePicture) {
        imvProfileUser.imageURL = [NSURL URLWithString:feedPost.profileImagePath];
    } else {
        imvProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    lblProfileName.text = feedPost.profileName;
    lblDescription.text = feedPost.description;
    lblDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0];
    lblFeedPostTime.text = feedPost.timeDifference;
    
    if ([feedPost.arrPictures count] > 0) {
        imvFeedPost.imageURL = [NSURL URLWithString:[feedPost.arrPictures objectAtIndex:0]];
        [btnFeedPostImage addTarget:self action:@selector(btnPlacePostImageAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        imvFeedPost.image = [UIImage imageNamed:@"Thumbnailimg1.jpeg"];
    }
    
    lblPictureCount.text = [NSString stringWithFormat:@"%d",feedPost.arrPictures.count];
    [btnLink setTitle:feedPost.link forState:UIControlStateNormal];
    [btnLink setTitle:feedPost.link forState:UIControlStateHighlighted];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:feedPost.latitude longitude:feedPost.longitude];
    float meters = [self.currentLocation distanceFromLocation:loc];
    if (meters < 100) {
        lblDistanceFromLocation.text = [NSString stringWithFormat:@"Just away"];
    } else if (meters >= 1000) {
        lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.f km away", meters/1000];
    } else {
        lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.1f km away", roundf(meters)/1000];
    }
    
    NSString *category = @"";
    for (int i = 0; i < [feedPost.arrTags count]; i++) {
        NSDictionary *dictCategory = [feedPost.arrTags objectAtIndex:i];
        if (i == [feedPost.arrTags count]-1) {
            category = [category stringByAppendingFormat:@"%@", [dictCategory objectForKey:@"name"]];
        } else {
            category = [category stringByAppendingFormat:@"%@   ", [dictCategory objectForKey:@"name"]];
        }
    }
    lblTagNames.text = category;
    
    float height = [feedPost.description RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
    lblDescription.numberOfLines = 0;
    CGRect frame = CGRectMake(lblDescription.frame.origin.x, lblDescription.frame.origin.y, lblDescription.frame.size.width, height);
    lblDescription.frame = frame;
    
    float yValue = lblDescription.frame.origin.y + lblDescription.frame.size.height;
    if ([feedPost.link length] > 0) {
        btnLink.frame = CGRectMake(btnLink.frame.origin.x, yValue-3, btnLink.frame.size.width, btnLink.frame.size.height);
        yValue = yValue + btnLink.frame.size.height;
        [btnLink  setHidden:NO];
    } else {
        [btnLink  setHidden:YES];
    }
    [btnLink addTarget:self action:@selector(btnLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    lblLocationName.text = feedPost.locationName;
    lblCategoryType.text = feedPost.categoryType;
    lblLocationAdress.text = feedPost.address;
    if ([feedPost.state length]) {
        lblLocationCity.text = [NSString stringWithFormat:@"%@, %@", feedPost.city, feedPost.state];
    } else {
        lblLocationCity.text = [NSString stringWithFormat:@"%@", feedPost.city];
    }
    
    yValue = yValue + 3;
    postDescView.frame = CGRectMake(postDescView.frame.origin.x, postDescView.frame.origin.y, postDescView.frame.size.width, yValue);
    
    yValue = yValue + postDescView.frame.size.height;

    
    float yOrigin = 0;
    
    if (feedPost.feedType == ACTIVITY_TYPE) {
        imvFeedType.image = [UIImage imageNamed:@"activity-post-icon.png"];
        
        lblPostTitle.text = feedPost.eventName;
        lblPostPrice.text = feedPost.locationName;
        lblPostLocationType.text = feedPost.categoryType;
        
//        placeRateView = [[DYRateView alloc] initWithFrame:CGRectMake(87, 168, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
//        placeRateView.editable = NO;
//        placeRateView.rate = feedPost.averageRating;
//        [shareImageView addSubview:placeRateView];
        
        yOrigin = postDescView.frame.origin.y + postDescView.frame.size.height;
        [scrollView addSubview:locationView];
        locationView.frame = CGRectMake(locationView.frame.origin.x, yOrigin, locationView.frame.size.width, locationView.frame.size.height);
        
        imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
        yOrigin = yOrigin + locationView.frame.size.height;
        
        [scrollView addSubview:inviteFriendView];
        inviteFriendView.frame = CGRectMake(inviteFriendView.frame.origin.x, yOrigin, inviteFriendView.frame.size.width, inviteFriendView.frame.size.height);
        
        yOrigin = yOrigin + inviteFriendView.frame.size.height;
        
        lblLocationName.textColor = [UIColor colorWithRed:129.0/255.0 green:197.0/255.0 blue:102.0/255.0 alpha:1.0];
        lblCategoryType.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0];
        lblLocationAdress.textColor = [UIColor colorWithRed:129.0/255.0 green:197.0/255.0 blue:102.0/255.0 alpha:1.0];
        lblLocationCity.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0];
        
    } else if (feedPost.feedType == OFFER_TYPE){
        imvFeedType.image = [UIImage imageNamed:@"offer-post-icon.png"];
        
        lblPostTitle.text = feedPost.eventName;
        lblPostPrice.text = feedPost.price;
        
        NSString *eventTime = @"";
        if ([feedPost.eventStartTime length] > 0) {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *start = [dateFormatter dateFromString:feedPost.eventStartTime];
            [dateFormatter setDateFormat:@"MMM dd, hh:mm a"];
            eventTime = [eventTime stringByAppendingFormat:@"%@", [dateFormatter stringFromDate:start]];
        }
        
        if ([feedPost.eventEndTime length] > 0) {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *end = [dateFormatter dateFromString:feedPost.eventEndTime];
            [dateFormatter setDateFormat:@"MMM dd, hh:mm a"];
            eventTime = [eventTime stringByAppendingFormat:@" - %@", [dateFormatter stringFromDate:end]];
        }
        lblPostLocationType.text = eventTime;

        yOrigin = postDescView.frame.origin.y + postDescView.frame.size.height;
        [scrollView addSubview:locationView];
        locationView.frame = CGRectMake(locationView.frame.origin.x, yOrigin, locationView.frame.size.width, locationView.frame.size.height);
        
        imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
        yOrigin = (yOrigin + locationView.frame.size.height);
        
        
        [scrollView addSubview:inviteFriendView];
        inviteFriendView.frame = CGRectMake(inviteFriendView.frame.origin.x, yOrigin, inviteFriendView.frame.size.width, inviteFriendView.frame.size.height);
        
        yOrigin = yOrigin + inviteFriendView.frame.size.height;
        
        lblLocationName.textColor = [UIColor colorWithRed:235.0/255.0 green:86.0/255.0 blue:64.0/255.0 alpha:1.0];
        lblCategoryType.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0];
        lblLocationAdress.textColor = [UIColor colorWithRed:235.0/255.0 green:86.0/255.0 blue:64.0/255.0 alpha:1.0];
        lblLocationCity.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0];
        
    } else if (feedPost.feedType == EVENT_TYPE) {
        imvFeedType.image = [UIImage imageNamed:@"event-post-icon.png"];
        
        lblPostTitle.text = feedPost.eventName;
        
        NSString *eventTime = @"";
        if ([feedPost.eventStartTime length] > 0) {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *start = [dateFormatter dateFromString:feedPost.eventStartTime];
            [dateFormatter setDateFormat:@"MMM dd, hh:mm a"];
            eventTime = [eventTime stringByAppendingFormat:@"%@", [dateFormatter stringFromDate:start]];
        }
        
        if ([feedPost.eventEndTime length] > 0) {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *end = [dateFormatter dateFromString:feedPost.eventEndTime];
            [dateFormatter setDateFormat:@"MMM dd, hh:mm a"];
            eventTime = [eventTime stringByAppendingFormat:@" - %@", [dateFormatter stringFromDate:end]];
        }
        lblPostPrice.text = eventTime;
        
        yOrigin = postDescView.frame.origin.y + postDescView.frame.size.height;
        [scrollView addSubview:ticketView];
        
        float yLabelOrigin = 4;
        for (int i = 0; i < [feedPost.arrTickets count]; i++) {
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, yLabelOrigin, 300, 44)] autorelease];
            imageView.image = [UIImage imageNamed:@"ticket-post-box.png"];
            [ticketView addSubview:imageView];
            
            NSDictionary *dict = [feedPost.arrTickets objectAtIndex:i];
            
            UILabel *lblTicket = [[[UILabel alloc] initWithFrame:CGRectMake(46, yLabelOrigin, 229, 44)] autorelease];
            lblTicket.text = [NSString stringWithFormat:@"%@: %@ %@", [dict objectForKey:@"ticketName"], [dict objectForKey:@"price"], [dict objectForKey:@"currency"]];
            [lblTicket setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
            [lblTicket setTextColor:[UIColor whiteColor]];
            lblTicket.numberOfLines = 2;
            lblTicket.textAlignment = NSTextAlignmentCenter;
            
            [ticketView addSubview:lblTicket];
            yLabelOrigin = yLabelOrigin + lblTicket.frame.size.height + 8;
            
            lblPostLocationType.text = @"Tickets available";
        }
        
        if ([feedPost.arrTickets count] == 0) {
            float yLabelOrigin = 4;
            UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, yLabelOrigin, 300, 44)] autorelease];
            imageView.image = [UIImage imageNamed:@"ticket-post-box.png"];
            [ticketView addSubview:imageView];
            
            UILabel *lblTicket = [[[UILabel alloc] initWithFrame:CGRectMake(46, yLabelOrigin, 229, 44)] autorelease];
            lblTicket.text = @"Tickets are not available";
            [lblTicket setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
            [lblTicket setTextColor:[UIColor whiteColor]];
            lblTicket.numberOfLines = 2;
            lblTicket.textAlignment = NSTextAlignmentCenter;
            
            [ticketView addSubview:lblTicket];
            yLabelOrigin = yLabelOrigin + lblTicket.frame.size.height + 8;
            
            lblPostLocationType.text = @"Tickets are not available";
        }
        
        ticketView.frame = CGRectMake(ticketView.frame.origin.x, yOrigin, ticketView.frame.size.width, yLabelOrigin);
        yOrigin = yOrigin + ticketView.frame.size.height;
        
        [scrollView addSubview:locationView];
        locationView.frame = CGRectMake(locationView.frame.origin.x, yOrigin, locationView.frame.size.width, locationView.frame.size.height);
        imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
        
        yOrigin = yOrigin + locationView.frame.size.height;
        [scrollView addSubview:inviteFriendView];
        inviteFriendView.frame = CGRectMake(inviteFriendView.frame.origin.x, yOrigin, inviteFriendView.frame.size.width, inviteFriendView.frame.size.height);
        
        yOrigin = yOrigin + inviteFriendView.frame.size.height;
        
        lblLocationName.textColor = [UIColor colorWithRed:158.0/255.0 green:117.0/255.0 blue:153.0/255.0 alpha:1.0];
        lblCategoryType.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0];
        lblLocationAdress.textColor = [UIColor colorWithRed:158.0/255.0 green:117.0/255.0 blue:153.0/255.0 alpha:1.0];
        lblLocationCity.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1.0];
        
    }
    
    [mapview setDelegate:self];
    [[mapview layer] setCornerRadius:2];
    SFAnnotation *sfAnnotation = [[SFAnnotation alloc] init];
    sfAnnotation.latitude = [NSNumber numberWithDouble:feedPost.latitude];
    sfAnnotation.longitude = [NSNumber numberWithDouble:feedPost.longitude];
    [mapview addAnnotation:sfAnnotation];
    
    // start off by default location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = feedPost.latitude;
    newRegion.center.longitude = feedPost.longitude;
    newRegion.span.latitudeDelta = 0.005; // 0.912872
    newRegion.span.longitudeDelta = 0.005; // 0.909863
    [mapview setRegion:newRegion animated:YES];
    
    //imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
    

    [scrollView addSubview:likeCommentView];
    likeCommentView.frame = CGRectMake(likeCommentView.frame.origin.x, yOrigin, likeCommentView.frame.size.width, likeCommentView.frame.size.height);
    
    yOrigin = yOrigin + likeCommentView.frame.size.height;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, yOrigin);

}

#pragma mark - MapView Delegates

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
        (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        if (!pinView)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = NO;
            
            UIImage *flagImage = nil;
            
            switch (feedPost.feedType) {
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

#pragma mark - Web service call Methods

- (void)callLifeFeedDetailService
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
    flag = 1;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"feed_post_detail" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[NSString stringWithFormat:@"%d", self.lifeFeedID] forKey:@"feed_post_id"];
    
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
                if ([arrTemp count] > 0) {
                    self.feedPost = [[LifeFeedPost alloc] initWithDictionary:[arrTemp objectAtIndex:0]];
                    [self updateUIPerFeedType];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Exception ==== %@", exception);
            }
            @finally {
                
            }
        } else if ([items isKindOfClass:[NSNull class]]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:@"No Network." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    } else if (flag == 2) {
        // Parse response of Delete Place Rating
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Deleted Successfully"]) {
            feedPost.averageRating = [[items valueForKey:@"Average_rating"] floatValue];
            feedPost.isAlreadyRated = NO;
            
            placeRateView.rate = feedPost.averageRating;
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

#pragma mark - Rootview Delegate

-(void)AlertDialogDidComplete:(id)view
{
    if ([view isKindOfClass:[AddPlaceRatingOverlay class]]) {
        AddPlaceRatingOverlay *overlay = (AddPlaceRatingOverlay*)view;
        
        feedPost.averageRating = overlay.averageRating;
        feedPost.isAlreadyRated = YES;
     
        placeRateView.rate = feedPost.averageRating;
    }
}

-(void)AlertDialogDidNotComplete:(id)view
{
    
}

@end
