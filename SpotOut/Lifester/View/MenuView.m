//
//  CustomNaviView.m
//  MediaApp
//
//  Created by Nikunj on 12/26/13.
//  Copyright (c) 2013 Jitendra. All rights reserved.
//

#import "MenuView.h"
#import "UIView+NIB.h"

@implementation MenuView

#pragma mark - Life cycle

@synthesize delegate;
@synthesize parentViewController;
@synthesize tblMenuList,searchView,btnUserName;
@synthesize btnCancel;
@synthesize imgProfile;

- (id)initWithFrame:(CGRect)frame
{
    //self = [super initWithFrame:frame];
    self = [MenuView loadViewFromNib:@"MenuView"];
    if (self) {
        tblMenuList.dataSource = self;
        tblMenuList.delegate = self;
        [self.searchView setHidden:YES];
        [self.btnCancel setHidden:YES];
        
        [imgProfile setClipsToBounds: YES];
        [[imgProfile layer] setMasksToBounds:YES];
        [[imgProfile layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
        [[imgProfile layer] setBorderWidth:1.0];
        [[imgProfile layer] setCornerRadius:imgProfile.frame.size.width/2];
        imgProfile.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ProfImage"]]];
        
    }
    return self;
}


- (IBAction)btnCancelAction:(id)sender
{
    self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, 504);
    
    /*Display View With Animation*/
    float height = 0;
    [UIView animateWithDuration:.3 animations:^{
        //set new originY as you want.
        self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, height);
    } completion:^(BOOL finished) {
        [self.searchView setHidden:YES];
        [self.btnCancel setHidden:YES];
    }];
    
    txtSearch.text = @"";
    [txtSearch resignFirstResponder];
    [self.searchView setHidden:YES];
    [self.btnCancel setHidden:YES];
}

- (IBAction)btnSettingAction:(id)sender
{
    [self btnCancelAction:nil];
    if([self.delegate respondsToSelector:@selector(didSelecteSetting:)])
    {
        [self.delegate  didSelecteSetting:parentViewController];
    }
}

- (IBAction)btnUpArrowAction:(id)sender
{
    [self btnCancelAction:nil];
    if([self.delegate respondsToSelector:@selector(hideMenuView)])
    {
        [self.delegate  hideMenuView];
    }
}

- (IBAction)btnUserProfileAction:(id)sender
{
    [self btnCancelAction:nil];
    if([self.delegate respondsToSelector:@selector(didSelectUserProfile:)])
    {
        [self.delegate  didSelectUserProfile:parentViewController];
    }
}

#pragma mark - Table View Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,300,34)];
    tempView.backgroundColor=[UIColor clearColor];
    
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,0,300,34)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor colorWithRed:209.0/255.0 green:210.0/255.0 blue:212.0/255.0 alpha:1.0]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    NSString *str = nil;
    if(section == 0) {
        str = @"News";
    } else if (section == 1) {
        str = @"Reminder";
    } else if(section == 2) {
        str = @"Profile";
    } else {
        str = @"App";
    }
    
    tempLabel.text= str;
    [tempView addSubview:tempLabel];
    
    [tempLabel release];
    return tempView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else if (section == 1){
        return 1;
    }else if (section == 2){
        return 2;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self btnCancelAction:nil];
    if([self.delegate respondsToSelector:@selector(didSelecteRowAtMenuIndex:parentViewController:)])
    {
        [self.delegate  didSelecteRowAtMenuIndex:indexPath.section parentViewController:parentViewController];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *lblCellTxt = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 300, 44)];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 25, 25)];
    lblCellTxt.textColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            lblCellTxt.text = @"What's going on";
            imv.image = [UIImage imageNamed:@"news-icon.png"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            lblCellTxt.text = @"Bookmarks";
            imv.image = [UIImage imageNamed:@"bookmark-icon.png"];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            lblCellTxt.text = @"Insights";
            imv.image = [UIImage imageNamed:@"insights-icon.png"];
        } else if (indexPath.row ==1) {
            lblCellTxt.text = @"Conversations";
            imv.image = [UIImage imageNamed:@"conversations-icon.png"];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            lblCellTxt.text = @"Top users";
            imv.image = [UIImage imageNamed:@"top-users-icon.png"];
        }
    }
    [lblCellTxt setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:14.0f]];
    [lblCellTxt setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:lblCellTxt];
    [cell.contentView addSubview:imv];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rollover.png"]];
    cell.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:119.0/255.0 blue:149.0/255.0 alpha:1.0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.0;
}

#pragma mark - UITextField Delegate
/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *searchString = [[[NSMutableString alloc] initWithString:textField.text]autorelease];
    if (![string length]) {
        NSRange range;
        range.location = [searchString length]-1;
        range.length = 1;
        
        [searchString deleteCharactersInRange:range];
    }
    else {
        [searchString appendFormat:@"%@",string];
    }
    
    if ([searchString length] > 0) {
        if (isSearchViewDisplay) {
            return YES;
        }
        
        isSearchViewDisplay = YES;
        self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, 0);
        [self.searchView setHidden:NO];
 
        float height = 504;
        [UIView animateWithDuration:.3 animations:^{
            //set new originY as you want.
            self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, height);
            [self.btnCancel setHidden:NO];
            
        } completion:^(BOOL finished) {
        }];
    } else if ([searchString length] == 0) {
        isSearchViewDisplay = NO;
        self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, 504);
 
        float height = 0;
        [UIView animateWithDuration:.3 animations:^{
            //set new originY as you want.
            self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, height);
        } completion:^(BOOL finished) {
            [self.searchView setHidden:YES];
            [self.btnCancel setHidden:YES];
        }];
    }
    
    return YES;
}
*/
 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, 0);
    [self.searchView setHidden:NO];
    
    /*Display View With Animation*/
    float height = 504;
    [UIView animateWithDuration:.3 animations:^{
        //set new originY as you want.
        self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y, self.searchView.frame.size.width, height);
        [self.btnCancel setHidden:NO];
        
    } completion:^(BOOL finished) {
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [txtSearch resignFirstResponder];
    return YES;
}

@end
