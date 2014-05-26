//
//  ViewController_IPhone5.m
//  LifeSter
//
//  Created by App Developer on 24/01/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "ViewController_IPhone5.h"
#import "JSON.h"
#import "Reachability.h"
#import "AlertHandler.h"
#import "InviteFacebookFriendViewController.h"
#import "CategorySelectionViewController.h"
#import "SuggestPlaceViewController.h"
#import "AddEventViewController.h"
#import "OfferReviewViewController.h"
#import "NewProfileViewController.h"
#import "RateProfileViewController.h"
#import "ConversationViewController.h"
#import "NSString+Extensions.h"

@interface ViewController_IPhone5 ()

@end

@implementation ViewController_IPhone5

@synthesize swipeView;
@synthesize pageControl,ImageArr,fbGraph;

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.ImageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"slider1.png"],[UIImage imageNamed:@"slider2.png"],[UIImage imageNamed:@"slider3.png"],[UIImage imageNamed:@"slider4.png"],nil];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    
    appDelegateObj.shouldRotate = YES;
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithRed:37.0/255.0f green:77.0/255.0f blue:108.0/255.0f alpha:1.0];
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    isLoadFirstTime = YES;
    
    if (IS_IPHONE_5) {
        imvBackground.image = [UIImage imageNamed:@"slide5-1.png"];
    } else {
        imvBackground.image = [UIImage imageNamed:@"slide4s-1.png"];
    }
    slide = 1;
    
    appDelegateObj = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    btnFacebookSignUp.alpha = 0;
    btnLogin.alpha = 0;
    btnSignUp.alpha = 0;
    
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, 88,  22)];
//    imageView.image = [UIImage imageNamed:@"Login-topbar.png"];
//    self.navigationItem.titleView = imageView;
    
    //configure swipe view
//    swipeView.alignment = SwipeViewAlignmentCenter;
//    swipeView.pagingEnabled = YES;
//    swipeView.wrapEnabled = NO;
//    swipeView.itemsPerPage = 1;
//    swipeView.truncateFinalPage = YES;
//    
//    //configure page control
//    pageControl.numberOfPages = swipeView.numberOfPages;
//    pageControl.defersCurrentPageDisplay = YES;
    
    
    [NSTimer scheduledTimerWithTimeInterval:6.0
                                     target: self
                                   selector: @selector(changeSlideImage)
                                   userInfo: nil
                                    repeats: YES];
}

- (void)changeSlideImage
{
    slide++;
    if(slide > 4)//an array count perhaps
        slide = 1;
    
    //create the string as needed, example only
    NSString *theName = @"";
    if (IS_IPHONE_5) {
        theName = [NSString stringWithFormat:@"slide5-%d.png", slide];
    } else {
        theName = [NSString stringWithFormat:@"slide4s-%d.png", slide];
    }
    
    
    UIImage * toImage = [UIImage imageNamed:theName];
    [UIView transitionWithView:self.view
                      duration:1.75f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        imvBackground.image = toImage;
                    } completion:NULL];
    
}

- (UIImageView *)imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]]) {
        for (UIView* subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, pageControl.frame.size.width, pageControl.frame.size.height)];
            [view addSubview:dot];
        }
    } else {
        dot = (UIImageView *) view;
    }
    
    return dot;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    appDelegateObj.IsNewFacebookRegistration = NO;
    
    self.view.userInteractionEnabled = YES;
    fbGraph.flag=0;
    appDelegateObj.userID=@"";
    appDelegateObj.PassKey=@"";
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PassKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"choiceID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hangOutID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ProfImage"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    [UIView animateWithDuration:7.0 animations:^{
        // Animate the views on and off the screen. This will appear to slide.
        imgEarth.frame =CGRectMake( -320 , imgEarth.frame.origin.y, 320, imgEarth.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished)
        {
            // Remove the old view from its parent.
            [imgEarth removeFromSuperview];
        }
    }];
     */
    
    if (isLoadFirstTime) {
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:5.0];
        btnSignUp.alpha = 1.0;
        btnFacebookSignUp.alpha = 1.0;
        btnLogin.alpha = 1.0;
        [UIView commitAnimations];
        
        isLoadFirstTime = NO;
    }
}

-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [self.ImageArr count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    frontImg = (UIImageView *)view;
    
    //create or reuse view
    if (view == nil)
    {
        frontImg = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 170.0f)] autorelease];
        view = frontImg;
    }
    frontImg.image = [self.ImageArr objectAtIndex:index];
    //return view
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeview
{
    //update page control page
    pageControl.currentPage = swipeview.currentPage;
}

- (IBAction)pageControlTapped
{
    //update swipe view page
    [swipeView scrollToPage:pageControl.currentPage duration:0.4];
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    // NSLog(@"Selected item at index %i", index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)SignUpWithFb:(id)sender {
    
//    UsernameViewController *viewController = [[UsernameViewController alloc] initWithNibName:@"UsernameViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
//    return;

//    SuggestPlaceViewController *viewController1 = [[SuggestPlaceViewController alloc] initWithNibName:@"SuggestPlaceViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController1 animated:YES];
//    return;

//    AddEventViewController *viewController1 = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController1 animated:YES];
//    return;

//    OfferReviewViewController *viewController2 = [[OfferReviewViewController alloc] initWithNibName:@"OfferReviewViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController2 animated:YES];
//    return;
    
//    NewProfileViewController *viewController2 = [[NewProfileViewController alloc] initWithNibName:@"NewProfileViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController2 animated:YES];
//    return;
    
//    RateProfileViewController *viewController2 = [[RateProfileViewController alloc] initWithNibName:@"RateProfileViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController2 animated:YES];
//    return;

//    ConversationViewController *viewController3 = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController3 animated:YES];
//    return;

//    CategorySelectionViewController *viewController3 = [[CategorySelectionViewController alloc] initWithNibName:@"CategorySelectionViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController3 animated:YES];
//    return;

    
#if TARGET_IPHONE_SIMULATOR
    InviteFacebookFriendViewController *inviteFacebookFriend = [[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:inviteFacebookFriend animated:YES];
    [inviteFacebookFriend release];
    return;
#endif
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        appDelegateObj.LoginFromFBFlag = @"0";
        appDelegateObj.isSignUpWithFacebook = YES;
        appDelegateObj.isLoginWithFacebook = NO;
        [appDelegateObj logout];
        [appDelegateObj openSession];
    }
}

-(IBAction)LoginBtncall:(id)sender {
//    InviteFacebookFriendViewController *inviteFacebookFriend = [[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil];
//    [self.navigationController.navigationItem setHidesBackButton:YES];
//    [self.navigationController pushViewController:inviteFacebookFriend animated:YES];
//    [inviteFacebookFriend release];
//    return;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    appDelegateObj.LoginFlag=TRUE;
    loginObj = [[LoginView_IPhone5 alloc] initWithNibName:@"LoginView_IPhone5" bundle:nil];
    CRNavigationController *naviController = [[[CRNavigationController alloc] initWithRootViewController:loginObj] autorelease];
    [self presentViewController:naviController animated:YES completion:nil];
}

-(IBAction)SignUpBtncall:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LName"];
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ProfImage"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    
    appDelegateObj.accessToken = @"";
    registerObj = [[RegistrationView alloc] initWithNibName:@"RegistrationView_IPhone5" bundle:nil];
    CRNavigationController *naviController = [[[CRNavigationController alloc] initWithRootViewController:registerObj] autorelease];
    [self presentViewController:naviController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Facebook Login

- (void)dealloc {
    	
	[fbGraph release];
    [super dealloc];
}

@end