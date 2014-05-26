

//
//  AppDelegate.m
//  LifeSter
//
//  Created by App Developer on 24/01/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//  provisionfile >>>>> com.massoftind.${PRODUCT_NAME:rfc1034identifier}

#import "AppDelegate.h"
#import "ViewController_IPhone5.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "Constant.h"
#import "AlertHandler.h"
#import <Accounts/Accounts.h>
#import "InviteFacebookFriendViewController.h"
#import "WhatsGoingViewController.h"
#import "NearFriendViewController.h"
#import "MFSideMenu.h"
#import "NewProfileViewController.h"
#import "Settings.h"
#import "Settings_IPhone5.h"
#import "CategorySelectionViewController.h"
#import "FacebookFriendListViewController.h"
#import "UsernameViewController.h"

#import "NotificationViewController.h"
#import "MoreViewController.h"
#import "CityMenuViewController.h"
#import "SearchViewController.h"

@implementation AppDelegate

@synthesize EmailAddress,fNameStr,lNameStr,SexStr,DobStr,LocStr,imgUrl,FBID,accessToken,LoginFromFBFlag;
@synthesize LoginFlag,shouldRotate,flag,dt,userID,PassKey;
@synthesize myAudioPlayer;
@synthesize isSignUpWithFacebook, isLoginWithFacebook;
@synthesize dictFacebook;
@synthesize friendPickerController;
@synthesize alertPassowrd;
@synthesize navigationController;
@synthesize locationManager;
@synthesize IsNewFacebookRegistration;
@synthesize isWallAddedNewPost;
@synthesize tabBarController = _tabBarController;
@synthesize previousTabIndex;
@synthesize cityMenuView;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if(self.shouldRotate == NO) //shouldRotate is my flag
    {
        return (UIInterfaceOrientationMaskAll);
    }
    else {
        return (UIInterfaceOrientationMaskPortrait);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |  UIRemoteNotificationTypeSound)];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber < 0) [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    flag = -1;
    badgenumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    IsNewFacebookRegistration = NO;
    
    // Do initial setup
    int cacheSizeMemory = 16*1024*1024; // 16MB
    int cacheSizeDisk = 32*1024*1024;   // 32MB
    NSURLCache *sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [Foursquare2                                                                                                        setupFoursquareWithClientId:@"JEEH4WTNKNEZGQTXELNE5D0NNU535CGGMZ5HMD4FFQMN1ZXU"
                             secret:@"FX1JDXS2SWGLKWIIWWUS5AFABYCNJ2VSSKIQW5GGSCNTEY4J"
                        callbackURL:@"lifester://foursquare"];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.tintColor = [UIColor whiteColor];
    
    menuView = [[MenuView alloc] init];
    menuView.frame = CGRectMake(0, -568, menuView.frame.size.width, menuView.frame.size.height);
    //[self.window addSubview:menuView];
    
    self.tabBarController = [[UITabBarController alloc] init];
    [self.tabBarController setDelegate:self];
    
    LoginFlag = FALSE;
    flag=0;
    LoginFromFBFlag = @"0";
    dt = @"";
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"currentTab"];
    
    MFSideMenuContainerViewController *container = nil;
    container.panMode = MFSideMenuPanModeNone;

    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"userID"] length] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"PassKey"] length]) {
        
        if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            ViewController_IPhone5 *viewcontrollerObj12 = [[ViewController_IPhone5 alloc] initWithNibName:@"ViewController" bundle:nil];
            self.navigationController = [[CRNavigationController alloc] initWithRootViewController:viewcontrollerObj12];
            
            NearFriendViewController *rightMenuViewController = [[NearFriendViewController alloc] initWithNibName:@"NearFriendViewController" bundle:nil];
            CRNavigationController *naviController = [[[CRNavigationController alloc] initWithRootViewController:rightMenuViewController] autorelease];
            naviController.navigationBar.translucent = YES;
            self.window.rootViewController = self.navigationController;
        } else {
            // iPhone 5
            ViewController_IPhone5 *viewcontrollerObj22 = [[ViewController_IPhone5 alloc] initWithNibName:@"ViewController_IPhone5" bundle:nil];
            self.navigationController = [[CRNavigationController alloc] initWithRootViewController:viewcontrollerObj22];
            
            NearFriendViewController *rightMenuViewController = [[NearFriendViewController alloc] initWithNibName:@"NearFriendViewController" bundle:nil];
            CRNavigationController *naviController = [[[CRNavigationController alloc] initWithRootViewController:rightMenuViewController] autorelease];
            naviController.navigationBar.translucent = YES;
            self.window.rootViewController = self.navigationController;
        }
    } else {
        self.PassKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"PassKey"];
        self.userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"userID"];
        
        if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            ViewController_IPhone5 *viewcontrollerObj12 = [[ViewController_IPhone5 alloc] initWithNibName:@"ViewController" bundle:nil];
            self.navigationController = [[CRNavigationController alloc] initWithRootViewController:viewcontrollerObj12];
            self.window.rootViewController = self.navigationController;
            
            InviteFacebookFriendViewController *inviteFacebookFriendViewController = [[[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:inviteFacebookFriendViewController animated:NO];
            
            FacebookFriendListViewController *facebookFriendListViewController = [[[FacebookFriendListViewController alloc] initWithNibName:@"FacebookFriendListViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:facebookFriendListViewController animated:NO];
            
            [self initializeTabBarController];
        } else {
            // iPhone 5
            ViewController_IPhone5 *viewcontrollerObj22 = [[ViewController_IPhone5 alloc] initWithNibName:@"ViewController_IPhone5" bundle:nil];
            
            self.navigationController = [[CRNavigationController alloc] initWithRootViewController:viewcontrollerObj22];
            self.window.rootViewController = self.navigationController;
            
            InviteFacebookFriendViewController *inviteFacebookFriendViewController = [[[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:inviteFacebookFriendViewController animated:NO];
            
            FacebookFriendListViewController *facebookFriendListViewController = [[[FacebookFriendListViewController alloc] initWithNibName:@"FacebookFriendListViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:facebookFriendListViewController animated:NO];
            
            [self initializeTabBarController];
        }
    }
    
    if (IS_IOS7) {
    } else {
        UIImage *gradientImage44 = [[UIImage imageNamed:@"nav-status-bar.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        // Set the background image for *all* UINavigationBars
        [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                           forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:71.0/255.0 green:119.0/255.0 blue:149.0/255.0 alpha:1.0], UITextAttributeTextColor,
      [UIFont fontWithName:HELVETICANEUEMEDIUM size:10.0], UITextAttributeFont,
      nil] forState:UIControlStateSelected];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:175.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1.0], UITextAttributeTextColor,
      [UIFont fontWithName:HELVETICANEUEMEDIUM size:10.0], UITextAttributeFont,
      nil] forState:UIControlStateNormal];
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initializeTabBarController
{
    //First tab as Home Timeline
    WhatsGoingViewController *tabViewController1 = [[WhatsGoingViewController alloc] initWithNibName:@"WhatsGoingViewController" bundle:nil];
    CRNavigationController *navi1 = [[CRNavigationController alloc] initWithRootViewController:tabViewController1];
    
    //Second tab as Nearby
    NearFriendViewController *tabViewController2 = [[NearFriendViewController alloc] initWithNibName:@"NearFriendViewController" bundle:nil];
    CRNavigationController *navi2 = [[CRNavigationController alloc] initWithRootViewController:tabViewController2];
    
    //Third tab as Shoe City Menu icon
    CityMenuViewController *tabViewController3 = [[CityMenuViewController alloc] initWithNibName:@"CityMenuViewController" bundle:nil];
    CRNavigationController *navi3 = [[CRNavigationController alloc] initWithRootViewController:tabViewController3];
    
    //Fourth tab as Alerts (notification)
    NotificationViewController *tabViewController4 = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
    CRNavigationController *navi4 = [[CRNavigationController alloc] initWithRootViewController:tabViewController4];
    
    //Fifth tab as More
    MoreViewController *tabViewController5 = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    CRNavigationController *navi5 = [[CRNavigationController alloc] initWithRootViewController:tabViewController5];
    

    [self.tabBarController setViewControllers:[NSArray arrayWithObjects:navi1, navi2, navi3, navi4, navi5, nil]];
    [self.tabBarController setSelectedIndex:0];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
//    130 130 160//
    //tabBar.backgroundColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:160.0/255.0 alpha:1.0];
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    [tabBarItem1 setTitle:@"Board"];
    [tabBarItem2 setTitle:@"Nearby"];
    [tabBarItem4 setTitle:@"Alerts"];
    [tabBarItem5 setTitle:@"More"];
    
    tabBarItem3.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    tabBarItem3.title = nil;
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"city_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"city_normal.png"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"nearby_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"nearby_normal.png"]];
    [tabBarItem3 setFinishedSelectedImage:nil withFinishedUnselectedImage:[UIImage imageNamed:@"menu.png"]]; //activities-menu.png //menu.png
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"alerts_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"alerts_normal.png"]];
    [tabBarItem5 setFinishedSelectedImage:[UIImage imageNamed:@"more_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"more_normal.png"]];
    
    
    
    [self.navigationController pushViewController:self.tabBarController animated:NO];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{    
    if (self.tabBarController.selectedIndex == 2) {
        CRNavigationController *navigationcontroller = (CRNavigationController*)viewController;
        
        CRNavigationController *navi1 = [self.tabBarController.viewControllers objectAtIndex:previousTabIndex];
        [navigationcontroller.view addSubview:[[navi1.viewControllers lastObject] view]];
        
        [self addCityMenuOverlay];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (previousTabIndex == self.tabBarController.selectedIndex) {
        
    } else {
        previousTabIndex = self.tabBarController.selectedIndex;
    }
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	
	dt=[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] ;
	dt=[dt stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    // NSLog(@"token: %@",dt);
	[dt retain];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat:@"Error: %@",err];
    NSLog(@"Error Notification %@", str);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
   
    application.applicationIconBadgeNumber = 0; // notif.applicationIconBadgeNumber-1;
//    notif.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
//     for (NSString *Key in [userInfo valueForKey:@"aps"]) {
//        
//        if ([Key isEqualToString:@"sound"]) {
//            
//            if (![[NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"sound"]] isEqualToString:@"default"]) {
//                
//                NSString *TempStr = [NSString stringWithFormat:@"%@",[[userInfo valueForKey:@"aps"] valueForKey:@"sound"]];
//                
//                NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:[TempStr substringToIndex:[TempStr length]-4] ofType: @"mp3"];
//                NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
//                myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//                // myAudioPlayer.numberOfLoops = -1; //infinite loop
//                [myAudioPlayer play];
//            }
//        }
//    }

}

// this will appear as the title in the navigation bar
+ (UILabel *)titleLabelWithTitle:(NSString *)title {
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    lblTitle.font = [UIFont fontWithName:HELVETICANEUEMEDIUM size:17.0];
    lblTitle.text = title;
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    return [lblTitle autorelease];
}

- (UIView *)searchViewInNavigation
{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 191, 30)];
    searchView.backgroundColor = [UIColor clearColor];
    
    UIButton *btnSearchView = [[UIButton alloc] initWithFrame:searchView.frame];
    [btnSearchView addTarget:self action:@selector(btnSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnSearchView setBackgroundImage:[UIImage imageNamed:@"top-searchbar.png"] forState:UIControlStateNormal];
    [btnSearchView setBackgroundImage:[UIImage imageNamed:@"top-searchbar.png"] forState:UIControlStateHighlighted];
    btnSearchView.alpha = 0.7;
    [searchView addSubview:btnSearchView];
    
    UILabel *lblSearch = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 150, 28)];
    lblSearch.backgroundColor = [UIColor clearColor];
    lblSearch.font = [UIFont fontWithName:HELVETICANEUEMEDIUM size:15.0];
    lblSearch.textColor = [UIColor whiteColor];
    lblSearch.text = @"Explore happenings";
    lblSearch.textAlignment = NSTextAlignmentCenter;
    lblSearch.alpha = 0.7;
    [searchView addSubview:lblSearch];
    
    UIImageView *imvSearchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 14)];
    imvSearchIcon.image = [UIImage imageNamed:@"search_icon_explore.png"];
    imvSearchIcon.alpha = 0.7;
    [searchView addSubview:imvSearchIcon];
    
    searchView.alpha = 0.7;
    return searchView;
}

- (void)btnSearchAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    SearchViewController *viewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
    [UIView commitAnimations];
}

