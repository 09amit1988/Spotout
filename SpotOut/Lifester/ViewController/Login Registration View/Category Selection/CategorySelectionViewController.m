//
//  CategorySelectionViewController.m
//  Lifester
//
//  Created by MAC240 on 1/8/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "CategorySelectionViewController.h"
#import "CategoryCell.h"
#import "InviteFacebookFriendViewController.h"
#import "JSON.h"
#import "Reachability.h"
#import "ViewController_IPhone5.h"

@interface CategorySelectionViewController ()

@end

@implementation CategorySelectionViewController

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
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"What do you like?"];
    appDelegateObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    backgroundView.backgroundColor = VIEW_COLOR;
    [self setupMenuBarButtonItems];
    flag = NO;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        [self WebServiceCall];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.rightBarButtonItems = [self rightMenuBarButtonItem];
    //self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *btnMainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMainMenu setTitle:@"Back" forState:UIControlStateNormal];
    [btnMainMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnMainMenu.frame = CGRectMake(0, 0, 60, 22);
    
    return [[UIBarButtonItem alloc] initWithCustomView:btnMainMenu];
}

- (NSArray *)rightMenuBarButtonItem {
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setTitle:@"Done" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbtn.frame = CGRectMake(0, 6, 56, 32);
    [rightbtn addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightbtn] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
}

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate addMenuViewControllerOnWindow:self];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsSelected == 1"];
    NSArray *arrFiltered = [self.arrCategory filteredArrayUsingPredicate:predicate];
    if ([arrFiltered count] >= 4) {
        InviteFacebookFriendViewController *viewController = [[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil];
        
        [self.navigationController pushViewController:viewController animated:YES];
//        NSArray *controllers = [NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0], [self.navigationController.viewControllers objectAtIndex:2], [self.navigationController.viewControllers objectAtIndex:3], nil];
//        self.navigationController.viewControllers = controllers;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select atleast 4 category."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void)WebServiceCall {
    
    self.view.userInteractionEnabled = NO;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"get_choice_category_list" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
    [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSString *receivedString = [request responseString];
    
    NSDictionary *responseObject = [receivedString JSONValue];
    NSArray *items = [responseObject objectForKey:@"raws"];
    
    if (![[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
        if (IS_IPHONE_5) {
            ViewController_IPhone5 *viewObj = [[ViewController_IPhone5 alloc] initWithNibName:@"ViewController_IPhone5" bundle:nil];
            [self.navigationController pushViewController:viewObj animated:YES];
            [viewObj release];
        } else {
            ViewController_IPhone5 *viewObj = [[ViewController_IPhone5 alloc] initWithNibName:@"ViewController" bundle:nil];
            [self.navigationController pushViewController:viewObj animated:YES];
            [viewObj release];
        }
    }
    else {
        if (![[[items valueForKey:@"status"] valueForKey:@"fetch_status"] isEqualToString:@"true"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:appname message:@"No Data Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else {
            self.arrCategory = [[NSMutableArray alloc] init];
            
            if ([[items valueForKey:@"dataset"] isKindOfClass:[NSMutableArray class] ]) {
                [self.arrCategory addObjectsFromArray:[items valueForKey:@"dataset"]];
                
                for (int i = 0; i < [self.arrCategory count]; i++) {
                    NSMutableDictionary *dict = [self.arrCategory objectAtIndex:i];
                    NSString *image = [NSString stringWithFormat:@"category-%d.png", i];
                    [dict setObject:image forKey:@"CategoryImage"];
                    
                    [self.arrCategory replaceObjectAtIndex:i withObject:dict];
                }
            }
            if ([[items valueForKey:@"dataset"] isKindOfClass:[NSMutableDictionary class]]) {
                [self.arrCategory addObject:[items valueForKey:@"dataset"]];
                
                for (int i = 0; i < [self.arrCategory count]; i++) {
                    NSMutableDictionary *dict = [self.arrCategory objectAtIndex:i];
                    NSString *image = [NSString stringWithFormat:@"category-%d.png", i];
                    [dict setObject:image forKey:@"CategoryImage"];
                    
                    [self.arrCategory replaceObjectAtIndex:i withObject:dict];
                }
            }
            //NSLog(@"array === %@", self.arrCategory);
            
            [tblCategory reloadData];
        }
    }
    
    self.view.userInteractionEnabled = YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    self.view.userInteractionEnabled = YES;
    
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
    if([self.arrCategory count]%2 == 0) {
        return ceil([self.arrCategory count]/2);
    }
    return (int)([self.arrCategory count]/2) + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simple=@"Simple";
    CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CategoryCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
    }
    
    NSMutableDictionary *dictData1 = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:(indexPath.row*2)]];
    cell.lblCategory1.text = [dictData1 objectForKey:@"category_name"];
    cell.btnCategory1.tag = indexPath.row*2;
    [cell.btnCategory1 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCategory1 setImage:[UIImage imageNamed:[dictData1 objectForKey:@"CategoryImage"]] forState:UIControlStateNormal];
    
    if ([[dictData1 objectForKey:@"IsSelected"] boolValue]) {
        cell.btnCategory1.selected = YES;
        [cell.imvDone1 setHidden:NO];
    } else {
        cell.btnCategory1.selected = NO;
        [cell.imvDone1 setHidden:YES];
    }
    
    [cell.lblCategory2 setHidden:YES];
    [cell.btnCategory2 setHidden:YES];
    [cell.imvDone2 setHidden:YES];
    [cell.imvActivity2 setHidden:YES];
    [cell.lblActivity2 setHidden:YES];
    
    if((indexPath.row * 2) + 1 < [self.arrCategory count]) {
        NSMutableDictionary *dictData2 = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:(indexPath.row*2)+1]];
        cell.lblCategory2.text = [dictData2 objectForKey:@"category_name"];
        cell.btnCategory2.tag = (indexPath.row*2)+1;
        [cell.btnCategory2 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCategory2 setImage:[UIImage imageNamed:[dictData2 objectForKey:@"CategoryImage"]] forState:UIControlStateNormal];
        
        if ([[dictData2 objectForKey:@"IsSelected"] boolValue]) {
            cell.btnCategory2.selected = YES;
            [cell.imvDone2 setHidden:NO];
        } else {
            cell.btnCategory2.selected = NO;
            [cell.imvDone2 setHidden:YES];
        }

        [cell.lblCategory2 setHidden:NO];
        [cell.btnCategory2 setHidden:NO];
        [cell.imvActivity2 setHidden:NO];
        [cell.lblActivity2 setHidden:NO];
    } else {
        [cell.btnCategory2 setHidden:NO];
        if (flag) {
            [cell.btnCategory2 setImage:[UIImage imageNamed:@"next-2.png"] forState:UIControlStateNormal];
            [cell.btnCategory2 setUserInteractionEnabled:YES];
            [cell.btnCategory2 addTarget:self action:@selector(btnNextAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [cell.btnCategory2 setImage:[UIImage imageNamed:@"next-1.png"] forState:UIControlStateNormal];
            [cell.btnCategory2 setUserInteractionEnabled:NO];
        }
    }
    
    /*
    if((indexPath.row * 3) + 2 < [self.arrCategory count]) {
        NSMutableDictionary *dictData3 = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:(indexPath.row*3)+2]];
        cell.lblCategory3.text = [dictData3 objectForKey:@"category_name"];
        cell.btnCategory3.tag = (indexPath.row*3)+2;
        [cell.btnCategory3 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnOverlay3.tag = (indexPath.row*3)+2;
        [cell.btnOverlay3 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([[dictData3 objectForKey:@"IsSelected"] boolValue]) {
            cell.btnCategory3.selected = YES;
            cell.btnOverlay3.selected = YES;
            [cell.btnOverlay3 setHidden:NO];
        } else {
            cell.btnCategory3.selected = NO;
            cell.btnOverlay3.selected = NO;
            [cell.btnOverlay3 setHidden:YES];
        }
        
        [cell.lblCategory3 setHidden:NO];
        [cell.btnCategory3 setHidden:NO];
    }
    */
     
    return cell;
}

#pragma mark - UITableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)btnNextAction:(id)sender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsSelected == 1"];
    NSArray *arrFiltered = [self.arrCategory filteredArrayUsingPredicate:predicate];
    if ([arrFiltered count] >= 4) {
        InviteFacebookFriendViewController *viewController = [[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil];
        
        [self.navigationController pushViewController:viewController animated:YES];
//        NSArray *controllers = [NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0], [self.navigationController.viewControllers objectAtIndex:2], [self.navigationController.viewControllers objectAtIndex:3], nil];
//        self.navigationController.viewControllers = controllers;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select atleast 4 category."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)btnCategoryAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    NSMutableDictionary *dictData = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:button.tag]];
    if (button.isSelected) {
        [dictData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    } else {
        [dictData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
    }
    
    [self.arrCategory replaceObjectAtIndex:button.tag withObject:dictData];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsSelected == 1"];
    NSArray *arrFiltered = [self.arrCategory filteredArrayUsingPredicate:predicate];
    if ([arrFiltered count] >= 4) {
        flag = YES;
    } else {
        flag = NO;
    }
    
    [tblCategory reloadData];
}

@end
