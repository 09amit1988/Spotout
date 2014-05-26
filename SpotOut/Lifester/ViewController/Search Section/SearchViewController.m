//
//  SearchViewController.m
//  Lifester
//
//  Created by MAC240 on 4/10/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "SearchViewController.h"
#import "AddLocation_IPhone5.h"
#import "SearchCell.h"
#import "ProfileVisitViewController.h"
#import "FeedDetailViewController.h"
#import "JSON.h"
#import "Reachability.h"
#import "StringHelper.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize btnLocationCity;
@synthesize venue;
@synthesize arrSearchResult;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    locationManager.delegate = nil;
}

- (void)dealloc
{
    [super dealloc];
    [searchView release];
    [resultView release];
    [noResultFoundView release];
    [tblResult release];
    [locationManager release];
    [currentLocation release];
    
    [txtSearch release];
    [btnLocationCity release];
    [btnSearch release];
    [btnBack release];
    [imvSearchIcon release];
}

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.venue = [[FSVenue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CustomNaviView *naviTitle = [[CustomNaviView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    naviTitle.viewController = self;
    naviTitle.btnFriendRequest.selected = YES;
    //self.navigationItem.titleView = naviTitle;

    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Explore"];
    [self setupMenuBarButtonItems];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    pageNo = 0;
    selectedIndex = -1;
    self.arrSearchResult = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    [noResultFoundView  setHidden:YES];
    [btnBack setHidden:YES];
    [searchView setHidden:NO];
    [resultView setHidden:YES];
    resultView.alpha = 0;
    searchView.alpha = 1;
    btnSearch.alpha = 0;
    btnLocationCity.alpha = 1;
    [btnSearch setHidden:YES];
    
    txtSearch.textColor = SELECTED_COLOR;
    if ([txtSearch respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtSearch.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
    
    [searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (self.venue) {
        [self.btnLocationCity setTitle:self.venue.name forState:UIControlStateNormal];
        [self.btnLocationCity setTitle:self.venue.name forState:UIControlStateHighlighted];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [searchBar setImage:[UIImage imageNamed: @"search icon_new.pn"]
                forSearchBarIcon:UISearchBarIconSearch
                           state:UIControlStateNormal];
    
    [searchBar setPositionAdjustment:UIOffsetMake(-5, 0) forSearchBarIcon:UISearchBarIconSearch];
    //[searchBar setSearchTextPositionAdjustment:UIOffsetMake(-270, 0)];
    //[searchBar performSelector:[searchBar becomeFirstResponder] withObject:nil afterDelay:1.0];
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItems = [self leftMenuBarButtonItem];
}

- (NSArray *)leftMenuBarButtonItem {
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 6, 56, 32);
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDone setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnDone.titleLabel setTextColor:[UIColor whiteColor]];
    [btnDone addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *leftButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnDone] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, leftButtonItem, nil];
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
//    [appDelegate addMenuViewControllerOnWindow:self];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

#pragma mark - Location Manager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    
    CLGeocoder *fgeo = [[[CLGeocoder alloc] init] autorelease];
    // Reverse Geocode a CLLocation to a CLPlacemark
    [fgeo reverseGeocodeLocation:currentLocation
               completionHandler:^(NSArray *placemarks, NSError *error) {
                   // Make sure the geocoder did not produce an error
                   // before continuing
                   if(!error){
                       // Iterate through all of the placemarks returned
                       // and output them to the console
                       for(CLPlacemark *placemark in placemarks) {
                           [self assignValueToVenueObject:placemark];
                       }
                   } else{
                       // Our geocoder had an error, output a message
                       // to the console
                       NSLog(@"There was a reverse geocoding error\n%@",
                             [error localizedDescription]);
                   }
               }
     ];
    
    locationManager.delegate=nil;
}

- (void)assignValueToVenueObject:(CLPlacemark*)placemark
{
    self.venue.name = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    
    [self.btnLocationCity setTitle:self.venue.name forState:UIControlStateNormal];
    [self.btnLocationCity setTitle:self.venue.name forState:UIControlStateHighlighted];
    
    NSString *address = [NSString stringWithFormat:@"%@", [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStateKey]];
    address = [address stringByAppendingFormat:@", %@", [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryKey]];
    self.venue.location.address = address;
    self.venue.location.city = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
    self.venue.location.state = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressStateKey];
    self.venue.location.country = [placemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCountryKey];
}


#pragma mark - UIButton Action

- (IBAction)btnLocationCityAction:(id)sender
{
    AddLocation_IPhone5 *viewController = [[[AddLocation_IPhone5 alloc] initWithNibName:@"AddLocation_IPhone5" bundle:nil] autorelease];
    viewController.isComingFromSearchSection = YES;
    viewController.objSearchView = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnSearchAction:(id)sender
{
    [txtSearch resignFirstResponder];
    
    pageNo = 0;
    [self callSearchAPI];
}

- (IBAction)btnBackAction:(id)sender
{
    [self updateUIAsNormal];
    
    pageNo = 0;
    [self.arrSearchResult removeAllObjects];
    [tblResult reloadData];
}

#pragma mark - Webservice callback methods

- (void)callFollowUserAPI:(NSDictionary *)dictData
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [appDelegate showActivity:self.view showOrHide:YES];
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    flag = 2;
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"follow_unfollow" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[dictData objectForKey:@"user_id"] forKey:@"follow_userid"];
    
    if ([[dictData objectForKey:@"followed"] class] == [NSNull class]) {
        [request setPostValue:[NSNumber numberWithBool:YES] forKey:@"follow"];
    } else {
        if ([[dictData objectForKey:@"followed"] boolValue]) {
            [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"follow"];
        } else {
            [request setPostValue:[NSNumber numberWithBool:YES] forKey:@"follow"];
        }
    }
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}


- (void)callSearchAPI
{
    if ([self.venue.location.city length] > 0) {
       
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"SpotOut\" to Determine Your Location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if ([txtSearch.text hasPrefix:@"&"]) {
        searchType = kUserSearch;
    } else if ([txtSearch.text hasPrefix:@"#"]) {
        searchType = kTagSearch;
    } else {
        searchType = kSimpleSearch;
    }
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    pageNo++;
    //pageNo = 1;
    [appDelegate showActivity:self.view showOrHide:YES];
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    flag = 1;
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"search_keyword" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[NSString stringWithFormat:@"%d", pageNo] forKey:@"page_no"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:searchBar.text forKey:@"search_text"];
    [request setPostValue:self.venue.location.city forKey:@"city"];

    if ([self.venue.location.state length] > 0) {
        [request setPostValue:self.venue.location.state forKey:@"state"];
    } else {
        [request setPostValue:@"" forKey:@"state"];
    }
    
    if ([self.venue.location.country length] > 0) {
        [request setPostValue:self.venue.location.country forKey:@"country"];
    } else {
        [request setPostValue:@"" forKey:@"country"];
    }
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *receivedString = [request responseString];
    NSDictionary *responseObject = [receivedString JSONValue];
    NSDictionary *items = [responseObject objectForKey:@"raws"];
    [appDelegate showActivity:self.view showOrHide:NO];
    
    if (flag == 1) {
        [self.arrSearchResult removeAllObjects];
        [tblResult reloadData];
        
        //NSLog(@"Response ====== %@" ,items);
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Time Line"]) {
            @try {
                NSDictionary *dictSearch = [[[items valueForKey:@"status"] valueForKey:@"data"] objectAtIndex:0];
                if ([dictSearch isKindOfClass:[NSMutableArray class]]) {
                    [resultView setHidden:YES];
                    [noResultFoundView setHidden:NO];
                    lblMessage.text = [NSString stringWithFormat:@"\"%@\"", txtSearch.text];
                    return;
                } else {
                    if ([dictSearch objectForKey:@"profile"] || [dictSearch objectForKey:@"post"]) {
                        [noResultFoundView setHidden:YES];
                        [resultView setHidden:NO];
                    } else {
                        [resultView setHidden:YES];
                        [noResultFoundView setHidden:NO];
                        lblMessage.text = [NSString stringWithFormat:@"\"%@\"", txtSearch.text];
                        return;
                    }
                }
                
                NSArray *arrTempProfile = [NSArray array];
                NSArray *arrTempPost = [NSArray array];
                if ([[dictSearch objectForKey:@"profile"] count] > 0) {
                    arrTempProfile = [dictSearch objectForKey:@"profile"];
                }
                
                if ([[dictSearch objectForKey:@"post"] count] > 0) {
                    arrTempPost = [dictSearch objectForKey:@"post"];
                }
                
                for (NSMutableDictionary *dictProfile in arrTempProfile) {
                    [dictProfile setValue:[NSNumber numberWithBool:YES] forKey:@"IsProfile"];
                    [dictProfile setValue:[NSNumber numberWithBool:NO] forKey:@"isReadMoreExplanded"];
                    [dictProfile setValue:[NSNumber numberWithBool:NO] forKey:@"isProfileViewExplanded"];
                    
                    int index = [self.arrSearchResult count];
                    [self.arrSearchResult addObject:dictProfile];
                    
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:index inSection:0]; //ALSO TRIED WITH indexPathRow:0
                    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
                    [tblResult insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                for (NSMutableDictionary *dictProfile in arrTempPost) {
                    [dictProfile setValue:[NSNumber numberWithBool:NO] forKey:@"IsProfile"];
                    [dictProfile setValue:[NSNumber numberWithBool:NO] forKey:@"isReadMoreExplanded"];
                    [dictProfile setValue:[NSNumber numberWithBool:NO] forKey:@"isProfileViewExplanded"];
                    
                    int index = [self.arrSearchResult count];
                    [self.arrSearchResult addObject:dictProfile];
                    
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:index inSection:0]; //ALSO TRIED WITH indexPathRow:0
                    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
                    [tblResult insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Exception ==== %@", exception);
            }
            @finally {
                
            }
        } else {
            [noResultFoundView setHidden:NO];
            [resultView setHidden:YES];
            lblMessage.text = [NSString stringWithFormat:@"\"%@\"", txtSearch.text];
            //        NSString *message = [NSString stringWithFormat:@"No results found for \"%@\". Please try again.", txtSearch.text];
            //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //        [alertView show];
            //        [alertView release];
        }
    }
    else if (flag == 2) {
        NSLog(@"Response ====== %@" ,items);
        if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"001"]) {
            
            NSString *followingCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"status"] valueForKey:@"following"]];
            NSString *followerCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"status"] valueForKey:@"followers"]];
            [[NSUserDefaults standardUserDefaults] setObject:followingCount forKey:@"following_count"];
            [[NSUserDefaults standardUserDefaults] setObject:followerCount forKey:@"follower_count"];
            
            NSMutableDictionary *dictData = [self.arrSearchResult objectAtIndex:selectedIndex];
            if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"1"] || [[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Follower Added"]) {
                [dictData setValue:[NSNumber numberWithBool:YES] forKey:@"followed"];
            } else if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"0"] || [[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Follower Removed"]) {
                [dictData setValue:[NSNumber numberWithBool:NO] forKey:@"followed"];
            }

            [self.arrSearchResult replaceObjectAtIndex:selectedIndex withObject:dictData];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            [tblResult reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [appDelegate showActivity:self.view showOrHide:NO];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


#pragma mark - Custom Methods

- (void)updateUIForSearchResult
{
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.5];
    
    [btnBack setHidden:NO];
    [searchView setHidden:YES];
    [resultView setHidden:NO];
    [btnLocationCity setHidden:YES];
    [btnSearch  setHidden:NO];
    resultView.alpha = 1;
    searchView.alpha = 0;
    btnSearch.alpha = 1;
    btnLocationCity.alpha = 0;
    
    //imvSearchIcon.frame = CGRectMake(11+17, imvSearchIcon.frame.origin.y, imvSearchIcon.frame.size.height, imvSearchIcon.frame.size.height);
    //txtSearch.frame = CGRectMake(34+20, txtSearch.frame.origin.y, txtSearch.frame.size.width, txtSearch.frame.size.height);
    searchBar.frame = CGRectMake(20, 65, 220, 44);
    [UIView commitAnimations];
}

- (void)updateUIAsNormal
{
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.5];
    
    txtSearch.text = @"";
    searchBar.text = @"";
    [searchBar becomeFirstResponder];
    
    [btnBack setHidden:YES];
    [searchView setHidden:NO];
    [resultView setHidden:YES];
    [btnLocationCity setHidden:NO];
    [btnSearch  setHidden:YES];
    resultView.alpha = 0;
    searchView.alpha = 1;
    btnSearch.alpha = 0;
    btnLocationCity.alpha = 1;
    
//    imvSearchIcon.frame = CGRectMake(11, imvSearchIcon.frame.origin.y, imvSearchIcon.frame.size.height, imvSearchIcon.frame.size.height);
//    txtSearch.frame = CGRectMake(34, txtSearch.frame.origin.y, txtSearch.frame.size.width, txtSearch.frame.size.height);
    searchBar.frame = CGRectMake(0, 65, 220, 44);
    [UIView commitAnimations];
}