#pragma mark - MenuView Delegate

- (void)addCityMenuOverlay
{
    self.cityMenuView = [[CityMenuView alloc] initWithFrame:self.window.frame];
    self.cityMenuView.frame = self.window.frame;
    [self.window addSubview:self.cityMenuView];
    
    [self.cityMenuView.btnCityIcon setSelected:YES];
//    [self.tabBarController.navigationController setNavigationBarHidden:NO animated:NO];
    //[self.window bringSubviewToFront:self.navigationController.view];

}

- (void)removeCityMenuOverlay
{
    [self.cityMenuView removeFromSuperview];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)addMenuViewControllerOnWindow:(UIViewController*)viewContrller
{
    NSLog(@"Profile Image === %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfImage"]);
    menuView.imgProfile.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ProfImage"]]];
    
    [menuView.btnUserName setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"profileName"]] forState:UIControlStateNormal];
    menuView.delegate = self;
    menuView.parentViewController = viewContrller;
    [menuView.tblMenuList reloadData];
    
    CGRect frame = CGRectMake(0, 0, menuView.frame.size.width, menuView.frame.size.height);
    frame.origin.y = frame.origin.y - self.window.bounds.size.height;
    menuView.frame = frame;
    
    [UIView beginAnimations:@"animateMenuView" context:nil];
    [UIView setAnimationDuration:1.0];
    [menuView setFrame:self.window.frame]; //notice this is ON screen!
    [self.window bringSubviewToFront:menuView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [UIView commitAnimations];
}

