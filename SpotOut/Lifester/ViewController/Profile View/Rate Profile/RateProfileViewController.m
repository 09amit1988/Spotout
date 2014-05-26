//
//  RateProfileViewController.m
//  Lifester
//
//  Created by MAC205 on 13/02/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "RateProfileViewController.h"


@interface RateProfileViewController ()

@end

@implementation RateProfileViewController

@synthesize isRatingAdded;
@synthesize arrReviews;
@synthesize reviewPersonal;
@synthesize isOtherUser;
@synthesize user;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.arrReviews = nil;
    self.reviewPersonal = nil;
    self.user = nil;
}

- (void)dealloc
{
    [super dealloc];
    [arrReviews release];
    [tblComment release];
    [toolBar release];
    [headerTableView release];
    [commentView release];
    [txtAddComment release];
    [addCommentView release];
    [btnDone release];
    [imvDivideLine release];
    [rateSlider release];
    [rateview release];
    [profileRateView release];
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Reviews"];
    [self setupMenuBarButtonItems];
    
    self.arrReviews = [[NSMutableArray alloc] init];
    lastContentSize = 33.0;
    isMoreExpanded = NO;
    txtAddComment.placeholder = @"Add Comment";
    
    [[addCommentView layer] setBorderColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor];
    [[addCommentView layer] setBorderWidth:0.7];
    [[addCommentView layer] setCornerRadius:3.0];
    
    
    
    [rateSlider setThumbImage: [UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];

    rateview = [[DYRateView alloc] initWithFrame:CGRectMake(93, 15, 125, 30) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
    rateview.alignment = RateViewAlignmentLeft;
    rateview.editable = NO;
    rateview.delegate = self;
    [headerTableView addSubview:rateview];
    
    profileRateView = [[DYRateView alloc] initWithFrame:CGRectMake(20, 45, 125, 30) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
    profileRateView.alignment = RateViewAlignmentLeft;
    profileRateView.editable = NO;
    profileRateView.delegate = self;
    [commentView addSubview:profileRateView];
    
    headerTableView.backgroundColor = [UIColor  colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    commentView.backgroundColor = [UIColor  colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    [toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar sizeToFit];
    [txtAddComment setInputAccessoryView:toolBar];
    
    txtAddComment.placeholderTextColor = NORMAL_COLOR;
    txtAddComment.textColor = SELECTED_COLOR;
    
    imvDivideLine.frame = CGRectMake(imvDivideLine.frame.origin.x, imvDivideLine.frame.origin.y, imvDivideLine.frame.size.width, 0.7);
    
    [self getProfileRatingReview];
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
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

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Method

- (void)assignValueToCommentView
{
    profileRateView.rate = self.reviewPersonal.rating;
    if (self.reviewPersonal.hasProfilePicture) {
        imvCommentProfile.imageURL = [NSURL URLWithString:self.reviewPersonal.profileImage];
    } else {
        imvCommentProfile.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    lblProfileName.text = self.reviewPersonal.username;
    lblOwnComment.text = self.reviewPersonal.comment;
    lblTimeDifference.text = self.reviewPersonal.timeDifference;
    
    if ([self.reviewPersonal.comment length] > 0) {
        [lblOwnComment setHidden:NO];
        
        float height = [self.reviewPersonal.comment RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
        lblOwnComment.numberOfLines = 0;
        
        float yOrigin = 0;
        
        if (height >= 77.0) {
            height = 77.0;
            
            CGRect frame = CGRectMake(lblOwnComment.frame.origin.x, lblOwnComment.frame.origin.y, lblOwnComment.frame.size.width, height);
            lblOwnComment.frame = frame;
            yOrigin = height + lblOwnComment.frame.origin.y;
            
            btnMore.frame = CGRectMake(btnMore.frame.origin.x, yOrigin, btnMore.frame.size.width, btnMore.frame.size.height);
            yOrigin = yOrigin + btnMore.frame.size.height;
            
            [btnMore setTitle:@"More" forState:UIControlStateNormal];
            [btnMore setTitle:@"More" forState:UIControlStateHighlighted];
            [btnMore setHidden:NO];
        } else {
            CGRect frame = CGRectMake(lblOwnComment.frame.origin.x, lblOwnComment.frame.origin.y, lblOwnComment.frame.size.width, height);
            lblOwnComment.frame = frame;
            yOrigin = height + lblOwnComment.frame.origin.y;
            
            [btnMore setHidden:YES];
        }
        
        imvClockIcon.frame = CGRectMake(imvClockIcon.frame.origin.x, yOrigin+6.0, imvClockIcon.frame.size.width, imvClockIcon.frame.size.height);
        lblTimeDifference.frame = CGRectMake(lblTimeDifference.frame.origin.x, yOrigin, lblTimeDifference.frame.size.width, lblTimeDifference.frame.size.height);
        
        yOrigin = yOrigin + lblTimeDifference.frame.size.height;
        commentView.frame = CGRectMake(commentView.frame.origin.x, commentView.frame.origin.y, commentView.frame.size.width, yOrigin);
    } else {
        [lblOwnComment setHidden:YES];
        [btnMore setHidden:YES];
        
        float yOrigin = 53;
        yOrigin = yOrigin + btnMore.frame.size.height;
        imvClockIcon.frame = CGRectMake(imvClockIcon.frame.origin.x, yOrigin+6.0, imvClockIcon.frame.size.width, imvClockIcon.frame.size.height);
        lblTimeDifference.frame = CGRectMake(lblTimeDifference.frame.origin.x, yOrigin, lblTimeDifference.frame.size.width, lblTimeDifference.frame.size.height);
        
        yOrigin = yOrigin + lblTimeDifference.frame.size.height;
        commentView.frame = CGRectMake(commentView.frame.origin.x, commentView.frame.origin.y, commentView.frame.size.width, yOrigin);
    }
}

#pragma mark - Action Callbacks

- (IBAction)btnDoneHideKeyboardAction:(id)sender
{
    [txtAddComment resignFirstResponder];
}

- (IBAction)btnMoreToggleAction:(id)sender
{
    float height = [self.reviewPersonal.comment RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
    if (isMoreExpanded) {
        isMoreExpanded = NO;
        
        if (height >= 77.0) {
            height = 77.0;
            
            [btnMore setTitle:@"More" forState:UIControlStateNormal];
            [btnMore setTitle:@"More" forState:UIControlStateHighlighted];
        } else {
            [btnMore setHidden:YES];
        }
    } else {
        isMoreExpanded = YES;
        CGRect frame = CGRectMake(lblOwnComment.frame.origin.x, lblOwnComment.frame.origin.y, lblOwnComment.frame.size.width, height);
        lblOwnComment.frame = frame;
        
        [btnMore setTitle:@"Less" forState:UIControlStateNormal];
        [btnMore setTitle:@"Less" forState:UIControlStateHighlighted];
    }
    
    CGRect frame = CGRectMake(lblOwnComment.frame.origin.x, lblOwnComment.frame.origin.y, lblOwnComment.frame.size.width, height);
    lblOwnComment.frame = frame;
    
    float yOrigin = height + lblOwnComment.frame.origin.y;
    btnMore.frame = CGRectMake(btnMore.frame.origin.x, yOrigin, btnMore.frame.size.width, btnMore.frame.size.height);
    
    yOrigin = yOrigin + btnMore.frame.size.height;
    imvClockIcon.frame = CGRectMake(imvClockIcon.frame.origin.x, yOrigin+6.0, imvClockIcon.frame.size.width, imvClockIcon.frame.size.height);
    lblTimeDifference.frame = CGRectMake(lblTimeDifference.frame.origin.x, yOrigin, lblTimeDifference.frame.size.width, lblTimeDifference.frame.size.height);
    
    yOrigin = yOrigin + lblTimeDifference.frame.size.height;
    commentView.frame = CGRectMake(commentView.frame.origin.x, commentView.frame.origin.y, commentView.frame.size.width, yOrigin);
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    tblComment.tableHeaderView = commentView;
    [UIView commitAnimations];
}

- (IBAction)btnSaveProfileRatingAction:(id)sender
{
    NSLog(@"Rating ==== %f", [rateSlider value]/3);
    if (([rateSlider value]/3) < 0.33) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please first select rating."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }

    [self AddProfileRating];
    return;
    
    commentView.alpha = 0;
    
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.0];
    tblComment.tableHeaderView = commentView;
    headerTableView.alpha = 0;
    commentView.alpha = 1.0;
    [UIView commitAnimations];
}

- (IBAction)btnEditRateProfileRatingAction:(id)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:appname
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Edit Profile Rating", @"Remove Profile Rating",nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
    [action release];
}

- (IBAction)sliderValueChangeAction:(id)sender
{
    NSString *string = [NSString stringWithFormat:@"%f",([rateSlider value]/3)];
    if ([string isEqualToString:@"0.333333"]) {
        rateview.rate = ((int)[rateSlider value]/3);

    } else {
        float floor = round([rateSlider value]);
        rateview.rate = floor/3;
    }
}

#pragma mark - Web service call Methods

- (void)getProfileRatingReview {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    [appDelegate showActivity:self.view showOrHide:YES];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    flag = 4;
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"get_profile_rating" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:self.profileID forKey:@"profile_review_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}


- (void)AddProfileRating {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }

    [appDelegate showActivity:self.view showOrHide:YES];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    flag = 1;
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"add_profile_rating" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[NSString stringWithFormat:@"%.2f", rateview.rate] forKey:@"rating"];
    [request setPostValue:txtAddComment.text forKey:@"comment"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:self.profileID forKey:@"comment_user_id"];
    
//    if (isOtherUser) {
//        [request setPostValue:self.profileID forKey:@"user_id"];
//        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"comment_user_id"];
//    } else {
//        
//    }
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)RemoveProfileRating {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    [request setPostValue:@"delete_profile_rating" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:self.profileID forKey:@"profile_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *receivedString = [request responseString];
    
    NSDictionary *responseObject = [receivedString JSONValue];
    NSDictionary *items = [responseObject objectForKey:@"raws"];
    //NSLog(@"Response === %@", items);
    
    if (flag == 1) {
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Rating Added"] || [[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Rating Updated"]) {
            @try {
                NSDictionary *dictTemp = [[[items valueForKey:@"status"] valueForKey:@"data"] objectAtIndex:0];
                
                isMoreExpanded = NO;
                self.reviewPersonal = [[ReviewComment alloc] initWithDictionary:[dictTemp objectForKey:@"profile"]];
                [self assignValueToCommentView];
                
                [UIView beginAnimations:@"fade in" context:nil];
                [UIView setAnimationDuration:1.0];
                commentView.alpha = 1.0;
                headerTableView.alpha = 0;
                tblComment.tableHeaderView = commentView;
                [UIView commitAnimations];
                
                if ([[[dictTemp valueForKey:@"profile"] objectForKey:@"review_count"] class] == [NSNull class]) {
                    self.user.reviewCount = 0;
                } else {
                    self.user.reviewCount = [[dictTemp valueForKey:@"profile"] objectForKey:@"review_count"];
                }
                self.user.profileRating = [[[dictTemp objectForKey:@"profile"] objectForKey:@"avg_rating_profile"] floatValue];
            }
            @catch (NSException *exception) {
                NSLog(@"Exception ==== %@", exception);
            }
            @finally {
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    } else if (flag == 2) {
        // Edit profile rating response
    } else if (flag == 3) {
        // Remove profile rating response
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Deleted Successfully"]) {
            if ([[[items valueForKey:@"status"] objectForKey:@"review_count"] class] == [NSNull class]) {
                self.user.reviewCount = 0;
            } else {
                self.user.reviewCount = [[items valueForKey:@"status"] objectForKey:@"review_count"];
            }
            self.user.profileRating = [[[items valueForKey:@"status"] objectForKey:@"avg_rating_profile"] floatValue];
            
            rateview.rate = 0;
            txtAddComment.text = @"";
            
            txtAddComment.frame = CGRectMake(txtAddComment.frame.origin.x, txtAddComment.frame.origin.y, txtAddComment.frame.size.width, 37);
            addCommentView.frame = CGRectMake(addCommentView.frame.origin.x, addCommentView.frame.origin.y, addCommentView.frame.size.width, 40.0);
            
            btnDone.frame = CGRectMake(btnDone.frame.origin.x, 137, btnDone.frame.size.width, btnDone.frame.size.height);
            headerTableView.frame = CGRectMake(headerTableView.frame.origin.x, headerTableView.frame.origin.y, headerTableView.frame.size.width, 176);
            headerTableView.alpha = 0;

            [UIView beginAnimations:@"fade in" context:nil];
            [UIView setAnimationDuration:1.0];
            commentView.alpha = 0;
            headerTableView.alpha = 1.0;
            tblComment.tableHeaderView = headerTableView;
            [UIView commitAnimations];
        }
    } else if (flag == 4) {
        // Get profile rating review
        if ([[[items valueForKey:@"status"] valueForKey:@"Success_msg"] isEqualToString:@"Time Line"]) {
            @try {
                NSLog(@"Class === %@", [[[items valueForKey:@"status"] valueForKey:@"rating_status"] class]);
                if ([[[items valueForKey:@"status"] valueForKey:@"rating_status"] boolValue] == YES) {
                    tblComment.tableHeaderView = commentView;
                } else {
                    tblComment.tableHeaderView = headerTableView;
                }
                
                if ([self.profileID integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] integerValue]) {
                    tblComment.tableHeaderView = nil;
                }
                
                
                NSMutableArray *arrTemp = [[[items valueForKey:@"status"] valueForKey:@"data"] objectAtIndex:0];
                [self.arrReviews removeAllObjects];
                [tblComment reloadData];
                
                for (NSMutableDictionary *dictData in arrTemp) {
                    ReviewComment *reviewComment = [[ReviewComment alloc] initWithDictionary:dictData];
                    if ([reviewComment.userID integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] integerValue]) {
                        self.reviewPersonal = reviewComment;
                        [self assignValueToCommentView];
                        tblComment.tableHeaderView = commentView;
                        continue;
                    }
                    
                    int index = [self.arrReviews count];
                    [self.arrReviews addObject:reviewComment];
                    
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:index inSection:0]; //ALSO TRIED WITH indexPathRow:0
                    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
                    [tblComment insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Exception ==== %@", exception);
            }
            @finally {
                
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    
    [appDelegate showActivity:self.view showOrHide:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [appDelegate showActivity:self.view showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


#pragma mark - UIActionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        NSLog(@"Edit Profile Rating");
        headerTableView.alpha = 0;
        txtAddComment.text = self.reviewPersonal.comment;
        rateSlider.value = self.reviewPersonal.rating*3;
        NSString *string = [NSString stringWithFormat:@"%f",([rateSlider value]/3)];
        if ([string isEqualToString:@"0.333333"]) {
            rateview.rate = ((int)[rateSlider value]/3);
            
        } else {
            float floor = round([rateSlider value]);
            rateview.rate = floor/3;
        }
        lblTimeDifference.text = self.reviewPersonal.timeDifference;
        
        float height = [self.reviewPersonal.comment RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:280.0] + 15.0;
        txtAddComment.frame = CGRectMake(txtAddComment.frame.origin.x, txtAddComment.frame.origin.y, txtAddComment.frame.size.width, height);
        addCommentView.frame = CGRectMake(addCommentView.frame.origin.x, addCommentView.frame.origin.y, addCommentView.frame.size.width, height + 4.0);
        
        float yOrigin = addCommentView.frame.origin.y + addCommentView.frame.size.height + 10;
        btnDone.frame = CGRectMake(btnDone.frame.origin.x, yOrigin, btnDone.frame.size.width, btnDone.frame.size.height);
        yOrigin = yOrigin + btnDone.frame.size.height + 7;
        
        headerTableView.frame = CGRectMake(headerTableView.frame.origin.x, headerTableView.frame.origin.y, headerTableView.frame.size.width, yOrigin);
        
        //[self updateTextViewSize];
        
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:1.0];
        commentView.alpha = 0;
        headerTableView.alpha = 1.0;
        tblComment.tableHeaderView = headerTableView;
        [UIView commitAnimations];
    } else if (buttonIndex == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Are you sure you want remove profile rating ?"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self RemoveProfileRating];
    }
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrReviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simple=@"Simple";
    RateProfileCell *cell = (RateProfileCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RateProfileCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    } else {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    
    ReviewComment *reviewComment = [self.arrReviews objectAtIndex:indexPath.row];
    
    
    DYRateView *rateview1 = [[DYRateView alloc] initWithFrame:CGRectMake(55, 35, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview1.editable = NO;
    rateview1.rate = reviewComment.rating;
    [cell addSubview:rateview1];

    if (reviewComment.hasProfilePicture) {
        cell.imvProfileUser.imageURL = [NSURL URLWithString:reviewComment.profileImage];
    } else {
        cell.imvProfileUser.imageURL = [NSURL URLWithString:DEFAULTPROFILEIMAGE];
    }
    
    cell.lblUserName.text = reviewComment.username;
    cell.lblComment.text = reviewComment.comment;
    cell.lblTimeDifference.text = reviewComment.timeDifference;
    
    if ([reviewComment.comment length] > 0) {
        [cell.lblComment setHidden:NO];
        float height = [reviewComment.comment RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
        cell.lblComment.numberOfLines = 0;
        
        CGRect frame = CGRectMake(cell.lblComment.frame.origin.x, cell.lblComment.frame.origin.y, cell.lblComment.frame.size.width, height);
        cell.lblComment.frame = frame;
        
        float yOrigin = height + cell.lblComment.frame.origin.y;
        cell.imvClockIcon.frame = CGRectMake(cell.imvClockIcon.frame.origin.x, yOrigin+6.0, cell.imvClockIcon.frame.size.width, cell.imvClockIcon.frame.size.height);
        cell.lblTimeDifference.frame = CGRectMake(cell.lblTimeDifference.frame.origin.x, yOrigin, cell.lblTimeDifference.frame.size.width, cell.lblTimeDifference.frame.size.height);
    } else {
        [cell.lblComment setHidden:YES];
        
        float yOrigin = 53;
        cell.imvClockIcon.frame = CGRectMake(cell.imvClockIcon.frame.origin.x, yOrigin+6.0, cell.imvClockIcon.frame.size.width, cell.imvClockIcon.frame.size.height);
        cell.lblTimeDifference.frame = CGRectMake(cell.lblTimeDifference.frame.origin.x, yOrigin, cell.lblTimeDifference.frame.size.width, cell.lblTimeDifference.frame.size.height);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewComment *reviewComment = [self.arrReviews objectAtIndex:indexPath.row];
    float height = [reviewComment.comment RAD_textHeightForFontName:HELVETICANEUEREGULAR FontOfSize:14.0 MaxWidth:290.0]+10.0;
//    if (height >= 77.0) {
//        height = 77.0 + 53 + 25;
//    } else {
//        height = height + 53 + 25;
//    }
    height = height + 53 + 25;
    return height;
    
    return 153.0;
}


#pragma mark - Delegate for textview

-(void)updateTextViewSize
{
    CGRect rect = txtAddComment.frame;
    //rect.size.width = txtAddComment.contentSize.width;
    rect.size.height = txtAddComment.contentSize.height;
    txtAddComment.frame = rect;
    
    if (addCommentView.frame.size.height < rect.size.height ) {
        CGRect rect1;
        rect1 = addCommentView.frame;
        rect1.size.height = rect1.size.height + 16.0;
        addCommentView.frame = rect1;
        
        CGRect rect3;
        rect3 = btnDone.frame;
        rect3.origin.y = rect3.origin.y + 16.0;
        btnDone.frame = rect3;
        
        CGRect rect2;
        rect2 = headerTableView.frame;
        rect2.size.height = rect2.size.height + 16.0;
        headerTableView.frame = rect2;
        [tblComment setTableHeaderView:headerTableView];
    } else if (addCommentView.frame.size.height > rect.size.height) {
        CGRect rect1;
        rect1 = addCommentView.frame;
        rect1.size.height = rect1.size.height - 16.0;
        addCommentView.frame = rect1;
        
        CGRect rect3;
        rect3 = btnDone.frame;
        rect3.origin.y = rect3.origin.y - 16.0;
        btnDone.frame = rect3;
        
        CGRect rect2;
        rect2 = headerTableView.frame;
        rect2.size.height = rect2.size.height - 16.0;
        headerTableView.frame = rect2;
        [tblComment setTableHeaderView:headerTableView];
    }
}

-(void)textViewDidChange:(UITextView*)textView
{
    float height = textView.contentSize.height;
    //NSLog(@"content size === %f  and new size height === %f", height, lastContentSize);
    if (height >= 33) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        CGRect frame = textView.frame;
        frame.size.height = height; //Give it some padding
        textView.frame = frame;
        
        CGRect rect = txtAddComment.frame;
        if (addCommentView.frame.size.height < rect.size.height) {
            lastContentSize = height;
            [self updateTextViewSize];
        } else if (lastContentSize > height) {
            lastContentSize = height;
            [self updateTextViewSize];
        }
        
        [UIView commitAnimations];
    }
}


@end
