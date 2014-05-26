//
//  InvitationsViewController.m
//  Lifester
//
//  Created by Nikunj on 1/6/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "InvitationsViewController.h"
#import "CustomNaviView.h"

@interface InvitationsViewController ()

@end

@implementation InvitationsViewController


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
    
    CustomNaviView *naviTitle = [[CustomNaviView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    naviTitle.viewController = self;
    naviTitle.btnInvitations.selected = YES;
    //naviTitle.lblDate.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = naviTitle;
    
    [self setupMenuBarButtonItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
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
    return [[UIBarButtonItem alloc] initWithCustomView:rightbtn] ;
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

#pragma mark - Table VIew Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simple=@"Simple";
    InvitationsCell *cell = (InvitationsCell *)[tblInvitations dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"InvitationsCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        UIView *v = [[UIView alloc] init];
    	v.backgroundColor = [UIColor clearColor];
    	cell.selectedBackgroundView = v;
    }
    
//    [cell.txtView setClipsToBounds: YES];
//    [[cell.txtView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
//    [[cell.txtView layer] setBorderWidth:0.5];
//    [[cell.txtView layer] setCornerRadius:5.0];
    return cell;
}

#pragma mark - Web service call Methods

- (void)callInvitationWebService
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
