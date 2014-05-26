//
//  FacebookFriendListViewController.m
//  Lifester
//
//  Created by Nikunj on 12/18/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "FacebookFriendListViewController.h"
#import "InviteFriendListCell.h"
#import "FacebookUser.h"
#import "IconDownloader.h"
#import "NearFriendViewController.h"

@interface FacebookFriendListViewController ()

@end

@implementation FacebookFriendListViewController

@synthesize arrFriendList;
@synthesize arrSelectedList;
@synthesize arrSearched;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.arrFriendList = nil;
}

- (void)dealloc
{
    [super dealloc];
    [arrFriendList release];
    
    [backgroundView release];
    [tblFriends release];
    [txtSearch release];
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
    
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    backgroundView.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0];
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Invite friends"];
    self.navigationItem.hidesBackButton = YES;
    [self customizeNavigationBarButton];
    
    self.arrFriendList = [[NSMutableArray alloc] init];
    self.arrSelectedList = [NSMutableArray array];
    self.arrSearched = [NSMutableArray array];
    
    appDelegateObj = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [self getFacebookFreindList];
    
    [txtSearch setValue:[UIColor colorWithRed:156.0/255.0f green:158.0/255.0f blue:161.0/255.0f alpha:1.0]
                    forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    if (IS_IPHONE_5) {
        tblFriends.frame = CGRectMake(tblFriends.frame.origin.x, tblFriends.frame.origin.y, tblFriends.frame.size.width, 442);
    } else {
        tblFriends.frame = CGRectMake(tblFriends.frame.origin.x, tblFriends.frame.origin.y, tblFriends.frame.size.width, 354);
    }
    
    [tblFriends setClipsToBounds: YES];
    [[tblFriends layer] setMasksToBounds:YES];
    [[tblFriends layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0f green:200.0/255.0f blue:200.0/255.0f alpha:1.0] CGColor]];
    [[tblFriends layer] setBorderWidth:0.7];
    [[tblFriends layer] setCornerRadius:5.0];
}

- (void)customizeNavigationBarButton
{
    // set left bar button items
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 6, 56, 32);
    [btnCancel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [btnCancel setTitle:@" Skip" forState:UIControlStateNormal];
    [btnCancel.titleLabel setTextColor:[UIColor whiteColor]];
    [btnCancel addTarget:self action:@selector(btnSkipAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -15;
    
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnCancel] autorelease];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backButtonItem, nil];
    
    // set right bar button items
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 6, 56, 32);
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone.titleLabel setTextColor:[UIColor whiteColor]];
    [btnDone addTarget:self action:@selector(btnDoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil action:nil];
    negativeSpacer1.width = 0;
    if (IS_IOS7)
        negativeSpacer1.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnDone] autorelease];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer1, rightButtonItem, nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)getFacebookFreindList
{
    if(FBSession.activeSession.isOpen)
    {
        [appDelegateObj showActivity:self.view showOrHide:YES];
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name,username",@"fields", nil];
        [FBRequestConnection startWithGraphPath:@"me/friends" parameters:param HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
         {
             if(!error){
                 NSArray *friends = [result objectForKey:@"data"];
                 for (NSDictionary *dictData in friends) {
                     FacebookUser *user = [[FacebookUser alloc] initWithDictionary:dictData];
                     [self.arrFriendList addObject:user];
                 }
                 
                 self.arrSearched = [self.arrFriendList mutableCopy];
                 [tblFriends reloadData];
             } else {
                 NSLog(@"Getting Error === %@", error);
             }
             [appDelegateObj showActivity:self.view showOrHide:NO];
         }];
    } else {
        [appDelegateObj showActivity:self.view showOrHide:YES];
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"user_birthday",@"read_friendlists"]  allowLoginUI:YES completionHandler: ^(FBSession *session, FBSessionState state, NSError *error)
         {
             if(error)
             {
                 NSLog(@"Session error");
                 [appDelegateObj fbResync];
                 [NSThread sleepForTimeInterval:0.5];   //half a second
                 [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"user_birthday",@"read_friendlists"]
                                                    allowLoginUI:YES
                                               completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                   [appDelegateObj sessionStateChanged:session state:state error:error];
                                               }];
                 
             }
             //[self showActivityOnWindow:self.window showOrHide:NO];
             [appDelegateObj sessionStateChanged:session state:state error:error];
             
             NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name,username",@"fields", nil];
             [FBRequestConnection startWithGraphPath:@"me/friends" parameters:param HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
              {
                  if(!error){
                      NSArray *friends = [result objectForKey:@"data"];
                      for (NSDictionary *dictData in friends) {
                          FacebookUser *user = [[FacebookUser alloc] initWithDictionary:dictData];
                          [self.arrFriendList addObject:user];
                      }
                      
                      self.arrSearched = [self.arrFriendList mutableCopy];
                      [tblFriends reloadData];
                  } else {
                      NSLog(@"Getting Error === %@", error);
                  }
                  [appDelegateObj showActivity:self.view showOrHide:NO];
              }];
         }];
    }
}

#pragma mark - UIButton Methods