#pragma mark - UITableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSearchResult count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simple = @"SearchCell";
    SearchCell *cell = (SearchCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SearchCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }

    NSDictionary *dictData = [self.arrSearchResult objectAtIndex:indexPath.row];
    [cell.btnTagNames setHidden:YES];
    
    if (searchType == kUserSearch) {
        [cell.profileView setHidden:NO];
        [cell.postView setHidden:YES];
        [cell.tagView setHidden:YES];
    } else if (searchType == kTagSearch) {
        [cell.postView setHidden:NO];
        [cell.tagView setHidden:NO];
        [cell.btnTagNames setHidden:NO];
        
        if ([[dictData objectForKey:@"isProfileViewExplanded"] boolValue]) {
            [cell.profileView setHidden:NO];
            float yValue = cell.profileView.frame.origin.y + cell.profileView.frame.size.height;
            cell.postView.frame = CGRectMake(cell.postView.frame.origin.x, yValue, cell.postView.frame.size.width, cell.btnReadMore.frame.size.height);
            yValue = yValue + cell.postView.frame.size.height;
            cell.tagView.frame = CGRectMake(cell.tagView.frame.origin.x, yValue, cell.tagView.frame.size.width, cell.tagView.frame.size.height);
        } else {
            [cell.profileView setHidden:YES];
            cell.postView.frame = CGRectMake(cell.postView.frame.origin.x, 0, cell.postView.frame.size.width, cell.postView.frame.size.height);
            float yValue = cell.postView.frame.origin.y + cell.postView.frame.size.height;
            cell.tagView.frame = CGRectMake(cell.tagView.frame.origin.x, yValue, cell.tagView.frame.size.width, cell.tagView.frame.size.height);
        }
    } else {
        [cell.tagView setHidden:YES];
        [cell.profileView setHidden:NO];
        [cell.postView setHidden:NO];
    }
    
    if ([[dictData objectForKey:@"profilename"] class] == [NSNull class]) {
        cell.lblProfileName.text = @"";
    } else {
        cell.lblProfileName.text = [dictData objectForKey:@"profilename"];
    }
    cell.lblUserName.text = [dictData objectForKey:@"username"];
    
    DYRateView *rateview = [[[DYRateView alloc] initWithFrame:CGRectMake(56, 43, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]] autorelease];
    rateview.editable = NO;
    rateview.rate = [[dictData objectForKey:@"avg_rating_profile"] floatValue];
    [cell.profileView addSubview:rateview];
    
    if ([[dictData objectForKey:@"IsProfile"] boolValue]) {
        NSDictionary *dictProfileImage = [dictData objectForKey:@"profile_image"];
        if ([[dictProfileImage objectForKey:@"has_profiole_picture"] boolValue]) {
            cell.imvProfileUser.imageURL = [NSURL URLWithString:[dictProfileImage objectForKey:@"profile_picture_id"]];
        } else {
            cell.imvProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
        }
    } else {
        if ([[dictData objectForKey:@"has_profiole_picture"] boolValue]) {
            cell.imvProfileUser.imageURL = [NSURL URLWithString:[dictData objectForKey:@"profile_picture_id"]];
        } else {
            cell.imvProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
        }
    }
    
    [cell.imvProfileUser setClipsToBounds: YES];
    [[cell.imvProfileUser layer] setMasksToBounds:YES];
    [[cell.imvProfileUser layer] setCornerRadius:cell.imvProfileUser.frame.size.width/2];
    
    if ([[dictData objectForKey:@"followed"] class] == [NSNull class]) {
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateHighlighted];
    } else {
        if ([[dictData objectForKey:@"followed"] boolValue]) {
            [cell.btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
            [cell.btnFollow setTitle:@"Unfollow" forState:UIControlStateHighlighted];
        } else {
            [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
            [cell.btnFollow setTitle:@"Follow" forState:UIControlStateHighlighted];
        }
    }
    [cell.btnFollow setTag:indexPath.row];
    [cell.btnFollow addTarget:self action:@selector(btnFollowToggleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[dictData objectForKey:@"location_name"] class] == [NSNull class]) {
        cell.lblLocationName.text = @"";
    } else {
        cell.lblLocationName.text = [dictData objectForKey:@"location_name"];
    }
    if ([[dictData objectForKey:@"type"] integerValue] == TEXT_TYPE) {
        [cell.lblLocationName setHidden:YES];
    } else {
        [cell.lblLocationName setHidden:NO];
    }
    
    NSString *category = @"";
    if ([dictData objectForKey:@"category"]) {
        NSArray *artTags = [dictData objectForKey:@"category"];
        for (int i = 0; i < [artTags count]; i++) {
            NSDictionary *dictCategory = [artTags objectAtIndex:i];
            if (i == [artTags count]-1) {
                category = [category stringByAppendingFormat:@"%@", [dictCategory objectForKey:@"name"]];
            } else {
                category = [category stringByAppendingFormat:@"%@   ", [dictCategory objectForKey:@"name"]];
            }
        }
    }
    cell.lblTagNames.text = category;
    
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:[dictData objectForKey:@"Description_places"]];
    [attrStr setTextColor:SELECTED_COLOR];
    [attrStr setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:14.0]];

    @try {
        if (![[dictData objectForKey:@"IsProfile"] boolValue]) {
            NSRegularExpression *userRegex = [NSRegularExpression regularExpressionWithPattern:txtSearch.text options:0 error:nil];
            NSString *desc = [dictData objectForKey:@"Description_places"];
            [userRegex enumerateMatchesInString:desc
                                        options:0
                                          range:NSMakeRange(0,desc.length)
                                     usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
             {
                 [attrStr setTextBold:YES range:match.range];
             }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception ==== %@", exception);
    }
    @finally {
    }
    cell.lblDescription.attributedText = attrStr;
    
    float height = [[dictData objectForKey:@"Description_places"] RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
    cell.lblDescription.numberOfLines = 0;
    
    [cell.btnReadMore setTag:indexPath.row];
    [cell.btnReadMore addTarget:self action:@selector(btnReadMoreContentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnTagNames setTag:indexPath.row];
    [cell.btnTagNames addTarget:self action:@selector(btnTagNamesAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView bringSubviewToFront:cell.tagView];
    
    float yOrigin = 0;
    if ([[dictData objectForKey:@"isReadMoreExplanded"] boolValue]) {
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateNormal];
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateHighlighted];
        
        cell.btnReadMore.hidden = NO;
        [cell.contentView bringSubviewToFront:cell.postView];
        CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
        cell.lblDescription.frame = frame;
        
        yOrigin = yOrigin + height + cell.lblDescription.frame.origin.y;
        cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
        cell.postView.frame = CGRectMake(cell.postView.frame.origin.x, cell.postView.frame.origin.y, cell.postView.frame.size.width, yOrigin+cell.btnReadMore.frame.size.height);
        yOrigin = cell.postView.frame.origin.y + cell.postView.frame.size.height;
    } else {
        if (height >= 77.0) {
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateNormal];
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateHighlighted];
            
            cell.btnReadMore.hidden = NO;
            height = 77.0;
            
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            
            yOrigin = height + cell.lblDescription.frame.origin.y;
            cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
            cell.postView.frame = CGRectMake(cell.postView.frame.origin.x, cell.postView.frame.origin.y, cell.postView.frame.size.width, height+cell.btnReadMore.frame.size.height+cell.btnReadMore.frame.size.height);
            yOrigin = cell.postView.frame.origin.y + cell.postView.frame.size.height;
        } else {
            cell.btnReadMore.hidden = YES;
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            cell.postView.frame = CGRectMake(cell.postView.frame.origin.x, cell.postView.frame.origin.y, cell.postView.frame.size.width, height+cell.lblLocationName.frame.size.height);
            yOrigin = cell.postView.frame.origin.y + cell.postView.frame.size.height;
        }
    }
    
    cell.tagView.frame = CGRectMake(cell.tagView.frame.origin.x, yOrigin, cell.tagView.frame.size.width, cell.tagView.frame.size.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictData = [self.arrSearchResult objectAtIndex:indexPath.row];
    
    if (searchType == kUserSearch) {
        return 65.0;
    } else if (searchType == kTagSearch) {
        NSDictionary *dictData = [self.arrSearchResult objectAtIndex:indexPath.row];
        float height = [[dictData objectForKey:@"Description_places"] RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
        
        if ([[dictData objectForKey:@"isReadMoreExplanded"] boolValue]) {
            height = height + 70;
            if ([[dictData objectForKey:@"isProfileViewExplanded"] boolValue]) {
                height = height + 56;
            }
        } else {
            if (height >= 77.0) {
                if ([[dictData objectForKey:@"isProfileViewExplanded"] boolValue]) {
                    height = height + 58 + 22;
                } else {
                    height = 77.0 + 70;
                }
            } else {
                if ([[dictData objectForKey:@"isProfileViewExplanded"] boolValue]) {
                    height = height + 58;
                }
                height = height + 48;
            }
        }
        return height;
    } else {
        if ([[dictData objectForKey:@"IsProfile"] boolValue]) {
            return 65.0;
        } else {
            NSDictionary *dictData = [self.arrSearchResult objectAtIndex:indexPath.row];
            float height = [[dictData objectForKey:@"Description_places"] RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
            
            if ([[dictData objectForKey:@"isReadMoreExplanded"] boolValue]) {
                height = height + 108;
            } else {
                if (height >= 77.0) {
                    height = 77.0 + 108;
                } else {
                    height = height + 88;
                }
            }
            return height;
        }
    }
    
    return 214.0;
}

#pragma mark - UITableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictData = [self.arrSearchResult objectAtIndex:indexPath.row];
    
    if ([[dictData objectForKey:@"IsProfile"] boolValue]) {
        ProfileVisitViewController *viewController = [[ProfileVisitViewController alloc] initWithNibName:@"ProfileVisitViewController" bundle:nil];
        viewController.profileID = [[dictData objectForKey:@"user_id"] integerValue];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        
        FeedDetailViewController *viewController = [[FeedDetailViewController alloc] initWithNibName:@"FeedDetailViewController" bundle:nil];
        viewController.lifeFeedID = [[dictData objectForKey:@"place_review_id"] integerValue];
        //viewController.feedPost = [[LifeFeedPost alloc] initWithDictionary:dictData];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)btnReadMoreContentAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSMutableDictionary *dictData = [self.arrSearchResult objectAtIndex:button.tag];
    if ([[dictData objectForKey:@"isReadMoreExplanded"] boolValue]) {
        [dictData setObject:[NSNumber numberWithBool:NO] forKey:@"isReadMoreExplanded"];
        
        [self.arrSearchResult replaceObjectAtIndex:button.tag withObject:dictData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblResult reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [dictData setObject:[NSNumber numberWithBool:YES] forKey:@"isReadMoreExplanded"];
        [self.arrSearchResult replaceObjectAtIndex:button.tag withObject:dictData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblResult reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)btnTagNamesAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSMutableDictionary *dictData = [self.arrSearchResult objectAtIndex:button.tag];
    if ([[dictData objectForKey:@"isProfileViewExplanded"] boolValue]) {
        [dictData setObject:[NSNumber numberWithBool:NO] forKey:@"isProfileViewExplanded"];
        
        [self.arrSearchResult replaceObjectAtIndex:button.tag withObject:dictData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblResult reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [dictData setObject:[NSNumber numberWithBool:YES] forKey:@"isProfileViewExplanded"];
        [self.arrSearchResult replaceObjectAtIndex:button.tag withObject:dictData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblResult reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)btnFollowToggleAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    selectedIndex = button.tag;
    NSMutableDictionary *dictData = [self.arrSearchResult objectAtIndex:button.tag];
    [self callFollowUserAPI:dictData];
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [txtSearch resignFirstResponder];
    if ([textField.text length] > 0) {
        [self updateUIForSearchResult];
        
        pageNo = 0;
        [self callSearchAPI];
    }
    
    return YES;
}

#pragma mark - SearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchBar resignFirstResponder];
    if ([searchbar.text length] > 0) {
        [self updateUIForSearchResult];
        
        pageNo = 0;
        [self callSearchAPI];
    }
}

@end
