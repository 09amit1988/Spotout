//
//  AddLocation_IPhone5.m
//  Lifester
//
//  Created by App Developer on 28/02/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "AddLocation_IPhone5.h"
#import "Reachability.h"
#import "LocationCell.h"
#import "NSString+Extensions.h"
#import "JSON.h"


@interface AddLocation_IPhone5 ()

@end

@implementation AddLocation_IPhone5

@synthesize mapView,LocTable,footerActivityIndicator,footerView,nearbyVenues;
@synthesize currentLocation;
@synthesize iParentView;
@synthesize objAddEvent, objOfferView, objPhotoView;
@synthesize cityVenue;
@synthesize isComingFromSearchSection;
@synthesize objSearchView;
@synthesize objActivityView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cityVenue = [[FSVenue alloc] init];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    appDelegateObj.shouldRotate = YES;
    return UIInterfaceOrientationMaskAll;
}

-(void)dealloc {
    
    mapView.delegate = nil;
	[mapView release];
    
    [footerActivityIndicator release];
    [footerView release];
    
    [super dealloc];
}

-(void)viewDidUnload {
    
    self.mapView.delegate = nil;
	self.mapView = nil;
    
    self.footerView=nil;
    self.footerActivityIndicator=nil;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    
    CLGeocoder *fgeo = [[[CLGeocoder alloc] init] autorelease];
    
    // Reverse Geocode a CLLocation to a CLPlacemark
    [fgeo reverseGeocodeLocation:self.currentLocation
               completionHandler:^(NSArray *placemarks, NSError *error){
                   
                   // Make sure the geocoder did not produce an error
                   // before continuing
                   if(!error){
                       // Iterate through all of the placemarks returned
                       // and output them to the console
                       for(CLPlacemark *placemark in placemarks){
                           [self assignValueToVenueObject:placemark];
                       }
                   }
                   else{
                       // Our geocoder had an error, output a message
                       // to the console
                       NSLog(@"There was a reverse geocoding error\n%@",
                             [error localizedDescription]);
                   }
               }
     ];
    
    if (!isComingFromSearchSection) {
        [self getVenueSearchNearByLocation];
    }
    locationManager.delegate=nil;
}

- (void)assignValueToVenueObject:(CLPlacemark*)placemark
{
    self.cityVenue.name = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    
    [btnFindCity setTitle:self.cityVenue.name forState:UIControlStateNormal];
    [btnFindCity setTitle:self.cityVenue.name forState:UIControlStateHighlighted];
    
    NSString *address = [NSString stringWithFormat:@"%@", [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStateKey]];
    address = [address stringByAppendingFormat:@", %@", [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryKey]];
    self.cityVenue.location.address = address;
    self.cityVenue.location.city = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    self.cityVenue.location.state = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStateKey];
    self.cityVenue.location.country = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryKey];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tempResultArray = [[NSMutableArray alloc] init];
    backgroundView.backgroundColor = VIEW_COLOR;
    
    [btnBackCity setHidden:YES];
    pagetoken = pagetoken1 = @"";
    [NoLocationView setHidden:YES];
    
    appDelegateObj = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.nearbyVenues = [[NSMutableArray alloc] init];
    self.mapView.delegate = self;
    
    [self.mapView setShowsUserLocation:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    firstLaunch=YES;
    
    FetchArr = [[NSMutableArray alloc] init];
    [FetchArr removeAllObjects];
    
    if (isComingFromSearchSection) {
        isSearchCity = NO;
        [self btnCitySearchPressed:btnFindCity];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
     self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Select place"];
    UIButton *btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSkip.frame = CGRectMake(0, 6, 56, 32);
    [btnSkip.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnSkip setTitle:@"Done" forState:UIControlStateNormal];
    [btnSkip.titleLabel setTextColor:[UIColor whiteColor]];
    [btnSkip addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSkip.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 13, 22);
    [btnCancel setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer1.width = 0;
    if (IS_IOS7)
        negativeSpacer1.width = 0;
    
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnCancel] autorelease];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer1, backButtonItem, nil];

    
    searchBar.textColor = SELECTED_COLOR;
    if ([searchBar respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:searchBar.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

- (void)setupMenuBarButtonItems {
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 6, 56, 32);
    [btnCancel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel.titleLabel setTextColor:[UIColor whiteColor]];
    [btnCancel addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnCancel] autorelease];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backButtonItem, nil];
    return backButtonItem;
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    UIButton *btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSkip.frame = CGRectMake(0, 6, 56, 32);
    [btnSkip.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnSkip setTitle:@"Done" forState:UIControlStateNormal];
    [btnSkip.titleLabel setTextColor:[UIColor whiteColor]];
    [btnSkip addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSkip.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnSkip] autorelease];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
    return rightButtonItem;
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action Method