- (void)didSelecteRowAtMenuIndex:(NSInteger)index parentViewController:(UIViewController *)viewController
{
    CGRect frame = CGRectMake(0, 0, menuView.frame.size.width, menuView.frame.size.height);
    frame.origin.y = frame.origin.y - self.window.bounds.size.height;
    
    [UIView beginAnimations:@"animateMenuView" context:nil];
    [UIView setAnimationDuration:1.0];
    [menuView setFrame:frame]; //notice this is ON screen!
    [UIView commitAnimations];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CRNavigationController *naviController = viewController.menuContainerViewController.centerViewController;    
    if (index == 0) {
        WhatsGoingViewController *myProfileObj = [[WhatsGoingViewController alloc] init];
        if (IsNewFacebookRegistration) {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], myProfileObj, nil];
            naviController.viewControllers = controllers;
        } else {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], myProfileObj, nil];
            naviController.viewControllers = controllers;
        }
    } else if (index == 1) {
        WhatsGoingViewController *myProfileObj = [[WhatsGoingViewController alloc] init];
        if (IsNewFacebookRegistration) {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], myProfileObj, nil];
            naviController.viewControllers = controllers;
        } else {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], myProfileObj, nil];
            naviController.viewControllers = controllers;
        }
    } else if (index == 2) {
        WhatsGoingViewController *myProfileObj = [[WhatsGoingViewController alloc] init];
        if (IsNewFacebookRegistration) {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], myProfileObj, nil];
            naviController.viewControllers = controllers;
        } else {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], myProfileObj, nil];
            naviController.viewControllers = controllers;
        }
    }
}

- (void)hideMenuView
{
    CGRect frame = CGRectMake(0, 0, menuView.frame.size.width, menuView.frame.size.height);
    frame.origin.y = frame.origin.y - self.window.bounds.size.height;
    
    [UIView beginAnimations:@"animateMenuView" context:nil];
    [UIView setAnimationDuration:1.0];
    [menuView setFrame:frame]; //notice this is ON screen!
    [UIView commitAnimations];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didSelectUserProfile:(UIViewController*)viewController
{
    CGRect frame = CGRectMake(0, 0, menuView.frame.size.width, menuView.frame.size.height);
    frame.origin.y = frame.origin.y - self.window.bounds.size.height;
    
    [UIView beginAnimations:@"animateMenuView" context:nil];
    [UIView setAnimationDuration:1.0];
    [menuView setFrame:frame]; //notice this is ON screen!
    [UIView commitAnimations];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CRNavigationController *naviController = viewController.menuContainerViewController.centerViewController;
    NewProfileViewController *myProfileObj = [[NewProfileViewController alloc] init];
    if (IsNewFacebookRegistration) {
        NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], myProfileObj, nil];
        naviController.viewControllers = controllers;
    } else {
        NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                [naviController.viewControllers objectAtIndex:1], [naviController.viewControllers objectAtIndex:2], myProfileObj, nil];
        naviController.viewControllers = controllers;
    }
}

