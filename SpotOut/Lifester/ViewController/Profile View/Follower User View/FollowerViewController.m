//
//  FollowerViewController.m
//  Lifester
//
//  Created by MAC240 on 4/23/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "FollowerViewController.h"
#import "FollowerListCell.h"
#import "AsyncImageView.h"
#import "JSON.h"
#import "MFSideMenu.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"


@interface FollowerViewController ()

@end

@implementation FollowerViewController

@synthesize arrFollowerList;
@synthesize isFollowing;
@synthesize profileID;


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.arrFollowerList = nil;
}

- (void)dealloc
{
    [super dealloc];
    [tblFollower release];
    [arrFollowerList release];
}

#pragma mark - View life cycle

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
    
    if (isFollowing) {
        self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Following User List"];
    } else {
        self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Follower User List"];
    }
    [self setupMenuBarButtonItems];
    
    self.arrFollowerList = [[NSMutableArray alloc] init];
    selectedIndex = -1;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    [self getFollowerUserList:isFollowing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    
}

#pragma mark - Web service call Methods

- (void)getFollowerUserList:(BOOL)isFollowerList
{
    [appDelegate showActivity:self.view showOrHide:YES];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    flag = 1;
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"follower_following_list" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[NSNumber numberWithBool:isFollowerList] forKey:@"followed"];
    [request setPostValue:self.profileID forKey:@"profile_user_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

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

- (void)callUnfollowFollowingUserAPI:(NSDictionary *)dictData
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
    
    flag = 3;
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"unfollow" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[dictData objectForKey:@"user_id"] forKey:@"followed_userid"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"logged_userid"];
    [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"follow"];
    
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
        [appDelegate showActivity:self.view showOrHide:NO];
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"true"]) {
            @try {
                NSDictionary *dictData = [[[items valueForKey:@"status"] valueForKey:@"data"] objectAtIndex:0];
                self.arrFollowerList = [dictData objectForKey:@"profile"];
                [tblFollower reloadData];
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
        if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"001"]) {
            
            NSString *followingCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"status"] valueForKey:@"following"]];
            NSString *followerCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"status"] valueForKey:@"followers"]];
            [[NSUserDefaults standardUserDefaults] setObject:followingCount forKey:@"following_count"];
            [[NSUserDefaults standardUserDefaults] setObject:followerCount forKey:@"follower_count"];
            
            NSMutableDictionary *dictData = [self.arrFollowerList objectAtIndex:selectedIndex];
            if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"1"] || [[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Follower Added"]) {
                [dictData setValue:[NSNumber numberWithBool:YES] forKey:@"followed"];
            } else if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"0"] || [[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Follower Removed"]) {
                [dictData setValue:[NSNumber numberWithBool:NO] forKey:@"followed"];
            }
            
            if (isFollowing) {
                int index = [self.arrFollowerList indexOfObject:dictData];
                [self.arrFollowerList removeObject:dictData];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [tblFollower deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [self.arrFollowerList replaceObjectAtIndex:selectedIndex withObject:dictData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                [tblFollower reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    } else if (flag == 3) {
        [appDelegate showActivity:self.view showOrHide:NO];
        if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"001"]) {
            
            NSString *followingCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"status"] valueForKey:@"following"]];
            NSString *followerCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"status"] valueForKey:@"followers"]];
            [[NSUserDefaults standardUserDefaults] setObject:followingCount forKey:@"following_count"];
            [[NSUserDefaults standardUserDefaults] setObject:followerCount forKey:@"follower_count"];
            
            NSMutableDictionary *dictData = [self.arrFollowerList objectAtIndex:selectedIndex];
            if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"1"] || [[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Follower Added"]) {
                [dictData setValue:[NSNumber numberWithBool:YES] forKey:@"followed"];
            } else if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"0"] || [[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Follower Removed"]) {
                [dictData setValue:[NSNumber numberWithBool:NO] forKey:@"followed"];
            }
            
            if (isFollowing) {
                int index = [self.arrFollowerList indexOfObject:dictData];
                [self.arrFollowerList removeObject:dictData];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [tblFollower deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [self.arrFollowerList replaceObjectAtIndex:selectedIndex withObject:dictData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                [tblFollower reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [appDelegate showActivity:self.view showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


#pragma mark - UITableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrFollowerList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simple = @"FollowerListCell";
    FollowerListCell *cell = (FollowerListCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FollowerListCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    
    NSDictionary *dictData = [self.arrFollowerList objectAtIndex:indexPath.row];
    
    if ([[dictData objectForKey:@"profilename"] class] == [NSNull class]) {
        cell.lblprofileName.text = @"";
    } else {
        cell.lblprofileName.text = [dictData objectForKey:@"profilename"];
    }
    cell.lblUserName.text = [dictData objectForKey:@"username"];
    
    DYRateView *rateview = [[[DYRateView alloc] initWithFrame:CGRectMake(50, 46, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]] autorelease];
    rateview.editable = NO;
    rateview.rate = [[dictData objectForKey:@"avg_rating_profile"] floatValue];
    [cell.contentView addSubview:rateview];
    
    NSDictionary *dictProfileImage = [dictData objectForKey:@"profile_image"];
    if ([[dictProfileImage objectForKey:@"has_profiole_picture"] boolValue]) {
        cell.imvProfile.imageURL = [NSURL URLWithString:[dictProfileImage objectForKey:@"profile_picture_id"]];
    } else {
        cell.imvProfile.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    [cell.imvProfile setClipsToBounds: YES];
    [[cell.imvProfile layer] setMasksToBounds:YES];
    [[cell.imvProfile layer] setCornerRadius:cell.imvProfile.frame.size.width/2];
    
    if ([profileID integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] integerValue]) {
        [cell.btnFollower setHidden:NO];
        if ([[dictData objectForKey:@"followed"] class] == [NSNull class]) {
            [cell.btnFollower setTitle:@"Follow" forState:UIControlStateNormal];
            [cell.btnFollower setTitle:@"Follow" forState:UIControlStateHighlighted];
            
            [cell.btnFollower setBackgroundImage:[UIImage imageNamed:@"bar-base-size.png"] forState:UIControlStateNormal];
            cell.btnFollower.frame = CGRectMake(cell.btnFollower.frame.origin.x, cell.btnFollower.frame.origin.y, 55, cell.btnFollower.frame.size.height);
        } else {
            if ([[dictData objectForKey:@"followed"] boolValue]) {
                [cell.btnFollower setTitle:@"Unfollow" forState:UIControlStateNormal];
                [cell.btnFollower setTitle:@"Unfollow" forState:UIControlStateHighlighted];
                
                [cell.btnFollower setBackgroundImage:[UIImage imageNamed:@"increased-bar.png"] forState:UIControlStateNormal];
                cell.btnFollower.frame = CGRectMake(cell.btnFollower.frame.origin.x-18, cell.btnFollower.frame.origin.y, 73, cell.btnFollower.frame.size.height);
            } else {
                [cell.btnFollower setTitle:@"Follow" forState:UIControlStateNormal];
                [cell.btnFollower setTitle:@"Follow" forState:UIControlStateHighlighted];
                
                [cell.btnFollower setBackgroundImage:[UIImage imageNamed:@"bar-base-size.png"] forState:UIControlStateNormal];
                cell.btnFollower.frame = CGRectMake(cell.btnFollower.frame.origin.x, cell.btnFollower.frame.origin.y, 55, cell.btnFollower.frame.size.height);
            }
        }
        [cell.btnFollower setTag:indexPath.row];
        [cell.btnFollower addTarget:self action:@selector(btnFollowToggleAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.btnFollower setHidden:YES];
    }
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

#pragma mark - UITableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)btnFollowToggleAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    selectedIndex = button.tag;
    NSMutableDictionary *dictData = [self.arrFollowerList objectAtIndex:button.tag];
    if (isFollowing) {
        [self callUnfollowFollowingUserAPI:dictData];
    } else {
        [self callFollowUserAPI:dictData];
    }
}


@end