- (IBAction)btnCitySearchPressed:(id)sender {
    searchBar.text = @"";
    if (isSearchCity) {
        isSearchCity = NO;
        
        [UIView beginAnimations:@"animateView" context:nil];
        [UIView setAnimationDuration:0.3];
        searchBar.placeholder = @"Find Location..";
        [self.nearbyVenues removeAllObjects];
        [self.LocTable reloadData];
        
        [btnBackCity setHidden:YES];
        [btnFindCity setHidden:NO];
        imvSearchIcon.frame = CGRectMake(10, imvSearchIcon.frame.origin.y, imvSearchIcon.frame.size.height, imvSearchIcon.frame.size.height);
        searchBar.frame = CGRectMake(30, searchBar.frame.origin.y, searchBar.frame.size.width, searchBar.frame.size.height);
        [UIView commitAnimations];
        
    } else {
        isSearchCity = YES;
        searchBar.placeholder = @"Find Cities..";
        
        [UIView beginAnimations:@"animateView" context:nil];
        [UIView setAnimationDuration:0.3];
        
        [self.nearbyVenues removeAllObjects];
        [self.LocTable reloadData];
        [btnBackCity setHidden:NO];
        [btnFindCity setHidden:YES];

        if (!isComingFromSearchSection) {
            imvSearchIcon.frame = CGRectMake(10+18, imvSearchIcon.frame.origin.y, imvSearchIcon.frame.size.height, imvSearchIcon.frame.size.height);
            searchBar.frame = CGRectMake(30+20, searchBar.frame.origin.y, searchBar.frame.size.width, searchBar.frame.size.height);
        } else {
            [btnBackCity setHidden:YES];
        }
        [UIView commitAnimations];
    }
}

- (IBAction)btnBackCityAction:(id)sender
{
    isSearchCity = NO;
    
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.3];
    
    searchBar.text = @"";
    searchBar.placeholder = @"Find Location..";
    [self.nearbyVenues removeAllObjects];
    [self.LocTable reloadData];
    
    [btnBackCity setHidden:YES];
    [btnFindCity setHidden:NO];
    imvSearchIcon.frame = CGRectMake(10, imvSearchIcon.frame.origin.y, imvSearchIcon.frame.size.height, imvSearchIcon.frame.size.height);
    searchBar.frame = CGRectMake(30, searchBar.frame.origin.y, searchBar.frame.size.width, searchBar.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - Get Location details

- (void)getVenueSearchNearByLocation
{
    pendingOperation = 0;
    [appDelegateObj showActivity:self.view showOrHide:YES];
    
    [Foursquare2 venueSearchNearByLatitude:[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude]
                                 longitude:[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude]
                                     query:nil
                                     limit:nil
                                    intent:intentBrowse
                                    radius:[NSNumber numberWithInteger:5000]
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                        
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          
                                          [self.nearbyVenues removeAllObjects];
                                          [self.LocTable reloadData];
                                          
                                          if ([venues count] > 0) {
                                              [NoLocationView setHidden:YES];
                                              [LocTable setHidden:NO];
                                          } else {
                                              [NoLocationView setHidden:NO];
                                              [LocTable setHidden:YES];
                                          }
                                          
                                          for (NSDictionary *dict in venues) {
                                              NSString *venueID = dict[@"id"];
                                              pendingOperation++;
                                              [self getVenueDetailUsingFoursquare:venueID];
                                          }
                                          
                                          if (pendingOperation <= 0) {
                                              [appDelegateObj showActivity:self.view showOrHide:NO];
                                          }
                                     
                                      } else {
                                          [appDelegateObj showActivity:self.view showOrHide:NO];
                                      }
                                  }];
}


