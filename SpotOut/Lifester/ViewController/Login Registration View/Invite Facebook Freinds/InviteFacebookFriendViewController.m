//
//  InviteFacebookFriendViewController.m
//  Lifester
//
//  Created by Nikunj on 12/18/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "InviteFacebookFriendViewController.h"
#import "FacebookFriendListViewController.h"
#import "WhatsGoingViewController.h"
#import "NearFriendViewController.h"
#import "MFSideMenuContainerViewController.h"

@interface InviteFacebookFriendViewController ()

@end

@implementation InviteFacebookFriendViewController


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

#pragma mark - View life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    backgroundView.backgroundColor = VIEW_COLOR;
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Invite Friends"];
    
    // set right bar button items
    UIButton *btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSkip.frame = CGRectMake(25, 6, 56, 32);
    [btnSkip.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnSkip setTitle:@"  Skip" forState:UIControlStateNormal];
    [btnSkip.titleLabel setTextColor:[UIColor whiteColor]];
    [btnSkip addTarget:self action:@selector(btnSkipAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnSkip.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnSkip] autorelease];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
    if (!IS_IPHONE_5) {
        buttonInviteFbFriend.frame= CGRectMake(buttonInviteFbFriend.frame.origin.x, buttonInviteFbFriend.frame.origin.y - 30, buttonInviteFbFriend.frame.size.width, buttonInviteFbFriend.frame.size.height);
    }
    
    // hide back button manually
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 6, 56, 32);
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setHidden:YES];
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnBack] autorelease];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    appDelegateObj = (AppDelegate*)[[UIApplication sharedApplication]delegate];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    customnavi.iscomingfromInvite = YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIButton Methods

- (void)btnSkipAction:(id)sender
{
    /*
    FBFrictionlessRecipientCache *friendCache = [[FBFrictionlessRecipientCache alloc] init];
    [friendCache prefetchAndCacheForSession:nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession]
                                                  message:[NSString stringWithFormat:@"Spotly check out this app."]
                                                    title:@"Spotly"
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");app
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSLog(@"Request Sent. %@", error);
                                                          }
                                                      }}
                                              friendCache:friendCache];
    
    return;
    */
    
    
    if([[UIScreen mainScreen] bounds].size.height == 480) {
        FacebookFriendListViewController *facebookFriendListViewController = [[[FacebookFriendListViewController alloc] initWithNibName:@"FacebookFriendListViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:facebookFriendListViewController animated:NO];
        
//        WhatsGoingViewController  *viewcontrollerObj1 = [[[WhatsGoingViewController alloc] initWithNibName:@"WhatsGoingViewController" bundle:nil] autorelease];
//        [self.navigationController pushViewController:viewcontrollerObj1 animated:YES];
        
        [appDelegateObj initializeTabBarController];
        //[appDelegateObj.window addSubview:appDelegateObj.tabBarController.view];
        //[self.navigationController pushViewController:appDelegateObj.tabBarController animated:NO];
    } else {
        // iPhone 5
        FacebookFriendListViewController *facebookFriendListViewController = [[[FacebookFriendListViewController alloc] initWithNibName:@"FacebookFriendListViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:facebookFriendListViewController animated:NO];
        
//        WhatsGoingViewController *viewcontrollerObj2 = [[[WhatsGoingViewController alloc] initWithNibName:@"WhatsGoingViewController" bundle:nil] autorelease];
//        [self.navigationController pushViewController:viewcontrollerObj2 animated:YES];
        
        [appDelegateObj initializeTabBarController];
        //[appDelegateObj.window addSubview:appDelegateObj.tabBarController.view];
        //[self.navigationController pushViewController:appDelegateObj.tabBarController animated:NO];
    }
}

- (IBAction)btnInviteFriendAction:(id)sender
{
    FacebookFriendListViewController *facebookFriendListViewController = [[[FacebookFriendListViewController alloc] initWithNibName:@"FacebookFriendListViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:facebookFriendListViewController animated:YES];
}

#pragma mark - Web service Methods



@end
