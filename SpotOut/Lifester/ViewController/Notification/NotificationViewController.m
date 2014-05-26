//
//  NotificationViewController.m
//  Lifester
//
//  Created by Nikunj on 1/6/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "NotificationViewController.h"
#import "CustomNaviView.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.navigationItem.titleView = [self navigationTitle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
}

- (UIView *)navigationTitle
{
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    naviView.backgroundColor = [UIColor clearColor];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
    lblTitle.font = [UIFont fontWithName:HELVETICANEUEMEDIUM size:17.0];
    lblTitle.text = @"Notifications";
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.backgroundColor = [UIColor clearColor];
    [naviView addSubview:lblTitle];
    
    pageControl = [[StyledPageControl alloc] init];
    pageControl.frame = CGRectMake(0, 30, 150, 10);
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    [pageControl setPageControlStyle:PageControlStyleDefault];
    [pageControl setGapWidth:6];         // change gap width
    [pageControl setDiameter:10];         // change diameter
    pageControl.userInteractionEnabled = NO;
    [naviView addSubview:pageControl];
    
    return naviView;
}


#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    //self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *btnMainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMainMenu setBackgroundImage:[UIImage imageNamed:@"menu-icon.png"] forState:UIControlStateNormal];
    [btnMainMenu addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnMainMenu.frame = CGRectMake(0, 0, 22, 22);
    return [[UIBarButtonItem alloc] initWithCustomView:btnMainMenu] ;
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"people-near-you-icon.png"] forState:UIControlStateNormal];
    rightbtn.frame = CGRectMake(0, 0, 25, 22);
    [rightbtn addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
}

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate addMenuViewControllerOnWindow:self];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

#pragma mark - UIButton Action

- (IBAction)btnNotificationAction:(id)sender
{
    pageControl.currentPage = 0;
}

- (IBAction)btnMessagesAction:(id)sender
{
    pageControl.currentPage = 1;
}

#pragma mark - Web service call Methods

- (void)callNotificationWebService
{
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_updation" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
}

@end