- (void)getLocationDataUsingFoursquare:(NSString*)searchtxt
{
    [appDelegateObj showActivity:self.view showOrHide:YES];
    pendingOperation = 0;
    
    NSString *strLocation = [NSString stringWithFormat:@"%@, %@", self.cityVenue.name, self.cityVenue.location.address];
    
    [Foursquare2 venueSearchNearLocation:strLocation
                                   query:searchtxt
                                   limit:nil
                                  intent:intentCheckin
                                  radius:[NSNumber numberWithInteger:25000]  // 25000
                              categoryId:nil
                                callback:^(BOOL success, id result){
         if (success) {
             NSDictionary *dic = result;
             NSArray *venues = [dic valueForKeyPath:@"response.venues"];
             
             [self.nearbyVenues removeAllObjects];
             [self.LocTable reloadData];
             
             if ([venues count] > 0) {
                 [NoLocationView setHidden:YES];
                 [LocTable setHidden:NO];
             } else {
                 [NoLocationView setHidden:NO];
                 [LocTable setHidden:YES];
             }
             
             for (NSDictionary *dict in venues) {
//                 FSConverter *converter = [[FSConverter alloc]init];
//                 int count = [self.nearbyVenues count];
//                 [self.nearbyVenues addObject:[converter convertObjectToVenue:dict]];
                 
//                 NSIndexPath *path1 = [NSIndexPath indexPathForRow:count inSection:0]; //ALSO TRIED WITH indexPathRow:0
//                 NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
//                 [self.LocTable insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                 
                 
                 
                 NSString *venueID = dict[@"id"];
                 pendingOperation++;
                 [self getVenueDetailUsingFoursquare:venueID];
             }
             
             if (pendingOperation <= 0) {
                 [appDelegateObj showActivity:self.view showOrHide:NO];
             }
         } else {
             [appDelegateObj showActivity:self.view showOrHide:NO];
         }
     }];
}

- (void)getVenueDetailUsingFoursquare:(NSString*)venueID
{
    [Foursquare2 venueGetDetail:venueID callback:^(BOOL success, id result) {
        if (success) {
            NSDictionary *dic = result;
            //NSLog(@"\n%@", dic);
            FSConverter *converter = [[FSConverter alloc]init];
            //int count = [self.nearbyVenues count];
            [self.nearbyVenues addObject:[converter convertObjectToVenue:[dic valueForKeyPath:@"response.venue"] currentLocation:self.currentLocation]];
            
            
            if (pendingOperation == 1) {
                
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                    initWithKey: @"self.location.distance" ascending: YES];
                NSMutableArray *sortedArray = (NSMutableArray *)[self.nearbyVenues
                                                                 sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
                self.nearbyVenues = [sortedArray mutableCopy];
                [self.LocTable reloadData];
                [appDelegateObj showActivity:self.view showOrHide:NO];
                pendingOperation = 0;
            }
            pendingOperation--;
        } else {
            [appDelegateObj showActivity:self.view showOrHide:NO];
        }
    }];
}