- (NSString*)convertPostTimeToString:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //+0000
    NSDate *publishDate = [dateFormatter dateFromString:time];
    
    NSTimeInterval secondsElapsed = [publishDate timeIntervalSinceDate:[NSDate date]];
    int hours = (abs(secondsElapsed)) / 3600;// integer division to get the hours part
    int minutes = (abs(secondsElapsed) - (hours*3600)) / 60; // interval minus hours part (in seconds) divided by 60 yields minutes
    
    NSString *timeDiff = @"";
    if (hours >= 1 && hours <= 24) {
        timeDiff = [NSString stringWithFormat:@"%d hours ago",hours];
    } else if (hours == 0 && minutes < 60) {
        [dateFormatter setDateFormat:@"hh:mm a"];
        timeDiff = [NSString stringWithFormat:@"%02d minutes ago",minutes];
    } else if (hours > 24) {
        [dateFormatter setDateFormat:@"EEEE, hh:mm a"];
        timeDiff = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:publishDate]];
    }
    
    return timeDiff;
}

- (void)didSelectExploreView:(UIView *)viewController
{
    [self.window addSubview:menuView.searchView];
}

- (void)didSelecteSetting:(UIViewController*)viewController
{
    CGRect frame = CGRectMake(0, 0, menuView.frame.size.width, menuView.frame.size.height);
    frame.origin.y = frame.origin.y - self.window.bounds.size.height;
    
    [UIView beginAnimations:@"animateMenuView" context:nil];
    [UIView setAnimationDuration:1.0];
    [menuView setFrame:frame]; //notice this is ON screen!
    [UIView commitAnimations];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (IS_IPHONE_5) {
        Settings_IPhone5 *viewController = [[Settings_IPhone5 alloc] initWithNibName:@"Settings_IPhone5" bundle:nil];
        [self.navigationController pushViewController:viewController animated:NO];
    } else {
        Settings *viewController = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

#pragma mark - Custom Methods

- (NSString *) idForDevice
{
    NSString *result = @"";
    UIDevice *thisDevice = [UIDevice currentDevice];
    if ([thisDevice respondsToSelector: @selector(identifierForVendor)])
    {
        NSUUID *myID = [[UIDevice currentDevice] identifierForVendor];
        result = [myID UUIDString];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        result = [defaults objectForKey: @"appID"];
        if (!result)
        {
            CFUUIDRef myCFUUID = CFUUIDCreate(kCFAllocatorDefault);
            result = ( NSString *) CFUUIDCreateString(kCFAllocatorDefault, myCFUUID);
            [defaults setObject: result forKey: @"appID"];
            [defaults synchronize];
            CFRelease(myCFUUID);
        }
    }
    return result;
}


- (void)checkViews:(NSArray *)subviews {
    
    Class AVClass = [UIAlertView class];
    Class ASClass = [UIActionSheet class];
    Class KeyBoardClass = [UITextField class];
    
    for (UIView * subview in subviews){
        if ([subview isKindOfClass:AVClass]){
            [(UIAlertView *)subview dismissWithClickedButtonIndex:[(UIAlertView *)subview cancelButtonIndex] animated:NO];
            [(UIAlertView *)subview setHidden:YES];
        } else if ([subview isKindOfClass:ASClass]){
            [(UIActionSheet *)subview dismissWithClickedButtonIndex:[(UIActionSheet *)subview cancelButtonIndex] animated:NO];
        }
        else if ([subview isKindOfClass:KeyBoardClass]){
            [(UITextField *)subview resignFirstResponder];
        }
        else {
            [self checkViews:subview.subviews];
        }
    }
}

- (void)presentInviteFacebookFriendsPicker
{
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Invite Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentTab"];
    if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        [self.navigationController presentViewController:self.friendPickerController animated:YES completion:nil];
        //                    HomeVIew *viewcontrollerObj1 = [[[HomeVIew alloc] initWithNibName:@"HomeVIew" bundle:nil] autorelease];
        //                    [self.navController1 pushViewController:viewcontrollerObj1 animated:YES];
    }
    else
    {
        [self.navigationController presentViewController:self.friendPickerController animated:YES completion:nil];
        NSLog(@"FName === %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FName"]);
        
        // iPhone 5
        
        //                    HomeView_IPhone5 *viewcontrollerObj2 = [[[HomeView_IPhone5 alloc] initWithNibName:@"HomeView_IPhone5" bundle:nil] autorelease];
        //                    [self.navController2 pushViewController:viewcontrollerObj2 animated:YES];
    }
}

#pragma mark - UIAlertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 102) {
        if (buttonIndex == 1) {
//            [self UpdatePasswordWebServiceCall:[self.dictFacebook objectForKey:@"id"] isLoginWithFacebook:YES];
        } else {
            [self showActivityOnWindow:self.window showOrHide:NO];
        }
    } else if (alertView.tag == 103) {
        if (buttonIndex == 1) {
            UITextField *txtPassword = [alertView textFieldAtIndex:0];
            NSLog(@"%@",txtPassword.text);
            
            self.alertPassowrd = txtPassword.text;
            [self LoginWithFacebookWebServiceCall:NO];
            //[self UpdatePasswordWebServiceCall:txtPassword.text isLoginWithFacebook:NO];
        } else {
            [self showActivityOnWindow:self.window showOrHide:NO];
        }
    }
}

#pragma mark - Friends Picker Delegate

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSMutableString *text = [[NSMutableString alloc] init];
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class

    FBFrictionlessRecipientCache *friendCache = [[FBFrictionlessRecipientCache alloc] init];
    [friendCache prefetchAndCacheForSession:nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:[NSString stringWithFormat:@"Spotly check out this app."]
                                                    title:@"Spotly"
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSLog(@"Request Sent. %@", error);
                                                          }
                                                      }}
                                              friendCache:friendCache];
    
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
            if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
    }
    
    [self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self fillTextBoxAndDismiss:@"<Cancelled>"];
}

