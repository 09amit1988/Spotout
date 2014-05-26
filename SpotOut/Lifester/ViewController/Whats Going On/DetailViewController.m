//
//  DetailViewController.m
//  SpotOut
//
//  Created by Rakesh on 25/05/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () {
    
    NSMutableArray *arrEvents;
}

@end

@implementation DetailViewController

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
    self.title = @"Details";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];

    arrPeople = [[NSMutableArray alloc] initWithObjects:@"22 people",@"12 people",@" ", nil];
    arrEvents = [[NSMutableArray alloc] initWithObjects:@"love this",@"invite friends",@" ", nil];
    arrDetail = [[NSMutableArray alloc] initWithObjects:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur",@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur", nil];
    arrImage = [[NSMutableArray alloc] initWithObjects:@"post-detail-hearth-icon.png",@"post-detail-invites-icon.png",@"",@"profile-icon-small.png",nil];
    }

#pragma mark Tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell*)[tblDetail dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,20,20,20)];
        myImageView.tag = 1;
        myImageView.image = [UIImage imageNamed:[arrImage objectAtIndex:indexPath.row]];
        [cell addSubview:myImageView];
       
        
    }
    if (indexPath.row == 0) {

        UILabel *  lblPeople = [[UILabel alloc]initWithFrame:CGRectMake(60, 14, 80, 30)];
        [lblPeople setBackgroundColor:[UIColor clearColor]];
        [lblPeople setFont:[UIFont fontWithName:@"Bold" size:14.0]];
        lblPeople.text =[arrPeople objectAtIndex:indexPath.row] ;
        [cell.contentView addSubview:lblPeople];
        
        UILabel *  lblEvents = [[UILabel alloc]initWithFrame:CGRectMake(140, 14, 80, 30)];
        [lblEvents setBackgroundColor:[UIColor clearColor]];
        [lblEvents setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        lblEvents.text =[arrEvents objectAtIndex:indexPath.row] ;
        [cell.contentView addSubview:lblEvents];
        
    }
    else if(indexPath.row == 1) {
        
        UILabel *  lblPeople = [[UILabel alloc]initWithFrame:CGRectMake(60, 14, 80, 30)];
        [lblPeople setBackgroundColor:[UIColor clearColor]];
        [lblPeople setFont:[UIFont fontWithName:@"Bold" size:14.0]];
        lblPeople.text =[arrPeople objectAtIndex:indexPath.row] ;
        [cell.contentView addSubview:lblPeople];
        
        UILabel *  lblEvents = [[UILabel alloc]initWithFrame:CGRectMake(140, 14, 80, 30)];
        [lblEvents setBackgroundColor:[UIColor clearColor]];
        [lblEvents setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        lblEvents.text =[arrEvents objectAtIndex:indexPath.row] ;
        [cell.contentView addSubview:lblEvents];
        
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,54,40,40)];
        myImageView.image = [UIImage imageNamed:[arrImage objectAtIndex:3]];
        [cell addSubview:myImageView];
        
        
        UILabel *  lbl = [[UILabel alloc]initWithFrame:CGRectMake(60, 54, 120, 30)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        lbl.text =@"Urnebes restaurant" ;
        lbl.textColor = [UIColor  grayColor];
        [cell.contentView addSubview:lbl];
        
        
        UIButton *editView = [[UIButton alloc] initWithFrame:CGRectMake(270,54,23,23)];
        [editView setImage:[UIImage imageNamed:@"edit-icon.png"] forState:UIControlStateNormal];
        [editView addTarget:self
                 action:@selector(editCommnet:)
       forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:editView];
        
        UILabel *  lblgreatpla = [[UILabel alloc]initWithFrame:CGRectMake(60, 74, 120, 30)];
        [lblgreatpla setBackgroundColor:[UIColor clearColor]];
        [lblgreatpla setFont:[UIFont fontWithName:@"Arial" size:12.0]];
        lblgreatpla.text =@"&greatpla" ;
        lblgreatpla.textColor = [UIColor  grayColor];
        [cell.contentView addSubview:lblgreatpla];
      
        UILabel *  lblDesc = [[UILabel alloc]initWithFrame:CGRectMake(60, 94, 240, 90)];
        [lblDesc setBackgroundColor:[UIColor clearColor]];
        lblDesc.numberOfLines = 0;
        lblDesc.lineBreakMode = NSLineBreakByWordWrapping;
        [lblDesc setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        lblDesc.text =[arrDetail objectAtIndex:indexPath.row] ;
        [cell.contentView addSubview:lblDesc];
        
        UIImageView *myImageTime = [[UIImageView alloc] initWithFrame:CGRectMake(60,186,10,10)];
        myImageTime.image = [UIImage imageNamed:@"clock-icon.png"];
        [cell addSubview:myImageTime];
        
        UILabel *  lblTime = [[UILabel alloc]initWithFrame:CGRectMake(75, 184, 120, 15)];
        [lblTime setBackgroundColor:[UIColor clearColor]];
        [lblTime setFont:[UIFont fontWithName:@"Arial" size:12.0]];
        lblTime.text =@"Friday, 10:00 pm" ;
        lblTime.textColor = [UIColor  grayColor];
        [cell.contentView addSubview:lblTime];
        
        //time-post-icon.png
        
        
        UILabel *  lblline = [[UILabel alloc]initWithFrame:CGRectMake(60, 210, 270, 1)];
        [lblline setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblline];
        
        
        UIImageView *myImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10,220,40,40)];
        myImageView1.image = [UIImage imageNamed:[arrImage objectAtIndex:3]];
        [cell addSubview:myImageView1];
        
        UILabel *  lbl12 = [[UILabel alloc]initWithFrame:CGRectMake(60, 220, 120, 30)];
        [lbl12 setBackgroundColor:[UIColor clearColor]];
        [lbl12 setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        lbl12.text =@"Urnebes restaurant" ;
        lbl12.textColor = [UIColor  grayColor];
        [cell.contentView addSubview:lbl12];
        
        UILabel *  lblgreatpla1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 240, 120, 30)];
        [lblgreatpla1 setBackgroundColor:[UIColor clearColor]];
        [lblgreatpla1 setFont:[UIFont fontWithName:@"Arial" size:12.0]];
        lblgreatpla1.text =@"&greatpla" ;
        lblgreatpla1.textColor = [UIColor  grayColor];
        [cell.contentView addSubview:lblgreatpla1];
        
        UILabel *  lblDetail = [[UILabel alloc]initWithFrame:CGRectMake(60, 270, 240, 90)];
        [lblDetail setBackgroundColor:[UIColor clearColor]];
        lblDetail.numberOfLines = 0;
        lblDetail.lineBreakMode = NSLineBreakByWordWrapping;
        [lblDetail setFont:[UIFont fontWithName:@"Arial" size:14.0]];
        [lblDetail setTextColor:[UIColor blackColor]];
        lblDetail.text = [arrDetail objectAtIndex:indexPath.row];
        [cell.contentView addSubview:lblDetail];
        
        UIImageView *myImageTime1 = [[UIImageView alloc] initWithFrame:CGRectMake(60,362,10,10)];
        myImageTime1.image = [UIImage imageNamed:@"clock-icon.png"];
        [cell addSubview:myImageTime1];
        
        UILabel *  lblTime1 = [[UILabel alloc]initWithFrame:CGRectMake(75, 360, 120, 15)];
        [lblTime1 setBackgroundColor:[UIColor clearColor]];
        [lblTime1 setFont:[UIFont fontWithName:@"Arial" size:12.0]];
        lblTime1.text =@"Friday, 10:00 pm" ;
        lblTime1.textColor = [UIColor  grayColor];
        [cell.contentView addSubview:lblTime1
         ];

        
        UILabel *  lblline2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 380, 270, 1)];
        [lblline2 setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblline2];
        
    }
    else {
        
        UITextView *txtComment = [[UITextView alloc] init];
        txtComment.frame = cell.frame;
        txtComment.text = @"Write comment";
        txtComment.textColor = [UIColor grayColor];
        [cell.contentView addSubview:txtComment];
    }

    return cell;
}

-(void)editCommnet:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:appname delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Edit",@"Delete",nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
    [action release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Edit Page" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
	if(buttonIndex == 2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Delete Page" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];

	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.row == 0) {
        return 64;
    }
   else if (indexPath.row == 1) {
        return 420;
    }
    else return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
