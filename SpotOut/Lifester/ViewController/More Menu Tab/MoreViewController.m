//
//  MoreViewController.m
//  Lifester
//
//  Created by MAC240 on 5/6/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "MoreViewController.h"
#import "NewProfileViewController.h"
#import "Settings.h"
#import "Settings_IPhone5.h"

@interface MoreViewController ()

@end

@implementation MoreViewController


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
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"More"];
    
    tblMore.tableHeaderView = tableHeaderView;
    
    lblProfileName.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"profileName"]];
    lblUsername.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"username"]];
    imvProfileImage.imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"ProfImage"]];
    
    blurView.dynamic = YES;
    blurView.blurRadius = 13.0;
    blurView.alpha = 1.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - UIButton Action

- (IBAction)btnProfileViewAction:(id)sender
{
    NewProfileViewController *viewController = [[NewProfileViewController alloc] initWithNibName:@"NewProfileViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Bookmarks";
        cell.imageView.image = [UIImage imageNamed:@"bookmarks_more.png"];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Insights";
        cell.imageView.image = [UIImage imageNamed:@"insights_more.png"];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Settings";
        cell.imageView.image = [UIImage imageNamed:@"settings_more.png"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:HELVETICANEUEREGULAR size:15.0];
    cell.textLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0,0,320.0,50.0)];
    footer.backgroundColor = [UIColor clearColor];
    
    return footer;
    
    
}

#pragma mark - UITableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        if (IS_IPHONE_5) {
            Settings_IPhone5 *viewController = [[Settings_IPhone5 alloc] initWithNibName:@"Settings_IPhone5" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            Settings *viewController = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}


@end