- (void)fillTextBoxAndDismiss:(NSString *)text {
    if([[UIScreen mainScreen] bounds].size.height == 480)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentTab"];
    if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
        [self LoginWithFacebookWebServiceCall:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=1001;
        [alert show];
        [alert release];
    }

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
    //NSLog(@"[applicationDidBecomeActive] applicationIconBadgeNumber: %d", [UIApplication sharedApplication].applicationIconBadgeNumber);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //NSLog(@"[applicationDidBecomeActive] applicationIconBadgeNumber: %d", [UIApplication sharedApplication].applicationIconBadgeNumber);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self checkViews:application.windows];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // [UIApplication sharedApplication].applicationIconBadgeNumber = badgenumber;
    
    //NSLog(@"[applicationDidBecomeActive] applicationIconBadgeNumber: %d", [UIApplication sharedApplication].applicationIconBadgeNumber);
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgenumber;
    
    badgenumber = 0;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    // sleep(3);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)showActivity:(UIView*)view showOrHide:(BOOL)showOrHide
{
    if (showOrHide) {
        [TJSpinner showHUDAddedTo:view];
    } else {
        [TJSpinner hideHUDForView:view];
    }
}

- (void)showActivityOnWindow:(UIWindow*)view showOrHide:(BOOL)showOrHide
{
    if (showOrHide) {
        [TJSpinner showHUDAddedToWindow:self.window];
    } else {
        [TJSpinner hideHUDForWindow:self.window];
    }
}


/*-function added by amit on 17/8/2013 to show guideline for unattended screen*/


/////////////////////////////// FaceBook ///////////////////////////////////

#pragma mark- FaceBook

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            NSLog(@"ABIR");
        {
            
        }
            break;
        case FBSessionStateClosed:
            break;
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FBSessionStateClosedLoginFailed ");
            NSLog(@"FBSessionStateClosedLoginFailed ERROR: %@", [error description]);
            [[FBSession activeSession] closeAndClearTokenInformation];
            
            break;
        default:
            break;
    }
    if (error) {
        NSLog(@"The error is : %@",error.localizedDescription);
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        self.isSignUpWithFacebook = NO;
        [self showActivityOnWindow:self.window showOrHide:NO];
    }
}

- (void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                }
            }];
        }
    }
}