- (void)btnSkipAction:(id)sender
{
//    WhatsGoingViewController *homeViewController = [[WhatsGoingViewController alloc] initWithNibName:@"WhatsGoingViewController" bundle:nil];
//    [self.navigationController pushViewController:homeViewController animated:YES];
    
    [appDelegateObj initializeTabBarController];
    //[appDelegateObj.window addSubview:appDelegateObj.tabBarController.view];
   // [self.navigationController pushViewController:appDelegateObj.tabBarController animated:NO];
}

- (void)btnDoneAction:(id)sender
{
    NSMutableString *facebookID = [[[NSMutableString alloc] init] autorelease];
    for (FacebookUser *user in self.arrSearched) {
        if (user.isSelected) {
            if ([facebookID length]) {
                [facebookID appendString:@","];
            }
            [facebookID appendFormat:@"%@", user.ID];
        }
    }
    
    NSLog(@"Selected facebook IDs ==== %@", facebookID);
    
    if (![facebookID length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please first select friend."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: @"Check this app out...", @"message",
                            @"Spotly", @"title",
                            nil];
    

    NSString *path = [NSString stringWithFormat:@"apprequests?ids=%@",facebookID];
    [FBRequestConnection startWithGraphPath:path parameters:params HTTPMethod:nil completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error) {
             // Case A: Error launching the dialog or sending request.
             NSLog(@"Error sending request === %@.", error);
             [appDelegateObj showActivity:self.view showOrHide:NO];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
         } else {
             NSLog(@"Request Sent. %@", error);
//             if (result == FBWebDialogResultDialogNotCompleted) {
//                 // Case B: User clicked the "x" icon
//                 NSLog(@"User canceled request.");
//             } else {
//                 NSLog(@"Request Sent. %@", error);
//             }
             
//             WhatsGoingViewController *homeViewController = [[WhatsGoingViewController alloc] initWithNibName:@"WhatsGoingViewController" bundle:nil];
//             [self.navigationController pushViewController:homeViewController animated:YES];
             [appDelegateObj initializeTabBarController];
             //[appDelegateObj.window addSubview:appDelegateObj.tabBarController.view];
             //[self.navigationController pushViewController:appDelegateObj.tabBarController animated:NO];
         }
         [appDelegateObj showActivity:self.view showOrHide:NO];
     }];
    
}


#pragma mark - UITableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSearched count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCell";
    InviteFriendListCell *cell = (InviteFriendListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendListCell" owner:self options:nil];
        for(id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (InviteFriendListCell *)currentObject;
                break;
            }
        }
    } else {
        // the cell is being recycled, remove old embedded controls
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
    FacebookUser *facebookUser = [self.arrSearched objectAtIndex:indexPath.row];
    cell.lblUserName.text = facebookUser.name;
    
    [IconDownloader loadImageFromLink:facebookUser.picture forImageView:cell.imvProfile withPlaceholder:nil andContentMode:UIViewContentModeScaleAspectFit];
    [cell.imvProfile setClipsToBounds: YES];
    [[cell.imvProfile layer] setMasksToBounds:YES];
    [[cell.imvProfile layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[cell.imvProfile layer] setBorderWidth:0.7];
    [[cell.imvProfile layer] setCornerRadius:cell.imvProfile.frame.size.width/2.0];
    
    [cell.btnInvite addTarget:self action:@selector(btnInviteAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnInvite setTag:indexPath.row];
    if(facebookUser.isSelected) {
		[cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"invite-box-hover.png"] forState:UIControlStateNormal];
        [cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"invite-box-hover.png"] forState:UIControlStateHighlighted];
        [cell.btnInvite setTitle:@"" forState:UIControlStateNormal];
        [cell.btnInvite setTitle:@"" forState:UIControlStateHighlighted];
	} else {
		[cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"invite-box.png"] forState:UIControlStateNormal];
        [cell.btnInvite setBackgroundImage:[UIImage imageNamed:@"invite-box.png"] forState:UIControlStateHighlighted];
        [cell.btnInvite setTitle:@"Invite" forState:UIControlStateNormal];
        [cell.btnInvite setTitle:@"Invite" forState:UIControlStateHighlighted];
	}
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

#pragma mark - UITableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)btnInviteAction:(id)sender
{
    UIButton *btnInvite = (UIButton*)sender;
    FacebookUser *user = [self.arrSearched objectAtIndex:btnInvite.tag];
    if (user.isSelected) {
        user.isSelected = NO;
    } else {
        user.isSelected = YES;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btnInvite.tag inSection:0];
    [tblFriends reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([searchStr length]) {
        // Remove all objects from the filtered search array
        [self.arrSearched removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchStr];
        NSArray *arrFilter = [self.arrFriendList filteredArrayUsingPredicate:predicate];
        self.arrSearched = [arrFilter mutableCopy];
        [tblFriends reloadData];
    } else {
        self.arrSearched = [self.arrFriendList mutableCopy];
        [tblFriends reloadData];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.arrSearched = [self.arrFriendList mutableCopy];
    [tblFriends reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length]) {
        // Remove all objects from the filtered search array
        [self.arrSearched removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", textField.text];
        NSArray *arrFilter = [self.arrFriendList filteredArrayUsingPredicate:predicate];
        self.arrSearched = [arrFilter mutableCopy];
        [tblFriends reloadData];
    } else {
        self.arrSearched = [self.arrFriendList mutableCopy];
        [tblFriends reloadData];
    }
    
    [textField resignFirstResponder];
    return YES;
}


@end
