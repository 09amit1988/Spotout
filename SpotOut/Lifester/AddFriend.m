//
//  AddFriend.m
//  Lifester
//
//  Created by App Developer on 13/02/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "AddFriend.h"

@interface AddFriend ()

@end

@implementation AddFriend

@synthesize AddFriendTable;

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
    
    self.navigationController.navigationBarHidden = YES;
	self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:229/255.0f alpha:1];
    
    headLbl.textColor = [UIColor colorWithRed:3/255.0f green:82/255.0f blue:110/255.0f alpha:1];
    FriendName.textColor = [UIColor colorWithRed:3/255.0f green:82/255.0f blue:110/255.0f alpha:1];
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.AddFriendTable.bounds.size.height, self.view.frame.size.width, self.AddFriendTable.bounds.size.height)];
		view.delegate = self;
		[self.AddFriendTable addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	[_refreshHeaderView refreshLastUpdatedDate];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    TabObj = [[TabView alloc] initWithNibName:@"TabView" bundle:nil];
    TabObj.view.frame = CGRectMake(0, 0, 320, 59);
    [TabObj.intensionBtn setImage:[UIImage imageNamed:@"intention_icon.png"] forState:UIControlStateNormal];
    [TabObj.LifefeedBtn setImage:[UIImage imageNamed:@"lifefeed_icon.png"] forState:UIControlStateNormal];
    [TabObj.jabberBtn setImage:[UIImage imageNamed:@"jabber_icon.png"] forState:UIControlStateNormal];
    [TabObj.locationBtn setImage:[UIImage imageNamed:@"locations_icon.png"] forState:UIControlStateNormal];
    [TabObj.profileBtn setImage:[UIImage imageNamed:@"profile_icon_ac.png"] forState:UIControlStateNormal];
    [self.view addSubview:TabObj.view];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [searchTxt resignFirstResponder];
    return YES;
}

-(IBAction)FriendBtnCall {
 
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)CrossBtnCall {
    
    searchTxt.text = @"";
    [searchTxt resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)AddBtnnCall {
    
    [self.view addSubview:SubView];
}

-(IBAction)CancelBtncall:(id)sender {
    
    [SubView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.AddFriendTable dequeueReusableCellWithIdentifier:CellIdentifier];
    // if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
    profImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    profImg.image = [UIImage imageNamed:@"location_profile_pic.png"];
    [cell.contentView addSubview:profImg];
    
    Frndname = [[UILabel alloc] initWithFrame:CGRectMake(82, 5, 170, 20)];
    Frndname.text = @"Suman Ghosh";
    Frndname.textColor = [UIColor colorWithRed:3/255.0f green:82/255.0f blue:110/255.0f alpha:1];
    Frndname.backgroundColor = [UIColor clearColor];
    [Frndname setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    [cell.contentView addSubview:Frndname];
    [Frndname release];
    
    UILabel *tempLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 0, 1, 80)];
    tempLbl.backgroundColor = [UIColor colorWithRed:201/255.0f green:211/255.0f blue:213/255.0f alpha:1];
    [cell.contentView addSubview:tempLbl];
    [tempLbl release];
    
    
    UIImageView *tempImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(82, 33, 9, 16)];
    tempImg1.image = [UIImage imageNamed:@"location_iconsmall.png"];
    [cell.contentView addSubview:tempImg1];
    
    
    UIImageView *tempImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(82, 55, 10, 16)];
    tempImg2.image = [UIImage imageNamed:@"lifestyle_icon1.png"];
    [cell.contentView addSubview:tempImg2];
    
    
    UIButton *AddBtn = [[UIButton alloc] initWithFrame:CGRectMake(273.0f, 16.0f, 33.0f, 46.0f)];
    AddBtn.backgroundColor = [UIColor clearColor];
    [AddBtn setImage:[UIImage imageNamed:@"addfriend_icon.png"] forState:0];
    [AddBtn addTarget:self action:@selector(AddBtnnCall) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:AddBtn];
    [AddBtn release];
    
    
    
    location = [[UILabel alloc] initWithFrame:CGRectMake(94, 32, 158, 16)];
    location.text = @"Caffe bar Niko";
    location.textColor = [UIColor lightGrayColor];
    location.backgroundColor = [UIColor clearColor];
    [location setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [cell.contentView addSubview:location];
    [location release];
    
    
    Intenstion = [[UILabel alloc] initWithFrame:CGRectMake(94, 55, 158, 16)];
    Intenstion.text = @"Cinema";
    Intenstion.textColor = [UIColor lightGrayColor];
    Intenstion.backgroundColor = [UIColor clearColor];
    [Intenstion setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [cell.contentView addSubview:Intenstion];
    [Intenstion release];
    
    
    // }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    profileObj = [[ProfileView alloc] initWithNibName:@"ProfileView" bundle:nil];
    
    [self.navigationController pushViewController:profileObj animated:YES];
    [profileObj release];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.AddFriendTable];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}

@end