- (void)searchByCityUsingGoogleAPI:(NSString*)searchText
{
    [appDelegateObj showActivity:self.view showOrHide:YES];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[self autocompleteUrlFor:searchText]]];
    
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *receivedString = [request responseString];
    
    NSDictionary *responseObject = [receivedString JSONValue];
    NSArray *places = [responseObject objectForKey:@"predictions"];
    //NSLog(@"Places ==== %@", places);
    
    [self.nearbyVenues removeAllObjects];
    [self.LocTable reloadData];
    
    if ([places count] > 0) {
        FSConverter *converter = [[FSConverter alloc]init];
        for (NSDictionary *dictData in places) {
            [self.nearbyVenues addObject:[converter convertGoogleSearchObjectToVenue:dictData]];
        }
        [NoLocationView setHidden:YES];
        [LocTable setHidden:NO];
        [self.LocTable reloadData];
    } else {
        [NoLocationView setHidden:NO];
        [LocTable setHidden:YES];
    }
    
    
    [appDelegateObj showActivity:self.view showOrHide:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [appDelegateObj showActivity:self.view showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (NSString*)autocompleteUrlFor:(NSString*)query
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [urlString appendFormat:@"&key=%@", GOOGLEAPI];
    [urlString appendFormat:@"&types=(cities)"];
    
    if (self.currentLocation) {
        [urlString appendFormat:@"&sensor=%@", @"true"];
        [urlString appendFormat:@"&location=%f,%f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
        [urlString appendFormat:@"&radius=50000"];
    } else {
        [urlString appendFormat:@"&sensor=%@", @"false"];
    }
    return urlString;
}


#pragma mark - MAp Annotations

- (void)proccessAnnotations {
    [self removeAllAnnotationExceptOfCurrentUser];
    [self.mapView addAnnotations:self.nearbyVenues];
}

- (void)removeAllAnnotationExceptOfCurrentUser {
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
    if ([self.mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:self.mapView.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in self.mapView.annotations) {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [self.mapView removeAnnotations:annForRemove];
}

- (void)plotPositions:(NSArray *)data
{
    for (id<MKAnnotation> annotation in mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [mapView removeAnnotation:annotation];
        }
    }
}

-(IBAction)CrossBtnCall {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [LocTable reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [searchBar resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate methods.

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    if (firstLaunch==YES) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
        firstLaunch=YES;
    }
    [mv setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        for (UIView *subview in [annotationView subviews]) {
            [subview removeFromSuperview];
        }
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}

#pragma mark - Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyVenues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simple=@"Simple";
    LocationCell *cell = (LocationCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.imvLocation setClipsToBounds:YES];
    [[cell.imvLocation layer] setMasksToBounds:YES];
    [[cell.imvLocation layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[cell.imvLocation layer] setBorderWidth:0.7];
    [[cell.imvLocation layer] setCornerRadius:cell.imvLocation.frame.size.width/2.0];
    
    FSVenue *venue = [self.nearbyVenues objectAtIndex:indexPath.row];
    cell.lblLocationName.text = venue.name;
    cell.lblLocationName.textColor = SELECTED_COLOR;

    NSString *address = @"";
    if ([venue.location.address length] > 0) {
        address = [address stringByAppendingFormat:@"%@", venue.location.address];
    }
    
    if (!isSearchCity) {
        if ([venue.location.address length] > 0 && [venue.location.city length] > 0) {
            address = [address stringByAppendingFormat:@", "];
        }
        
        if ([venue.location.city length] > 0) {
            address = [address stringByAppendingFormat:@"%@", venue.location.city];
        }
    }
    
    cell.lblAddress.text = address;
    //cell.lblAddress.textColor = SELECTED_COLOR;
    
    if ([venue.locationImage length] > 0) {
        [IconDownloader loadImageFromLink:venue.locationImage forImageView:cell.imvLocation withPlaceholder:nil andContentMode:UIViewContentModeScaleAspectFit];
    } else {
        cell.imvLocation.image = [UIImage imageNamed:@"location-icon1.png"];
    }
    
    cell.imvBottomLine.frame = CGRectMake(cell.imvBottomLine.frame.origin.x, cell.imvBottomLine.frame.origin.y, cell.imvBottomLine.frame.size.width, 0.7);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

#pragma mark - tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearchCity == YES) {
        isSearchCity = NO;
        
        if (isComingFromSearchSection) {
            self.objSearchView.venue = self.nearbyVenues[indexPath.row];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        [UIView beginAnimations:@"animateView" context:nil];
        [UIView setAnimationDuration:0.3];
        searchBar.placeholder = @"Find Location..";
        
        self.cityVenue = self.nearbyVenues[indexPath.row];
        [btnFindCity setTitle:self.cityVenue.name forState:UIControlStateNormal];
        [btnFindCity setTitle:self.cityVenue.name forState:UIControlStateHighlighted];
        
        searchBar.text = @"";
        [self.nearbyVenues removeAllObjects];
        [LocTable reloadData];
        
        [btnBackCity setHidden:YES];
        [btnFindCity setHidden:NO];
        imvSearchIcon.frame = CGRectMake(10, imvSearchIcon.frame.origin.y, imvSearchIcon.frame.size.width, imvSearchIcon.frame.size.height);
        searchBar.frame = CGRectMake(30, searchBar.frame.origin.y, searchBar.frame.size.width, searchBar.frame.size.height);
        [UIView commitAnimations];
        
        [self getLocationDataUsingFoursquare:@" "];
    } else {
        switch (iParentView) {
            case kSuggestPlaceView: {
                SuggestPlaceViewController * suggest = [[SuggestPlaceViewController alloc]initWithNibName:@"SuggestPlaceViewController" bundle:nil];
                FSVenue *venue = self.nearbyVenues[indexPath.row];
                suggest.venue = venue;
                [self.navigationController pushViewController:suggest animated:YES];
                [suggest release];
            }
                break;
            case kEventView: {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.35;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                objAddEvent.venue = self.nearbyVenues[indexPath.row];
                [self.navigationController popViewControllerAnimated:NO];
            }
                break;
            case kOfferView: {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.35;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                objOfferView.venue = self.nearbyVenues[indexPath.row];
                [self.navigationController popViewControllerAnimated:NO];
            }
                break;
            case kPhotoView: {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.35;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                objPhotoView.venue = self.nearbyVenues[indexPath.row];
                [self.navigationController popViewControllerAnimated:NO];
            }
                break;
            case kActivityView: {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.35;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                objActivityView.venue = self.nearbyVenues[indexPath.row];
                [self.navigationController popViewControllerAnimated:NO];
            }
            default:
                break;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

#pragma mark - keyboard animation

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [tempResultArray removeAllObjects];
    if (isSearchCity) {
        if ([textField.text length] > 0) {
            [self searchByCityUsingGoogleAPI:searchBar.text];
        }
    } else {
        if ([textField.text length] > 0) {
            [self getLocationDataUsingFoursquare:searchBar.text];
        } else {
            //[self getLocationDataUsingFoursquare:@" "];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [searchBar resignFirstResponder];
}

@end