- (void)openSession
{   
    @try {
        // Try something
        [self showActivityOnWindow:self.window showOrHide:YES];
        
        // user_photos
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"user_birthday",@"user_photos"]  allowLoginUI:YES completionHandler: ^(FBSession *session, FBSessionState state, NSError *error)
         {
             if(error)
             {
                 NSLog(@"Session error");
                 [self fbResync];
                 [NSThread sleepForTimeInterval:0.5];   //half a second
                 [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"user_birthday",@"user_photos"]
                                                    allowLoginUI:YES
                                               completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                   [self sessionStateChanged:session state:state error:error];
                                               }];
                 
             }
             
             [self sessionStateChanged:session state:state error:error];
             NSLog(@"The session is : %@",session);
             [[FBRequest requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection,NSDictionary<FBGraphUser> *user,NSError *error)
              {
                  if (!error)
                  {
                      NSLog(@"The details of user is :%@ and The Connection is :%@",user,connection);
                      
                      NSLog(@"---connectio is %@",[session accessTokenData].accessToken);
                      
                      self.dictFacebook = (NSMutableDictionary*)user;
                      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                      [dateFormat setDateFormat:@"MM/dd/yyyy"];
                      NSDate *date = [dateFormat dateFromString:[user valueForKey:@"birthday"]];
                      [dateFormat setDateFormat:@"yyyy-MM-dd"];
                      DobStr = [[dateFormat stringFromDate:date] retain];
                      
                      
                      // DobStr = [[user valueForKey:@"birthday"] retain];
                      EmailAddress = [[user valueForKey:@"email"] retain];
                      fNameStr = [[user valueForKey:@"first_name"] retain];
                      lNameStr = [[user valueForKey:@"last_name"] retain];
                      SexStr = [[user valueForKey:@"gender"] retain];
                      
                      NSArray *subStrings = [[[user valueForKey:@"location"] valueForKey:@"name"] componentsSeparatedByString:@","];
                      
                      LocStr = [[[subStrings objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
                      if ([LocStr isEqual:[NSNull null]] || LocStr == nil) {
                          LocStr = @"";
                      }
                      
                      [[NSUserDefaults standardUserDefaults]setObject:LocStr forKey:@"Country"];
                      
                      // LocStr = [[[user valueForKey:@"location"] valueForKey:@"name"] retain];
                      FBID = [[user valueForKey:@"id"] retain];
                      accessToken = [[session accessTokenData].accessToken retain];
                      
                      [[NSUserDefaults standardUserDefaults] setObject:EmailAddress forKey:@"EmailId"];
                      [[NSUserDefaults standardUserDefaults] setObject:FBID forKey:@"FBID"];
                      [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                      
                      
                      if ([[NSUserDefaults standardUserDefaults] boolForKey:@"NeedToCompareWithFacebookID"]) {
                          NSLog(@"Regular Email ID === %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"RegularEmailID"]);
                          if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"RegularEmailID"] isEqualToString:[user valueForKey:@"email"]]) {
                          } else {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                                              message:@"Email ID is not matched with Facebook logged user id. Please verify email id."
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                              [alert show];
                              [alert release];
                              
                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NeedToCompareWithFacebookID"];
                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RegularEmailID"];
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              
                              [self showActivityOnWindow:self.window showOrHide:NO];
                              return;
                          }
                          
                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NeedToCompareWithFacebookID"];
                          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RegularEmailID"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                      }
                      
                      
                      
                      if ([LoginFromFBFlag isEqualToString:@"0"]) {
                         
                      } else {
                          [self showActivityOnWindow:self.window showOrHide:NO];
                          if([[UIScreen mainScreen] bounds].size.height == 480)
                          {
                              Settings *SettingsObj = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
                              [SettingsObj addWebService];
                              [navigationController pushViewController:SettingsObj animated:NO];
                              [SettingsObj release];
                          }
                          else {
                              Settings_IPhone5 *SettingsObj = [[Settings_IPhone5 alloc] initWithNibName:@"Settings_IPhone5" bundle:nil];
                              [SettingsObj addWebService];
                              [navigationController pushViewController:SettingsObj animated:NO];
                              [SettingsObj release];
                          }
                      }
                      
                      
                      [FBRequestConnection startWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"user_picture" forKey:@"fields"] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                          NSLog(@"---Result %@",result);
                          imgUrl = [[[[result valueForKey:@"user_picture"] valueForKey:@"data"] valueForKey:@"url"] retain];
                          
                          ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.imgUrl]];
                          [request startSynchronous];
                          NSError *err = [request error];
                          if (!err) {
                              NSData *data  = [request responseData];
                              [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ImgUrl"];
                              
                              if ([LoginFromFBFlag isEqualToString:@"0"]) {
                                  if (isSignUpWithFacebook) {
                                      isSignUpWithFacebook = NO;
                                      [self showActivityOnWindow:self.window showOrHide:NO];
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"first_name"] forKey:@"FName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"last_name"] forKey:@"LName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:DobStr forKey:@"DOB"];
                                      
                                      sleep(1.0);
                                      [self checkUserAlreadyRegistered:[user valueForKey:@"email"]];
                                  } else if (isLoginWithFacebook) {
                                      isLoginWithFacebook = NO;
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"first_name"] forKey:@"FName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"last_name"] forKey:@"LName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:DobStr forKey:@"DOB"];
                                      [self LoginWithFacebookWebServiceCall:YES];
                                  }
                              }
                          } else {
                              if ([LoginFromFBFlag isEqualToString:@"0"]) {
                                  if (isSignUpWithFacebook) {
                                      isSignUpWithFacebook = NO;
                                      [self showActivityOnWindow:self.window showOrHide:NO];
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"first_name"] forKey:@"FName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"last_name"] forKey:@"LName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:DobStr forKey:@"DOB"];
                                      
                                      [self checkUserAlreadyRegistered:[user valueForKey:@"email"]];
                                  } else if (isLoginWithFacebook) {
                                      isLoginWithFacebook = NO;
                                      
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"first_name"] forKey:@"FName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:[user valueForKey:@"last_name"] forKey:@"LName"];
                                      [[NSUserDefaults standardUserDefaults] setObject:DobStr forKey:@"DOB"];
                                      [self LoginWithFacebookWebServiceCall:YES];
                                  }
                              }
                          }
                      }];
                  }
                  else {
                      NSDictionary *dictError = [[[error userInfo] objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"];
                      if ([[[dictError objectForKey:@"error"] objectForKey:@"code"] integerValue] != 2500) {
                          [self showActivityOnWindow:self.window showOrHide:NO];
                      }
                  }
              }];
         }];
    }
    @catch (NSException * exception) {
        NSLog(@"Exception: %@", exception);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:exception.description
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

-(void) logout {
    [self.dictFacebook removeAllObjects];
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
}

- (void)checkUserAlreadyRegistered:(NSString *)email
{
    flag = 4;
    
    int number = (arc4random()%99999999) + 1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_check_email" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setPostValue:email forKey:@"login_email_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)pushToUserViewController
{
    UsernameViewController *viewController = [[UsernameViewController alloc] initWithNibName:@"UsernameViewController" bundle:nil];
    [navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Registration service Method

-(void)RegistrationWithFacebookWebServiceCall {
    
    if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
    }
    else {
        [self showActivityOnWindow:self.window showOrHide:NO];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    flag = 1;
    LoginFlag = false;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    NSString *tempStr = @"";
    
    if ([SexStr isEqualToString:@"Male"] || [SexStr isEqualToString:@"male"]) {
        tempStr = @"M";
    } else {
        tempStr = @"F";
    }
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_registration" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    
    [request setPostValue:[self.dictFacebook objectForKey:@"email"] forKey:@"login_email_id"];
    [request setPostValue:[self.dictFacebook objectForKey:@"id"] forKey:@"login_password"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"FName"] forKey:@"f_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"LName"] forKey:@"l_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"] forKey:@"dob"];
    [request setPostValue:tempStr forKey:@"sex"];
    [request setPostValue:@"" forKey:@"street"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"City"] forKey:@"city_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"City_Short_Name"] forKey:@"city_short_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"State"] forKey:@"state_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"State_Short_Name"] forKey:@"state_short_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country"] forKey:@"country_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country_Short_Name"] forKey:@"country_short_name"];
//    [request setPostValue:appDelegateObj.didSelectChoiceID forKey:@"choice_id"];
    [request setPostValue:[NSNumber numberWithBool:YES] forKey:@"lwfb"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addData:[[NSUserDefaults standardUserDefaults] valueForKey:@"ImgUrl"] withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"image_file"];
    
    [request startAsynchronous];
    
}

-(void)postUpdate
{
    [FBSession openActiveSessionWithPublishPermissions:@[ @"publish_stream" ] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
        
        // If auth was successful, create a status update FBRequest
        if (!error) {
            UIImage *image = [UIImage imageNamed:@"120x120ios.png"];
            NSString *message = [NSString stringWithFormat:@"Welcome to Spotly \n"];
            message = [message stringByAppendingFormat:@"We want to wish you welcome and hope you'll enjoy interacting with your friends and explore the new ways of socializing."];
            
            NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              image, @"source",
                              message, @"message",
                              nil];
            
            FBRequest *postRequest = [FBRequest requestWithGraphPath:@"me/photos" parameters:dict HTTPMethod:@"post"];
            [postRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *err) {
                
                // TODO: Check for success / failure here
                if (err) {
                    NSLog(@"fail to post comment ====== %@",err);
                } else {
                    NSLog(@"Successful to post comment");
                }
            }];
        }
    }];
}

