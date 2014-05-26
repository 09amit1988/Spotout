//
//  ProfileVisitViewController.m
//  Lifester
//
//  Created by YASH  on 01/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "ProfileVisitViewController.h"
#import "AsyncImageView.h"
#import "ConversationViewController.h"
#import "JSON.h"
#import "MFSideMenu.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "StringHelper.h"
#import "LifeFeedPost.h"
#import "LocationDetailViewController.h"
#import "EventPostCell.h"
#import "OHAttributedLabel.h"
#import "OfferPostCell.h"
#import "TextPostCell.h"
#import "PicturePostCell.h"
#import "FollowerViewController.h"
#import "MapViewController.h"


@interface ProfileVisitViewController ()

@end

@implementation ProfileVisitViewController

@synthesize arrLifeFeed;
@synthesize currentLocation;
@synthesize profileID;
@synthesize user;

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.arrLifeFeed = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Profile Detail"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[profileView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[profileView layer] setBorderWidth:0.7];
    imvLineBottom.frame = CGRectMake(imvLineBottom.frame.origin.x, imvLineBottom.frame.origin.y, imvLineBottom.frame.size.width, 0.7);
    
    [self setupMenuBarButtonItems];
    tblProfile.tableHeaderView = headerTableView;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        [self getUserProfileDetail];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    imgseperateline1.frame = CGRectMake(imgseperateline1.frame.origin.x, imgseperateline1.frame.origin.y, 0.7, imgseperateline1.frame.size.height);
    imgseperateline2.frame = CGRectMake(imgseperateline2.frame.origin.x, imgseperateline2.frame.origin.y, 0.7, imgseperateline2.frame.size.height);
    
    [imgProfile setClipsToBounds: YES];
    [[imgProfile layer] setMasksToBounds:YES];
    [[imgProfile layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[imgProfile layer] setBorderWidth:3.0];
    [[imgProfile layer] setCornerRadius:imgProfile.frame.size.width/2];
    
    [tblProfile reloadRowsAtIndexPaths:[tblProfile indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
    [self updateUI];
}

- (void)updateUI
{
    lblProfileName.text = self.user.profileName;
    lblUserName.text = self.user.username;
    
    if (self.user.hasProfilePicture) {
        imgProfile.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.user.profileImage]];
    } else {
        imgProfile.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", DEFAULTPROFILEIMAGE]];
    }
    
    rateview = [[DYRateView alloc] initWithFrame:CGRectMake(101, 166, 234, 30) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
    rateview.alignment = RateViewAlignmentLeft;
    rateview.editable = NO;
    rateview.delegate = self;
    rateview.rate = self.user.profileRating;
    [headerTableView addSubview:rateview];
    
    if (self.user.followed) {
        [btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [btnFollow setTitle:@"Unfollow" forState:UIControlStateHighlighted];
    } else {
        [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [btnFollow setTitle:@"Follow" forState:UIControlStateHighlighted];
    }
    
    lblFollowerCount.text = [NSString stringWithFormat:@"%@", self.user.followerCount];
    lblFollowingCount.text = [NSString stringWithFormat:@"%@", self.user.followingCount];
    lblReviewCount.text = [NSString stringWithFormat:@"%@", self.user.reviewCount];
    
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
//    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
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
    //[appDelegate addMenuViewControllerOnWindow:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

#pragma mark - Current Location Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

#pragma mark - Action method

- (IBAction)btnFollowToggleAction:(id)sender
{
    if (btnFollow.isSelected) {
        [btnFollow setSelected:NO];
    } else {
        [btnFollow setSelected:YES];
    }
}

- (IBAction)btnInfoAction:(id)sender
{
    
}

- (IBAction)btnReviewAction:(id)sender
{
    RateProfileViewController *viewController = [[RateProfileViewController alloc] initWithNibName:@"RateProfileViewController" bundle:nil];
    viewController.isOtherUser = YES;
    viewController.profileID = self.user.userID;
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)btnRateProfileAction:(id)sender
{
    RateProfileViewController * viewController = [[RateProfileViewController alloc]initWithNibName:@"RateProfileViewController" bundle:nil];
    viewController.isOtherUser = YES;
    viewController.profileID = self.user.userID;
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)btnSendMessageAction:(id)sender
{
    ConversationViewController *viewController = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnFollowerAction:(id)sender
{
    FollowerViewController *viewController = [[[FollowerViewController alloc] initWithNibName:@"FollowerViewController" bundle:nil] autorelease];
    viewController.isFollowing = NO;
    viewController.profileID = self.user.userID;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnFollowingAction:(id)sender
{
    FollowerViewController *viewController = [[[FollowerViewController alloc] initWithNibName:@"FollowerViewController" bundle:nil] autorelease];
    viewController.isFollowing = YES;
    viewController.profileID = self.user.userID;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Web service call Methods

- (void)getUserProfileDetail
{
    [appDelegate showActivity:self.view showOrHide:YES];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    flag = 1;
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"user_pprofile_detail" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[NSString stringWithFormat:@"%d", profileID] forKey:@"profile_userid"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}


-(void)getProfileTimeline
{
    //[appDelegate showActivity:self.view showOrHide:YES];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    flag = 2;
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"get_profile_timeline" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:self.user.userID forKey:@"profile_id"];
    
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
    flag = 3;
    
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
//    NSLog(@"Response === %@", items);
    
    if (flag == 1) {
        if ([[[items valueForKey:@"status"] valueForKey:@"Status_code"] isEqualToString:@"001"]) {
            @try {
                NSDictionary *dictData = [[[items valueForKey:@"status"] valueForKey:@"data"] objectAtIndex:0];
                self.user = [[User alloc] initWithDictionaryForProfileDetail:[[dictData objectForKey:@"profile"] objectAtIndex:0]];
                [self updateUI];
                
                [self getProfileTimeline];
            }
            @catch (NSException *exception) {
                NSLog(@"Exception ==== %@", exception);
            }
            @finally {
            }
        } else {
            [appDelegate showActivity:self.view showOrHide:NO];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    } else if (flag == 2) {
        [appDelegate showActivity:self.view showOrHide:NO];
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Time Line"]) {
            @try {
                NSMutableArray *arrTemp = [[[items valueForKey:@"status"] valueForKey:@"data"] objectAtIndex:0];
                [self.arrLifeFeed removeAllObjects];
                [tblProfile reloadData];
                
                for (NSMutableDictionary *dictData in arrTemp) {
                    LifeFeedPost *feedPost = [[LifeFeedPost alloc] initWithDictionary:dictData];
                    int index = [self.arrLifeFeed count];
                    [self.arrLifeFeed addObject:feedPost];
                    
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:index inSection:0]; //ALSO TRIED WITH indexPathRow:0
                    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
                    [tblProfile insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
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
    } else if (flag == 3) {
        // Parse response of Delete Place Rating
        
        [appDelegate showActivity:self.view showOrHide:NO];
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Deleted Successfully"]) {
            LifeFeedPost *lifeFeedPost = [self.arrLifeFeed objectAtIndex:selectedRow];
            lifeFeedPost.averageRating = [[items valueForKey:@"Average_rating"] floatValue];
            lifeFeedPost.isAlreadyRated = NO;
            [self.arrLifeFeed replaceObjectAtIndex:selectedRow withObject:lifeFeedPost];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:0];
            [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.view.userInteractionEnabled = YES;
    [appDelegate showActivity:self.view showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"YES");
        LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:alertView.tag];
        selectedRow = alertView.tag;
        [self callDeletePlaceRatingService:feedPost.placeReviewID];
    }
}

#pragma mark - Rootview Delegate

-(void)AlertDialogDidComplete:(id)view
{
    if ([view isKindOfClass:[AddPlaceRatingOverlay class]]) {
        AddPlaceRatingOverlay *overlay = (AddPlaceRatingOverlay*)view;
        NSInteger tag = overlay.tag;
        
        LifeFeedPost *lifeFeedPost = [self.arrLifeFeed objectAtIndex:tag];
        lifeFeedPost.averageRating = overlay.averageRating;
        lifeFeedPost.isAlreadyRated = YES;
        [self.arrLifeFeed replaceObjectAtIndex:tag withObject:lifeFeedPost];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)AlertDialogDidNotComplete:(id)view
{
    
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrLifeFeed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:indexPath.row];
    
    switch (feedPost.feedType) {
        case EVENT_TYPE:
            cell = [self configureEventPostCellAtIndexPath:indexPath withTableView:tableView];
            break;
        case OFFER_TYPE:
            cell = [self configureOfferPostCellAtIndexPath:indexPath withTableView:tableView];
            break;
        case ACTIVITY_TYPE:
            cell = [self configureActivityCellAtIndexPath:indexPath withTableView:tableView];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:indexPath.row];
    if (feedPost.feedType == EVENT_TYPE) {
        float height = [feedPost.description RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:300.0];
        
        if (feedPost.isReadMoreExplanded) {
            height = height + 286;
            height = height + 21;
        } else {
            if (height >= 77.0) {
                height = 77.0 + 286;
                height = height + 21 + 5;
            } else {
                if (height < 17) {
                    height = 33;
                }
                height = height + 281;
            }
        }
        
        if ([feedPost.link length] > 0)
            height = height + 21;
        
        if ([feedPost.arrTickets count] > 1) {
            if (feedPost.isReadMoreTicketExpanded)
                height = height + ([feedPost.arrTickets count]*44) + 26;
            else
                height = height + 44 + 26;
        } else {
            height = height + 55;
        }
        
        if (indexPath.row == [self.arrLifeFeed count]-1)
            height = height  + 98 + 77 + 44;
        else
            height = height + 98 + 77 + 45;
        
        return height + 5;
        //return 711.0;
    } else if (feedPost.feedType == OFFER_TYPE) {
        float height = [feedPost.description RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:300.0];
        
        if (feedPost.isReadMoreExplanded) {
            height = height + 286;
            height = height + 21;
        } else {
            if (height >= 77.0) {
                height = 77.0 + 286;
                height = height + 21;
            } else {
                if (height < 17) {
                    height = 33;
                }
                height = height + 286;
            }
        }
        
        if ([feedPost.link length] > 0)
            height = height + 21;
        
        if (indexPath.row == [self.arrLifeFeed count]-1)
            height = height  + 98 + 77 + 44;
        else
            height = height + 98 + 77 + 45;
        
        return height + 5;
        //return 652.0;
    } else if (feedPost.feedType == ACTIVITY_TYPE) {
        float height = [feedPost.description RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:300.0];
        
        if (feedPost.isReadMoreExplanded) {
            height = height + 286;
            height = height + 21;
        } else {
            if (height >= 77.0) {
                height = 77.0 + 286;
                height = height + 21 + 5;
            } else {
                if (height < 17) {
                    height = 33;
                }
                height = height + 285;
            }
        }
        
        if ([feedPost.link length] > 0)
            height = height + 21;
        
        if (indexPath.row == [self.arrLifeFeed count]-1)
            height = height  + 98 + 77 + 44;
        else
            height = height + 98 + 77 + 45;
        
        return height + 5;
    }
    
    return 700.0;
}

#pragma mark - Configure cellForRowAtIndexPath

- (UITableViewCell*)configureEventPostCellAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView*)tableView
{
    NSString *simple=@"EventPostCell";
    EventPostCell *cell = (EventPostCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EventPostCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:indexPath.row];
    
    cell.lblUserName.text = feedPost.profileName;
    [cell.imgProfileUser setClipsToBounds: YES];
    [[cell.imgProfileUser layer] setMasksToBounds:YES];
    [[cell.imgProfileUser layer] setCornerRadius:cell.imgProfileUser.frame.size.width/2.0];
    if (feedPost.hasProfilePicture) {
        cell.imgProfileUser.imageURL = [NSURL URLWithString:feedPost.profileImagePath];
    } else {
        cell.imgProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    DYRateView *rateview1 = [[DYRateView alloc] initWithFrame:CGRectMake(56, 30, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview1.editable = NO;
    rateview1.rate = feedPost.profileRating;
    [cell.contentView addSubview:rateview1];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:feedPost.latitude longitude:feedPost.longitude];
    float meters = [self.currentLocation distanceFromLocation:loc];
    if (meters < 100) {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"Just away"];
    } else if (meters >= 1000) {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.f km away", meters/1000];
    } else {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.1f km away", roundf(meters)/1000];
    }
    
    if ([feedPost.arrPictures count] > 0) {
        cell.imvEventPost.imageURL = [NSURL URLWithString:[feedPost.arrPictures objectAtIndex:0]];
        [cell.btnEventPost setTag:indexPath.row];
        [cell.btnEventPost addTarget:self action:@selector(btnPlacePostImageAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.imvEventPost.image = [UIImage imageNamed:@"Thumbnailimg1.jpeg"];
    }
    
    cell.lblPictureCount.text = [NSString stringWithFormat:@"%d",feedPost.arrPictures.count];
    cell.lblEventTitle.text = feedPost.eventName;
    cell.lblEventLocation.text = feedPost.locationName;
    cell.lblLocationCategoryType.text = feedPost.categoryType;
    cell.lblLocationStreet.text = feedPost.address;
    if ([feedPost.state length]) {
        cell.lblLocationAddress.text = [NSString stringWithFormat:@"%@, %@", feedPost.city, feedPost.state];
    } else {
        cell.lblLocationAddress.text = [NSString stringWithFormat:@"%@", feedPost.city];
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
    cell.lblTagNames.text = category;
    [cell.btnBookmark setTag:indexPath.row];
    [cell.btnBookmark addTarget:self action:@selector(btnBookMarkLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblDescription.text = feedPost.description;
    cell.lblDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0];
    
    [cell.btnReadMore setTag:indexPath.row];
    [cell.btnReadMore addTarget:self action:@selector(btnReadMoreContentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (feedPost.isSelectedBookmark) {
        [cell.btnBookmark setSelected:YES];
    } else {
        [cell.btnBookmark setSelected:NO];
    }
    
    [cell.btnEventLink setTitle:feedPost.link forState:UIControlStateNormal];
    [cell.btnEventLink setTitle:feedPost.link forState:UIControlStateHighlighted];
    [cell.btnEventLink setTitle:feedPost.link forState:UIControlStateDisabled];
    [cell.btnEventLink addTarget:self action:@selector(btnPostLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    cell.lblEventTime.text = eventTime;
    cell.lblEventPostTime.text = feedPost.timeDifference;
    
    [cell.btnLike setTag:indexPath.row];
    [cell.btnLike addTarget:self action:@selector(btnLikeDislikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment setTag:indexPath.row];
    [cell.btnComment addTarget:self action:@selector(btnCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnShare setTag:indexPath.row];
    [cell.btnShare addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRePost setTag:indexPath.row];
    [cell.btnRePost addTarget:self action:@selector(btnRePOstAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (feedPost.isLike) {
        [cell.btnLike setSelected:YES];
    } else {
        [cell.btnLike setSelected:NO];
    }
    
    [cell.btnMoreTickets setTag:indexPath.row];
    if ([feedPost.arrTickets count] > 1) {
        [cell.btnMoreTickets addTarget:self action:@selector(btnMoreTicketsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell.btnLocation setTag:indexPath.row];
    [cell.btnLocation addTarget:self action:@selector(btnLocationDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMapView setTag:indexPath.row];
    [cell.btnMapView addTarget:self action:@selector(btnMapDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.mapview setDelegate:self];
    [[cell.mapview layer] setCornerRadius:2];
    SFAnnotation *sfAnnotation = [[SFAnnotation alloc] init];
    sfAnnotation.latitude = [NSNumber numberWithDouble:feedPost.latitude];
    sfAnnotation.longitude = [NSNumber numberWithDouble:feedPost.longitude];
    sfAnnotation.tag = indexPath.row;
    [cell.mapview addAnnotation:sfAnnotation];
    
    // start off by default location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = feedPost.latitude;
    newRegion.center.longitude = feedPost.longitude;
    newRegion.span.latitudeDelta = 0.005; // 0.912872
    newRegion.span.longitudeDelta = 0.005; // 0.909863
    [cell.mapview setRegion:newRegion animated:YES];
    
    float height = [feedPost.description RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:300.0];
    cell.lblDescription.numberOfLines = 0;
    
    float yOrigin = 0;
    
    if (feedPost.isReadMoreExplanded) {
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateNormal];
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateHighlighted];
        
        cell.btnReadMore.hidden = NO;
        CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
        cell.lblDescription.frame = frame;
        
        yOrigin = height + cell.lblDescription.frame.origin.y;
        cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
        yOrigin = yOrigin + cell.btnReadMore.frame.size.height + 4;
    } else {
        if (height >= 77.0) {
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateNormal];
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateHighlighted];
            
            cell.btnReadMore.hidden = NO;
            height = 77.0;
            
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            
            yOrigin = height + cell.lblDescription.frame.origin.y + 3;
            cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
            yOrigin = yOrigin + cell.btnReadMore.frame.size.height + 4;
        } else {
            cell.btnReadMore.hidden = YES;
            if (height < 17) {
                height = 34;
            }
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            yOrigin = height + cell.lblDescription.frame.origin.y - 3;
        }
    }
    
    if ([feedPost.link length] > 0) {
        cell.btnEventLink.frame = CGRectMake(cell.btnEventLink.frame.origin.x, yOrigin, cell.btnEventLink.frame.size.width, cell.btnEventLink.frame.size.height);
        yOrigin = yOrigin + cell.btnEventLink.frame.size.height + 8;
        [cell.btnEventLink  setHidden:NO];
    } else {
        [cell.btnEventLink  setHidden:YES];
        yOrigin = yOrigin + 3;
    }
    
    //Comment Yash
    
    if ([feedPost.arrTickets count] > 0) {
        if (feedPost.isReadMoreTicketExpanded) {
            float yLabelOrigin = 1;
            for (int i = 0; i < [feedPost.arrTickets count]; i++) {
                UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, yLabelOrigin, 300, 44)] autorelease];
                imageView.image = [UIImage imageNamed:@"ticket-post-box.png"];
                [cell.viewTicket addSubview:imageView];
                
                NSDictionary *dict = [feedPost.arrTickets objectAtIndex:i];
                
                UILabel *lblTicket = [[[UILabel alloc] initWithFrame:CGRectMake(46, yLabelOrigin, 229, 44)] autorelease];
                lblTicket.text = [NSString stringWithFormat:@"%@: %@ %@", [dict objectForKey:@"ticketName"], [dict objectForKey:@"price"], [dict objectForKey:@"currency"]];
                [lblTicket setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
                [lblTicket setTextColor:[UIColor whiteColor]];
                lblTicket.numberOfLines = 2;
                lblTicket.textAlignment = NSTextAlignmentCenter;
                
                [cell.viewTicket addSubview:lblTicket];
                yLabelOrigin = yLabelOrigin + lblTicket.frame.size.height + 4;
            }
            
            cell.btnMoreTickets.frame = CGRectMake(cell.btnMoreTickets.frame.origin.x, yLabelOrigin, cell.btnMoreTickets.frame.size.width, cell.btnMoreTickets.frame.size.height);
            yLabelOrigin = yLabelOrigin + cell.btnMoreTickets.frame.size.height;
            cell.viewTicket.frame = CGRectMake(cell.viewTicket.frame.origin.x, yOrigin, cell.viewTicket.frame.size.width, yLabelOrigin);
        } else {
            float yLabelOrigin = 1;
            for (int i = 0; i < 1; i++) {
                UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, yLabelOrigin, 300, 44)] autorelease];
                imageView.image = [UIImage imageNamed:@"ticket-post-box.png"];
                [cell.viewTicket addSubview:imageView];
                
                NSDictionary *dict = [feedPost.arrTickets objectAtIndex:0];
                
                UILabel *lblTicket = [[[UILabel alloc] initWithFrame:CGRectMake(46, yLabelOrigin, 229, 44)] autorelease];
                lblTicket.text = [NSString stringWithFormat:@"%@: %@ %@", [dict objectForKey:@"ticketName"], [dict objectForKey:@"price"], [dict objectForKey:@"currency"]];
                [lblTicket setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
                [lblTicket setTextColor:[UIColor whiteColor]];
                lblTicket.numberOfLines = 2;
                lblTicket.textAlignment = NSTextAlignmentCenter;
                
                [cell.viewTicket addSubview:lblTicket];
                yLabelOrigin = yLabelOrigin + lblTicket.frame.size.height + 4;
            }
            
            cell.btnMoreTickets.frame = CGRectMake(cell.btnMoreTickets.frame.origin.x, yLabelOrigin, cell.btnMoreTickets.frame.size.width, cell.btnMoreTickets.frame.size.height);
            yLabelOrigin = yLabelOrigin + cell.btnMoreTickets.frame.size.height;
            cell.viewTicket.frame = CGRectMake(cell.viewTicket.frame.origin.x, yOrigin, cell.viewTicket.frame.size.width, yLabelOrigin);
        }
        
        if ([feedPost.arrTickets count] == 1) {
            cell.viewTicket.frame = CGRectMake(cell.viewTicket.frame.origin.x, yOrigin, cell.viewTicket.frame.size.width, cell.viewTicket.frame.size.height);
            yOrigin = yOrigin + cell.viewTicket.frame.size.height - 18;
        } else {
            yOrigin = yOrigin + cell.viewTicket.frame.size.height;
        }
        
        [cell.viewTicket setHidden:NO];
        
    } else {
        [cell.viewTicket setHidden:NO];
        float yLabelOrigin = 1;
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, yLabelOrigin, 300, 44)] autorelease];
        imageView.image = [UIImage imageNamed:@"ticket-post-box.png"];
        [cell.viewTicket addSubview:imageView];
        
        UILabel *lblTicket = [[[UILabel alloc] initWithFrame:CGRectMake(46, yLabelOrigin, 229, 44)] autorelease];
        lblTicket.text = @"Tickets are not available";
        [lblTicket setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
        [lblTicket setTextColor:[UIColor whiteColor]];
        lblTicket.numberOfLines = 2;
        lblTicket.textAlignment = NSTextAlignmentCenter;
        
        [cell.viewTicket addSubview:lblTicket];
        
        cell.viewTicket.frame = CGRectMake(cell.viewTicket.frame.origin.x, yOrigin, cell.viewTicket.frame.size.width, cell.viewTicket.frame.size.height);
        yOrigin = yOrigin + cell.viewTicket.frame.size.height - 18;
        
        cell.lblTicketAvailable.text = @"Tickets are not available";
    }
    
    cell.locationSection.frame = CGRectMake(cell.locationSection.frame.origin.x, yOrigin, cell.locationSection.frame.size.width, cell.locationSection.frame.size.height);
    yOrigin = yOrigin + cell.locationSection.frame.size.height;
    
    cell.viewInviteFriend.frame = CGRectMake(cell.viewInviteFriend.frame.origin.x, yOrigin, cell.viewInviteFriend.frame.size.width, cell.viewInviteFriend.frame.size.height);
    yOrigin = yOrigin + cell.viewInviteFriend.frame.size.height;
    cell.viewLikeComment.frame = CGRectMake(cell.viewLikeComment.frame.origin.x, yOrigin, cell.viewLikeComment.frame.size.width, cell.viewLikeComment.frame.size.height);
    
    cell.imvLine1.frame = CGRectMake(cell.imvLine1.frame.origin.x, cell.imvLine1.frame.origin.y, cell.imvLine1.frame.size.width, 0.7);
    //    cell.imgLine2.frame = CGRectMake(cell.imgLine2.frame.origin.x, cell.imgLine2.frame.origin.y, cell.imgLine2.frame.size.width, 0.7);
    
    [[cell.viewLikeComment layer] setBorderWidth:0.7];
    [[cell.viewLikeComment layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    
    return cell;
}

- (UITableViewCell*)configureOfferPostCellAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView*)tableView
{
    NSString *simple=@"OfferPostCell";
    OfferPostCell *cell = (OfferPostCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"OfferPostCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:indexPath.row];
    
    cell.lblUserName.text = feedPost.profileName;
    if (feedPost.hasProfilePicture) {
        cell.imgProfileUser.imageURL = [NSURL URLWithString:feedPost.profileImagePath];
    } else {
        cell.imgProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    DYRateView *rateview1 = [[DYRateView alloc] initWithFrame:CGRectMake(56, 30, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview1.editable = NO;
    rateview1.rate = feedPost.profileRating;
    [cell.contentView addSubview:rateview1];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:feedPost.latitude longitude:feedPost.longitude];
    float meters = [self.currentLocation distanceFromLocation:loc];
    if (meters < 100) {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"Just away"];
    } else if (meters >= 1000) {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.f km away", meters/1000];
    } else {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.1f km away", roundf(meters)/1000];
    }
    
    if ([feedPost.arrPictures count] > 0) {
        cell.imvOfferPost.imageURL = [NSURL URLWithString:[feedPost.arrPictures objectAtIndex:0]];
        [cell.btnOfferPost setTag:indexPath.row];
        [cell.btnOfferPost addTarget:self action:@selector(btnPlacePostImageAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.imvOfferPost.image = [UIImage imageNamed:@"Thumbnailimg1.jpeg"];
    }
    
    cell.lblPictureCount.text = [NSString stringWithFormat:@"%d",feedPost.arrPictures.count];
    cell.lblOfferTitle.text = feedPost.eventName;
    cell.lblOfferLocation.text = feedPost.locationName;
    cell.lblLocationCategoryType.text = feedPost.categoryType;
    cell.lblLocationStreet.text = feedPost.address;
    if ([feedPost.state length]) {
        cell.lblLocationAddress.text = [NSString stringWithFormat:@"%@, %@", feedPost.city, feedPost.state];
    } else {
        cell.lblLocationAddress.text = [NSString stringWithFormat:@"%@", feedPost.city];
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
    cell.lblTagNames.text = category;
    [cell.btnBookmark setTag:indexPath.row];
    [cell.btnBookmark addTarget:self action:@selector(btnBookMarkLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblDescription.text = feedPost.description;
    cell.lblDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0];
    
    [cell.btnReadMore setTag:indexPath.row];
    [cell.btnReadMore addTarget:self action:@selector(btnReadMoreContentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (feedPost.isSelectedBookmark) {
        [cell.btnBookmark setSelected:YES];
    } else {
        [cell.btnBookmark setSelected:NO];
    }
    
    [cell.btnOfferLink setTitle:feedPost.link forState:UIControlStateNormal];
    [cell.btnOfferLink setTitle:feedPost.link forState:UIControlStateHighlighted];
    [cell.btnOfferLink setTitle:feedPost.link forState:UIControlStateDisabled];
    [cell.btnOfferLink addTarget:self action:@selector(btnPostLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    cell.lblOfferTime.text = eventTime;
    cell.lblOfferPrice.text = feedPost.price;
    cell.lblOfferPostTime.text = feedPost.timeDifference;
    
    [cell.btnLike setTag:indexPath.row];
    [cell.btnLike addTarget:self action:@selector(btnLikeDislikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment setTag:indexPath.row];
    [cell.btnComment addTarget:self action:@selector(btnCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnShare setTag:indexPath.row];
    [cell.btnShare addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRePost setTag:indexPath.row];
    [cell.btnRePost addTarget:self action:@selector(btnRePOstAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (feedPost.isLike) {
        [cell.btnLike setSelected:YES];
    } else {
        [cell.btnLike setSelected:NO];
    }
    
    [cell.btnLocation setTag:indexPath.row];
    [cell.btnLocation addTarget:self action:@selector(btnLocationDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMapView setTag:indexPath.row];
    [cell.btnMapView addTarget:self action:@selector(btnMapDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.mapview setDelegate:self];
    [[cell.mapview layer] setCornerRadius:2];
    SFAnnotation *sfAnnotation = [[SFAnnotation alloc] init];
    sfAnnotation.latitude = [NSNumber numberWithDouble:feedPost.latitude];
    sfAnnotation.longitude = [NSNumber numberWithDouble:feedPost.longitude];
    sfAnnotation.tag = indexPath.row;
    [cell.mapview addAnnotation:sfAnnotation];
    
    // start off by default location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = feedPost.latitude;
    newRegion.center.longitude = feedPost.longitude;
    newRegion.span.latitudeDelta = 0.005; // 0.912872
    newRegion.span.longitudeDelta = 0.005; // 0.909863
    [cell.mapview setRegion:newRegion animated:YES];
    
    float height = [feedPost.description RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:300.0];
    cell.lblDescription.numberOfLines = 0;
    
    float yOrigin = 0;
    
    if (feedPost.isReadMoreExplanded) {
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateNormal];
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateHighlighted];
        
        cell.btnReadMore.hidden = NO;
        CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
        cell.lblDescription.frame = frame;
        
        yOrigin = height + cell.lblDescription.frame.origin.y;
        cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
        yOrigin = yOrigin + cell.btnReadMore.frame.size.height + 4;
    } else {
        if (height >= 77.0) {
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateNormal];
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateHighlighted];
            
            cell.btnReadMore.hidden = NO;
            height = 77.0;
            
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            
            yOrigin = height + cell.lblDescription.frame.origin.y + 3;
            cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
            yOrigin = yOrigin + cell.btnReadMore.frame.size.height + 4;
        } else {
            cell.btnReadMore.hidden = YES;
            if (height < 17) {
                height = 34;
            }
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            yOrigin = height + cell.lblDescription.frame.origin.y - 3;
        }
    }
    
    if ([feedPost.link length] > 0) {
        cell.btnOfferLink.frame = CGRectMake(cell.btnOfferLink.frame.origin.x, yOrigin, cell.btnOfferLink.frame.size.width, cell.btnOfferLink.frame.size.height);
        yOrigin = yOrigin + cell.btnOfferLink.frame.size.height + 8;
        [cell.btnOfferLink  setHidden:NO];
    } else {
        [cell.btnOfferLink  setHidden:YES];
        yOrigin = yOrigin + 3;
    }

    
    //Comment Yash
    cell.locationSection.frame = CGRectMake(cell.locationSection.frame.origin.x, yOrigin, cell.locationSection.frame.size.width, cell.locationSection.frame.size.height);
    yOrigin = yOrigin + cell.locationSection.frame.size.height;
    
    cell.viewInviteFriend.frame = CGRectMake(cell.viewInviteFriend.frame.origin.x, yOrigin, cell.viewInviteFriend.frame.size.width, cell.viewInviteFriend.frame.size.height);
    yOrigin = yOrigin + cell.viewInviteFriend.frame.size.height;
    cell.viewLikeComment.frame = CGRectMake(cell.viewLikeComment.frame.origin.x, yOrigin, cell.viewLikeComment.frame.size.width, cell.viewLikeComment.frame.size.height);
    
    cell.imgLine1.frame = CGRectMake(cell.imgLine1.frame.origin.x, cell.imgLine1.frame.origin.y, cell.imgLine1.frame.size.width, 0.7);
    
    [[cell.viewLikeComment layer] setBorderWidth:0.7];
    [[cell.viewLikeComment layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    
    return cell;
}

- (UITableViewCell*)configureActivityCellAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView*)tableView
{
    NSString *simple=@"Simple";
    ProfileViewCell *cell = (ProfileViewCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ProfileViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:indexPath.row];
    
    DYRateView *rateview1 = [[DYRateView alloc] initWithFrame:CGRectMake(56, 30, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview1.editable = NO;
    rateview1.rate = feedPost.profileRating;
    [cell.contentView addSubview:rateview1];
    
    [cell.btnPlaceLink setTitle:feedPost.link forState:UIControlStateDisabled];
    [cell.btnPlaceLink addTarget:self action:@selector(btnPostLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (feedPost.isSelectedBookmark) {
        [cell.btnBookmark setSelected:YES];
    } else {
        [cell.btnBookmark setSelected:NO];
    }
    
    if (feedPost.isLike) {
        [cell.btnLike setSelected:YES];
    } else {
        [cell.btnLike setSelected:NO];
    }
    
    [cell.btnReadMore setTag:indexPath.row];
    [cell.btnReadMore addTarget:self action:@selector(btnReadMoreContentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnBookmark setTag:indexPath.row];
    [cell.btnBookmark addTarget:self action:@selector(btnBookMarkLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnLike setTag:indexPath.row];
    [cell.btnLike addTarget:self action:@selector(btnLikeDislikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnComment setTag:indexPath.row];
    [cell.btnComment addTarget:self action:@selector(btnCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnShare setTag:indexPath.row];
    [cell.btnShare addTarget:self action:@selector(btnShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRePost setTag:indexPath.row];
    [cell.btnRePost addTarget:self action:@selector(btnRePOstAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.imgProfileUser setClipsToBounds: YES];
    [[cell.imgProfileUser layer] setMasksToBounds:YES];
    [[cell.imgProfileUser layer] setCornerRadius:cell.imgProfileUser.frame.size.width/2.0];
    if (feedPost.hasProfilePicture) {
        cell.imgProfileUser.imageURL = [NSURL URLWithString:feedPost.profileImagePath];
    } else {
        cell.imgProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    cell.lblUserName.text = feedPost.profileName;
    cell.lblActivityTitle.text = feedPost.eventName;
    cell.lblFirstLocationName.text = feedPost.locationName;
    cell.lblCategoryType.text = feedPost.categoryType;
    
    cell.lblDescription.text = feedPost.description;
    cell.lblDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0];
    cell.lblTime.text = feedPost.timeDifference;
    
    if ([feedPost.arrPictures count] > 0) {
        cell.imvPlacePost.imageURL = [NSURL URLWithString:[feedPost.arrPictures objectAtIndex:0]];
        [cell.btnPlacePost setTag:indexPath.row];
        [cell.btnPlacePost addTarget:self action:@selector(btnPlacePostImageAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.imvPlacePost.image = [UIImage imageNamed:@"Thumbnailimg1.jpeg"];
    }
    
    cell.lblPictureCount.text = [NSString stringWithFormat:@"%d",feedPost.arrPictures.count];
    [cell.btnPlaceLink setTitle:feedPost.link forState:UIControlStateNormal];
    [cell.btnPlaceLink setTitle:feedPost.link forState:UIControlStateHighlighted];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:feedPost.latitude longitude:feedPost.longitude];
    float meters = [self.currentLocation distanceFromLocation:loc];
    if (meters < 100) {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"Just away"];
    } else if (meters >= 1000) {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.f km away", meters/1000];
    } else {
        cell.lblDistanceFromLocation.text = [NSString stringWithFormat:@"%.1f km away", roundf(meters)/1000];
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
    cell.lblTagNames.text = category;
    
    cell.lblSecondLocationName.text = feedPost.locationName;
    cell.lblLocationCategoryType.text = feedPost.categoryType;
    cell.lblLocationStreet.text = feedPost.address;
    if ([feedPost.state length]) {
        cell.lblLocationAddress.text = [NSString stringWithFormat:@"%@, %@", feedPost.city, feedPost.state];
    } else {
        cell.lblLocationAddress.text = [NSString stringWithFormat:@"%@", feedPost.city];
    }
    
    [cell.btnLocation setTag:indexPath.row];
    [cell.btnLocation addTarget:self action:@selector(btnLocationDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMapView setTag:indexPath.row];
    [cell.btnMapView addTarget:self action:@selector(btnMapDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.mapview setDelegate:self];
    [[cell.mapview layer] setCornerRadius:2];
    SFAnnotation *sfAnnotation = [[SFAnnotation alloc] init];
    sfAnnotation.latitude = [NSNumber numberWithDouble:feedPost.latitude];
    sfAnnotation.longitude = [NSNumber numberWithDouble:feedPost.longitude];
    sfAnnotation.tag = indexPath.row;
    [cell.mapview addAnnotation:sfAnnotation];
    
    // start off by default location
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = feedPost.latitude;
    newRegion.center.longitude = feedPost.longitude;
    newRegion.span.latitudeDelta = 0.005; // 0.912872
    newRegion.span.longitudeDelta = 0.005; // 0.909863
    [cell.mapview setRegion:newRegion animated:YES];
    
    float height = [feedPost.description RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:300.0];
    cell.lblDescription.numberOfLines = 0;
    
    float yOrigin = 0;
    
    if (feedPost.isReadMoreExplanded) {
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateNormal];
        [cell.btnReadMore setTitle:@"READ LESS" forState:UIControlStateHighlighted];
        
        cell.btnReadMore.hidden = NO;
        CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
        cell.lblDescription.frame = frame;
        
        yOrigin = height + cell.lblDescription.frame.origin.y;
        cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
        yOrigin = yOrigin + cell.btnReadMore.frame.size.height + 4;
    } else {
        if (height >= 77.0) {
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateNormal];
            [cell.btnReadMore setTitle:@"READ MORE" forState:UIControlStateHighlighted];
            
            cell.btnReadMore.hidden = NO;
            height = 77.0;
            
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            
            yOrigin = height + cell.lblDescription.frame.origin.y + 3;
            cell.btnReadMore.frame = CGRectMake(cell.btnReadMore.frame.origin.x, yOrigin, cell.btnReadMore.frame.size.width, cell.btnReadMore.frame.size.height);
            yOrigin = yOrigin + cell.btnReadMore.frame.size.height + 4;
        } else {
            cell.btnReadMore.hidden = YES;
            if (height < 17) {
                height = 34;
            }
            CGRect frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblDescription.frame.origin.y, cell.lblDescription.frame.size.width, height);
            cell.lblDescription.frame = frame;
            yOrigin = height + cell.lblDescription.frame.origin.y - 3;
        }
    }
    
    if ([feedPost.link length] > 0) {
        cell.btnPlaceLink.frame = CGRectMake(cell.btnPlaceLink.frame.origin.x, yOrigin, cell.btnPlaceLink.frame.size.width, cell.btnPlaceLink.frame.size.height);
        yOrigin = yOrigin + cell.btnPlaceLink.frame.size.height + 8;
        [cell.btnPlaceLink  setHidden:NO];
    } else {
        [cell.btnPlaceLink  setHidden:YES];
        yOrigin = yOrigin + 3;
    }
    
    cell.locationSection.frame = CGRectMake(cell.locationSection.frame.origin.x, yOrigin, cell.locationSection.frame.size.width, cell.locationSection.frame.size.height);
    yOrigin = yOrigin + cell.locationSection.frame.size.height;
    
    //Comment Yash
    cell.viewRatePlace.frame = CGRectMake(cell.viewRatePlace.frame.origin.x, yOrigin, cell.viewRatePlace.frame.size.width, cell.viewRatePlace.frame.size.height);
    yOrigin = yOrigin + cell.viewRatePlace.frame.size.height;
    cell.viewLikeComment.frame = CGRectMake(cell.viewLikeComment.frame.origin.x, yOrigin, cell.viewLikeComment.frame.size.width, cell.viewLikeComment.frame.size.height);
    
    cell.imgLine1.frame = CGRectMake(cell.imgLine1.frame.origin.x, cell.imgLine1.frame.origin.y, cell.imgLine1.frame.size.width, 0.7);
    [[cell.viewLikeComment layer] setBorderWidth:0.7];
    [[cell.viewLikeComment layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    
    return cell;
}


#pragma mark - Cell Button Methods

- (void)btnPostLinkAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSString *link = [button titleForState:UIControlStateDisabled];
    
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

- (IBAction)btnMoreTicketsAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    if (feedPost.isReadMoreTicketExpanded) {
        feedPost.isReadMoreTicketExpanded = NO;
        
        [self.arrLifeFeed replaceObjectAtIndex:button.tag withObject:feedPost];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        feedPost.isReadMoreTicketExpanded = YES;
        [self.arrLifeFeed replaceObjectAtIndex:button.tag withObject:feedPost];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void)btnReadMoreContentAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    if (feedPost.isReadMoreExplanded) {
        feedPost.isReadMoreExplanded = NO;
        
        [self.arrLifeFeed replaceObjectAtIndex:button.tag withObject:feedPost];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        feedPost.isReadMoreExplanded = YES;
        [self.arrLifeFeed replaceObjectAtIndex:button.tag withObject:feedPost];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
        [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)btnBookMarkLinkAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    if (feedPost.isSelectedBookmark) {
        feedPost.isSelectedBookmark = NO;
    } else {
        feedPost.isSelectedBookmark = YES;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)btnLikeDislikeAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    if (feedPost.isLike) {
        feedPost.isLike = NO;
    } else {
        feedPost.isLike = YES;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [tblProfile reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)btnCommentAction:(id)sender
{
    
}

- (void)btnShareAction:(id)sender
{
    
}

- (void)btnRePOstAction:(id)sender
{
    
}

- (void)btnRatePlaceAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    if (feedPost.isAlreadyRated) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"are you sure that you want to remove rating ?"
                                                       delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
        [alert setTag:button.tag];
        [alert release];
    } else {
        [AddPlaceRatingOverlay showAlert:feedPost delegate:self withParentView:self.view withTag:button.tag];
    }
}

- (void)btnPlacePostImageAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    [PictureListingOverlay showAlert:feedPost.arrPictures delegate:self withTag:1 currentIndex:0];
}

- (void)btnLocationDetailAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    LocationDetailViewController *viewController = [[LocationDetailViewController alloc] initWithNibName:@"LocationDetailViewController" bundle:nil];
    viewController.lifeFeedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)btnMapDetailAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    MapViewController *viewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
    viewController.lifeFeedPost = [self.arrLifeFeed objectAtIndex:button.tag];
    [self.navigationController pushViewController:viewController animated:YES];
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
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = NO;
            
            LifeFeedPost *feedPost = [self.arrLifeFeed objectAtIndex:((SFAnnotation*)annotation).tag];
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

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