-(void)LoginWithFacebookWebServiceCall:(BOOL)status
{
    if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
    }
    else {
        [self showActivityOnWindow:self.window showOrHide:NO];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    self.LoginFlag=TRUE;
    
    flag=1;
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
#if TARGET_IPHONE_SIMULATOR
    self.dt = @"6f44395d0bbd6afd64bfba8710047bcabafb3a8d1bfa5725e398d0a2bbbe3359";
#endif
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *deviceVersion = [currentDevice systemVersion];
    NSString *name = [currentDevice name];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    uuidString = [[self idForDevice] retain];
    
    [[NSUserDefaults standardUserDefaults] setObject:[self.dictFacebook objectForKey:@"email"]  forKey:@"LogInID"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_login" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[self.dictFacebook objectForKey:@"email"] forKey:@"login_id"];
    if (status) {
        [request setPostValue:[self.dictFacebook objectForKey:@"id"] forKey:@"login_password"];
    } else{
        [request setPostValue:self.alertPassowrd forKey:@"login_password"];
    }
    
    [request setPostValue:appName forKey:@"appname"];
    [request setPostValue:appVersion forKey:@"appversion"];
    [request setPostValue:uuidString forKey:@"device_uid"];
    [request setPostValue:self.dt forKey:@"device_token"];
    [request setPostValue:name forKey:@"device_name"];
    [request setPostValue:model forKey:@"device_model"];
    [request setPostValue:deviceVersion forKey:@"device_version"];
    [request setPostValue:@"iOS" forKey:@"device_os"];
    [request setPostValue:push_mode forKey:@"push_mode"];
    [request setPostValue:[NSNumber numberWithBool:status] forKey:@"lwfb"];
    
    if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
        
        [request setPostValue:[NSString stringWithFormat:@"%f %f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude] forKey:@"gps_coordinate"];
    }
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

-(void)UpdatePasswordWebServiceCall:(NSString *)newPassword isLoginWithFacebook:(BOOL)status
{
    flag=3;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_updation" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setPostValue:[self.dictFacebook objectForKey:@"email"] forKey:@"login_email_id"];
    [request setPostValue:newPassword forKey:@"login_password"];
    [request setPostValue:[NSNumber numberWithBool:status] forKey:@"lwfb"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)getCurrentLocationDetailUsingGoogleAPI
{
    NSString *strURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?sensor=true&latlng=%f,%f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude];
    
    flag = 2;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    //[AlertHandler showAlertForProcess:@"Loading Location"];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (flag == 1) {
        if (self.LoginFlag==FALSE) {
            
            NSString *receivedString = [request responseString];
            
            NSDictionary *responseObject = [receivedString JSONValue];
            NSArray *items = [responseObject objectForKey:@"raws"];
            
            NSLog(@"Registration items  %@",items);
            
            if ([[[items valueForKey:@"status"] valueForKey:@"registration_status"] isEqualToString:@"true"] || [[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"101"]) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DOB"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Sex"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"City"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"City_Short_Name"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"State"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"State_Short_Name"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Country"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Country_Short_Name"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Choices"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImgUrl"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EmailId"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"type_3rdparty"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBID"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileName"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ProfImage"];
                
                self.LoginFromFBFlag = @"1";
                
                if ([[[items valueForKey:@"status"] valueForKey:@"registration_status"] isEqualToString:@"true"])
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsNewRegistration"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self postUpdate];
                }
                
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentTab"];
                if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
                    [self LoginWithFacebookWebServiceCall:YES];
                }
                else {
                    [self showActivityOnWindow:self.window showOrHide:NO];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alert.tag=1001;
                    [alert show];
                    [alert release];
                }
            }
            else {
                [self showActivityOnWindow:self.window showOrHide:NO];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
        else {
            NSString *receivedString = [request responseString];
            
            NSDictionary *responseObject = [receivedString JSONValue];
            NSArray *items = [responseObject objectForKey:@"raws"];
            
            if ([[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
                if([[UIScreen mainScreen] bounds].size.height == 480) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification4S" object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotificationIPhone5" object:nil];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissSignupScreenNotification" object:nil];
                
                self.userID = [[items valueForKey:@"dataset"] valueForKey:@"user_id"];
                self.PassKey = [[items valueForKey:@"dataset"] valueForKey:@"pass_key"];
                
                NSString *followingCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"following_count"]];
                NSString *followerCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"follower_count"]];
                [[NSUserDefaults standardUserDefaults] setObject:followingCount forKey:@"following_count"];
                [[NSUserDefaults standardUserDefaults] setObject:followerCount forKey:@"follower_count"];
                
                NSString *reviewCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"review_count"]];
                [[NSUserDefaults standardUserDefaults] setObject:reviewCount forKey:@"review_count"];
                
                NSString *avg_rating = [NSString stringWithFormat:@"%.2f",[[[items valueForKey:@"dataset"] valueForKey:@"avg_rating_profile"] floatValue]];
                [[NSUserDefaults standardUserDefaults] setObject:avg_rating forKey:@"profile_rating"];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:@"userID"];
                [[NSUserDefaults standardUserDefaults] setObject:self.PassKey forKey:@"PassKey"];
                
                if ([[[items valueForKey:@"dataset"] valueForKey:@"ProfileName"] class] == [NSNull class]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"profileName"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"ProfileName"] forKey:@"profileName"];
                }
                
                if ([[[items valueForKey:@"dataset"] valueForKey:@"username"] class] == [NSNull class]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"username"] forKey:@"username"];
                }
                
                if ([[[[items valueForKey:@"dataset"] valueForKey:@"profile_image"] valueForKey:@"has_profile_picture"] boolValue]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[[[items valueForKey:@"dataset"] valueForKey:@"profile_image"] valueForKey:@"image_url"] forKey:@"ProfImage"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:DEFAULTPROFILEIMAGE forKey:@"ProfImage"];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"f_name"] forKey:@"FName"];
                [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"l_name"] forKey:@"LName"];
                
                //-Added by amit on 21/8/2013
                
                [self showActivityOnWindow:self.window showOrHide:NO];
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsNewRegistration"]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsNewRegistration"];
                    CategorySelectionViewController *viewController = [[CategorySelectionViewController alloc] initWithNibName:@"CategorySelectionViewController" bundle:nil];
                    [self.navigationController pushViewController:viewController animated:YES];
                } else {
                    InviteFacebookFriendViewController *inviteFacebookFriendViewController = [[[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil] autorelease];
                    
                    if([[UIScreen mainScreen] bounds].size.height == 480)
                        [self.navigationController pushViewController:inviteFacebookFriendViewController animated:YES];
                    else
                        [self.navigationController pushViewController:inviteFacebookFriendViewController animated:YES];
                }
                
                
            } else if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"101"]) {
                NSLog(@"Status code is ==== 101");
                NSLog(@"User is not registered with this mail id");
                
                self.LoginFromFBFlag = @"0";
                self.isSignUpWithFacebook = YES;
                self.isLoginWithFacebook = NO;
                [self RegistrationWithFacebookWebServiceCall];
            } else if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"102"]) {
                
                
                NSString *message = [NSString stringWithFormat:@"Email Id Already Registered with Normal User. Do you want to continue with Facebook account ?"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                                message:message
                                                               delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                [alert setTag:102];
                [alert show];
                [alert release];
            }
            else if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"103"]) {
                //You are already registered with normal user not with facebook
                
                NSString *message = [NSString stringWithFormat:@"It looks like you already are a Spotly user. Enter account password for connecting you account with Facebook."];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.dictFacebook objectForKey:@"email"]
                                                                message:message
                                                               delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Continue", nil];
                [alert setTag:103];
                alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                [alert show];
                [alert release];
            } else {
                [self showActivityOnWindow:self.window showOrHide:NO];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
    } else if (flag == 2) {
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Location Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else {
            NSArray *items = [responseObject objectForKey:@"results"];
            NSArray *tempArr = [[items objectAtIndex:0] valueForKey:@"address_components"];
            
            for (int i=0; i<[tempArr count]; i++) {
                
                if ([[[tempArr objectAtIndex:i] valueForKey:@"types"] count]>0) {
                    
                    if ([[[[tempArr objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"locality"]) {
                        //self.city = [[tempArr objectAtIndex:i] valueForKey:@"long_name"];
                        // [[[[items objectAtIndex:0] valueForKey:@"address_components"] objectAtIndex:i] valueForKey:@"long_name"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[[tempArr objectAtIndex:i] valueForKey:@"long_name"] forKey:@"City"];
                        [[NSUserDefaults standardUserDefaults] setObject:[[tempArr objectAtIndex:i] valueForKey:@"short_name"] forKey:@"City_Short_Name"];
                    }
                    if ([[[[tempArr objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"administrative_area_level_1"]) {
                        //self.state = [[tempArr objectAtIndex:i] valueForKey:@"long_name"];
                        // [[[[items objectAtIndex:0] valueForKey:@"address_components"] objectAtIndex:i] valueForKey:@"long_name"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[[tempArr objectAtIndex:i] valueForKey:@"long_name"] forKey:@"State"];
                        [[NSUserDefaults standardUserDefaults] setObject:[[tempArr objectAtIndex:i] valueForKey:@"short_name"] forKey:@"State_Short_Name"];
                    }
                    if ([[[[tempArr objectAtIndex:i] valueForKey:@"types"] objectAtIndex:0] isEqualToString:@"country"]) {
                        //self.country = [[tempArr objectAtIndex:i] valueForKey:@"long_name"];
                        // [[[[items objectAtIndex:0] valueForKey:@"address_components"] objectAtIndex:i] valueForKey:@"long_name"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[[tempArr objectAtIndex:i] valueForKey:@"short_name"] forKey:@"Country_Short_Name"];
                    }
                }
            }
        }
    } else if (flag == 3) {
        
    } else if (flag == 4) {
        NSString *receivedString = [request responseString];
        NSDictionary *responseObject = [receivedString JSONValue];
        NSLog(@"EmailId Register ====== %@",responseObject);
        
        NSDictionary *items = [[responseObject objectForKey:@"raws"]objectForKey:@"status"];
        BOOL statusforEmail = [[items valueForKey:@"email_id_status"] boolValue];
        
        if (statusforEmail) {
            [self pushToUserViewController];
        } else {
            [self LoginWithFacebookWebServiceCall:YES];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    badgenumber++;
    
    [self showActivityOnWindow:self.window showOrHide:NO];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - Location Manager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
    [self getCurrentLocationDetailUsingGoogleAPI];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    locationManager.delegate = nil;
}


@end