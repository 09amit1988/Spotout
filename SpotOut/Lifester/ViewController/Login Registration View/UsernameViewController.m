//
//  UsernameViewController.m
//  Lifester
//
//  Created by MAC240 on 2/4/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "UsernameViewController.h"
#import "UIImage+Uiimage_Fixorientation.h"
#import "JSON.h"
#import "CategorySelectionViewController.h"
#import "InviteFacebookFriendViewController.h"

@interface UsernameViewController ()

@end

@implementation UsernameViewController


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
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Log In"];
    self.view.backgroundColor = VIEW_COLOR;
    
    isUsernameAutoGenerated = NO;
    
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [btnUsernameAccesary setHidden:YES];
    appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBarHidden = NO;
    [self setupMenuBarButtonItems];
    
    imvProfile.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImgUrl"]];
    imvProfile.contentMode = UIViewContentModeScaleAspectFill;
    [imvProfile setClipsToBounds: YES];
    [[imvProfile layer] setMasksToBounds:YES];
    [[imvProfile layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[imvProfile layer] setBorderWidth:0.7];
    [[imvProfile layer] setCornerRadius:imvProfile.frame.size.width/2.0];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [self viewWillAppear:animated];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIFont *fontStyle = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
    
    txtUsername.textColor = SELECTED_COLOR;
    txtUsername.font = fontStyle;
    txtProfileName.textColor = SELECTED_COLOR;
    txtProfileName.font = fontStyle;
    
    if ([txtUsername respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtUsername.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.rightBarButtonItems = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItems = [self leftMenuBarButtonItem];
}

- (NSArray *)leftMenuBarButtonItem {
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 6, 56, 32);
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDone setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnDone.titleLabel setTextColor:[UIColor whiteColor]];
    [btnDone addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnDone] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
}

- (NSArray *)rightMenuBarButtonItem {
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 6, 56, 32);
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone.titleLabel setTextColor:[UIColor whiteColor]];
    [btnDone addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnDone] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
}

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    
}


#pragma mark - UIButton Mrthods

- (IBAction)btnSignInAction:(id)sender
{
    if (![txtUsername.text length]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please Enter Username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    } else if (![txtProfileName.text length]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please Enter ProfileName." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }

    
    [self RegistrationWithFacebookWebServiceCall];
}

- (IBAction)btnSelectImage:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:appname delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"Gallery",nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
    [action release];
}

#pragma mark - Registration service Method

-(void)RegistrationWithFacebookWebServiceCall {
    
    if (appDelegate.locationManager.location.coordinate.latitude!=0.000000 && appDelegate.locationManager.location.coordinate.latitude!=0.000000) {
    }
    else {
        [appDelegate showActivity:self.view showOrHide:NO];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [appDelegate showActivity:self.view showOrHide:YES];
    appDelegate.LoginFlag = false;
    flag = 1;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
//    NSString *tempStr = @"";
//    
////    if ([SexStr isEqualToString:@"Male"] || [SexStr isEqualToString:@"male"]) {
////        tempStr = @"M";
////    } else {
////        tempStr = @"F";
////    }
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_registration" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    
    [request setPostValue:[appDelegate.dictFacebook objectForKey:@"email"] forKey:@"login_email_id"];
    [request setPostValue:[appDelegate.dictFacebook objectForKey:@"id"] forKey:@"login_password"];
    if (txtUsername.text.length == 0) {
        [request setPostValue:@"" forKey:@"login_username"];
    } else {
        [request setPostValue:txtUsername.text forKey:@"login_username"];
    }
    if (txtProfileName.text.length == 0) {
        [request setPostValue:@"" forKey:@"profile_name"];
    } else {
        [request setPostValue:txtProfileName.text forKey:@"profile_name"];
    }
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"FName"] forKey:@"f_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"LName"] forKey:@"l_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"] forKey:@"dob"];
    //[request setPostValue:tempStr forKey:@"sex"];
    [request setPostValue:@"" forKey:@"sex"];
    [request setPostValue:@"" forKey:@"street"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"City"] forKey:@"city_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"City_Short_Name"] forKey:@"city_short_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"State"] forKey:@"state_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"State_Short_Name"] forKey:@"state_short_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country"] forKey:@"country_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country_Short_Name"] forKey:@"country_short_name"];
    [request setPostValue:[NSNumber numberWithBool:YES] forKey:@"lwfb"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addData:[[NSUserDefaults standardUserDefaults] valueForKey:@"ImgUrl"] withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"image_file"];
    
    [request startAsynchronous];
}

-(void)LoginWithFacebookWebServiceCall:(BOOL)status
{
    if (appDelegate.locationManager.location.coordinate.latitude!=0.000000 && appDelegate.locationManager.location.coordinate.latitude!=0.000000) {
    }
    else {
        [appDelegate showActivity:self.view showOrHide:NO];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    appDelegate.LoginFlag=TRUE;
    
    flag=1;
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
#if TARGET_IPHONE_SIMULATOR
    appDelegate.dt = @"6f44395d0bbd6afd64bfba8710047bcabafb3a8d1bfa5725e398d0a2bbbe3359";
#endif
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *deviceVersion = [currentDevice systemVersion];
    NSString *name = [currentDevice name];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:[appDelegate.dictFacebook objectForKey:@"email"]  forKey:@"LogInID"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_login" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[appDelegate.dictFacebook objectForKey:@"email"] forKey:@"login_id"];
    if (status) {
        [request setPostValue:[appDelegate.dictFacebook objectForKey:@"id"] forKey:@"login_password"];
    } else{
        [request setPostValue:appDelegate.alertPassowrd forKey:@"login_password"];
    }
    
    [request setPostValue:appName forKey:@"appname"];
    [request setPostValue:appVersion forKey:@"appversion"];
    [request setPostValue:[appDelegate idForDevice] forKey:@"device_uid"];
    [request setPostValue:appDelegate.dt forKey:@"device_token"];
    [request setPostValue:name forKey:@"device_name"];
    [request setPostValue:model forKey:@"device_model"];
    [request setPostValue:deviceVersion forKey:@"device_version"];
    [request setPostValue:@"iOS" forKey:@"device_os"];
    [request setPostValue:push_mode forKey:@"push_mode"];
    [request setPostValue:[NSNumber numberWithBool:status] forKey:@"lwfb"];
    
    if (appDelegate.locationManager.location.coordinate.latitude!=0.000000 && appDelegate.locationManager.location.coordinate.latitude!=0.000000) {
        
        [request setPostValue:[NSString stringWithFormat:@"%f %f",appDelegate.locationManager.location.coordinate.latitude,appDelegate.locationManager.location.coordinate.longitude] forKey:@"gps_coordinate"];
    }
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)CheckUsernameExist:(NSString *)username
{
    flag=2;
    
    self.view.userInteractionEnabled = NO;
    [appDelegate showActivity:self.view showOrHide:YES];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_check_username" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setPostValue:username forKey:@"login_username"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (flag == 1) {
        if (appDelegate.LoginFlag==FALSE) {
            
            NSString *receivedString = [request responseString];
            
            NSDictionary *responseObject = [receivedString JSONValue];
            NSArray *items = [responseObject objectForKey:@"raws"];
            
            NSLog(@"Registration items  %@",items);
            
            if ([[[items valueForKey:@"status"] valueForKey:@"registration_status"] isEqualToString:@"true"] || [[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"101"]) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DOB"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Sex"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"City"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"City_Short_Name"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"State"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"State_Short_Name"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Country"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Country_Short_Name"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Choices"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImgUrl"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EmailId"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"type_3rdparty"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FBID"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileName"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ProfImage"];

                appDelegate.LoginFromFBFlag = @"1";
                
                if ([[[items valueForKey:@"status"] valueForKey:@"registration_status"] isEqualToString:@"true"])
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsNewRegistration"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [appDelegate postUpdate];
                }
                
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentTab"];
                if (appDelegate.locationManager.location.coordinate.latitude!=0.000000 && appDelegate.locationManager.location.coordinate.latitude!=0.000000) {
                    [self LoginWithFacebookWebServiceCall:YES];
                }
                else {
                    [appDelegate showActivity:self.view showOrHide:NO];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alert.tag=1001;
                    [alert show];
                    [alert release];
                }
            }
            else {
                [appDelegate showActivity:self.view showOrHide:NO];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
        else {
            NSString *receivedString = [request responseString];
            
            NSDictionary *responseObject = [receivedString JSONValue];
            NSArray *items = [responseObject objectForKey:@"raws"];
            
            if ([[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
                if([[UIScreen mainScreen] bounds].size.height == 480) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification4S" object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotificationIPhone5" object:nil];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissSignupScreenNotification" object:nil];
                
                appDelegate.userID = [[items valueForKey:@"dataset"] valueForKey:@"user_id"];
                appDelegate.PassKey = [[items valueForKey:@"dataset"] valueForKey:@"pass_key"];
                
                NSString *followingCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"following_count"]];
                NSString *followerCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"follower_count"]];
                [[NSUserDefaults standardUserDefaults] setObject:followingCount forKey:@"following_count"];
                [[NSUserDefaults standardUserDefaults] setObject:followerCount forKey:@"follower_count"];
                
                NSString *reviewCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"review_count"]];
                [[NSUserDefaults standardUserDefaults] setObject:reviewCount forKey:@"review_count"];
                
                NSString *avg_rating = [NSString stringWithFormat:@"%.2f",[[[items valueForKey:@"dataset"] valueForKey:@"avg_rating_profile"] floatValue]];
                [[NSUserDefaults standardUserDefaults] setObject:avg_rating forKey:@"profile_rating"];
                
                [[NSUserDefaults standardUserDefaults] setObject:appDelegate.userID forKey:@"userID"];
                [[NSUserDefaults standardUserDefaults] setObject:appDelegate.PassKey forKey:@"PassKey"];
                if ([[[items valueForKey:@"dataset"] valueForKey:@"ProfileName"] class] == [NSNull class]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"profileName"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"ProfileName"] forKey:@"profileName"];
                }
                
                if ([[[items valueForKey:@"dataset"] valueForKey:@"username"] class] == [NSNull class]) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"username"] forKey:@"username"];
                }

                if ([[[[items valueForKey:@"dataset"] valueForKey:@"profile_image"] valueForKey:@"has_profile_picture"] boolValue]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[[[items valueForKey:@"dataset"] valueForKey:@"profile_image"] valueForKey:@"image_url"] forKey:@"ProfImage"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:DEFAULTPROFILEIMAGE forKey:@"ProfImage"];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"f_name"] forKey:@"FName"];
                [[NSUserDefaults standardUserDefaults] setObject:[[items valueForKey:@"dataset"] valueForKey:@"l_name"] forKey:@"LName"];
                
                //-Added by amit on 21/8/2013
                
                [appDelegate showActivity:self.view showOrHide:NO];
                appDelegate.IsNewFacebookRegistration = YES;
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsNewRegistration"]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsNewRegistration"];
                    CategorySelectionViewController *viewController = [[CategorySelectionViewController alloc] initWithNibName:@"CategorySelectionViewController" bundle:nil];
                    [self.navigationController pushViewController:viewController animated:YES];
                } else {
                    InviteFacebookFriendViewController *inviteFacebookFriendViewController = [[[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil] autorelease];
                    
                    if([[UIScreen mainScreen] bounds].size.height == 480)
                        [self.navigationController pushViewController:inviteFacebookFriendViewController animated:YES];
                    else
                        [self.navigationController pushViewController:inviteFacebookFriendViewController animated:YES];
                }
                
                
            } else if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"101"]) {
                NSLog(@"Status code is ==== 101");
                NSLog(@"User is not registered with this mail id");
                
                appDelegate.LoginFromFBFlag = @"0";
                appDelegate.isSignUpWithFacebook = YES;
                appDelegate.isLoginWithFacebook = NO;
                [self RegistrationWithFacebookWebServiceCall];
            } else if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"102"]) {
                
                
                NSString *message = [NSString stringWithFormat:@"Email Id Already Registered with Normal User. Do you want to continue with Facebook account ?"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                                message:message
                                                               delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                [alert setTag:102];
                [alert show];
                [alert release];
            }
            else if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"103"]) {
                //You are already registered with normal user not with facebook
                
                NSString *message = [NSString stringWithFormat:@"It looks like you already are a Spotly user. Enter account password for connecting you account with Facebook."];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[appDelegate.dictFacebook objectForKey:@"email"]
                                                                message:message
                                                               delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Continue", nil];
                [alert setTag:103];
                alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                [alert show];
                [alert release];
            } else {
                [appDelegate showActivity:self.view showOrHide:NO];
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
    } else if (flag == 2) {
        // parse response of Check username exist service
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSDictionary *items = [responseObject objectForKey:@"raws"];
        if([[[items objectForKey:@"status"] objectForKey:@"username_status"] boolValue]) {
            NSLog(@"TRUE");
            [errorOverlay removeFromSuperview];
            [btnUsernameAccesary setHidden:NO];
            [btnUsernameAccesary setImage:[UIImage imageNamed:@"right-icon.png"] forState:UIControlStateNormal];
            txtUsername.textColor = [UIColor colorWithRed:129.0/255.0 green:197.0/255.0 blue:102.0/255.0 alpha:1.0];
        } else {
            if (isUsernameAutoGenerated) {
                isUsernameAutoGenerated = NO;
                NSString *newUserName = [[items objectForKey:@"status"] objectForKey:@"newusername"];
                txtUsername.text = newUserName;
                [btnUsernameAccesary setHidden:NO];
                [btnUsernameAccesary setImage:[UIImage imageNamed:@"right-icon.png"] forState:UIControlStateNormal];
                txtUsername.textColor = [UIColor colorWithRed:129.0/255.0 green:197.0/255.0 blue:102.0/255.0 alpha:1.0];
                
                [errorOverlay removeFromSuperview];
            } else {
                [btnUsernameAccesary setHidden:NO];
                [btnUsernameAccesary setImage:[UIImage imageNamed:@"cancel-icon.png"] forState:UIControlStateNormal];
                txtUsername.textColor = [UIColor colorWithRed:229.0/255.0 green:78.0/255.0 blue:77.0/255.0 alpha:1.0];
                
                [errorOverlay removeFromSuperview];
                [errorOverlay setAlpha:0.f];
                
                [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [errorOverlay setAlpha:1.f];
                } completion:^(BOOL finished) {
                    
                }];
                
                isFrameExtended = YES;
                CGRect frame = usernameView.frame;
                errorOverlay.frame = CGRectMake(frame.origin.x+5, frame.origin.y + frame.size.height, errorOverlay.frame.size.width, errorOverlay.frame.size.height);
                [self.view addSubview:errorOverlay];
                [self.view bringSubviewToFront:errorOverlay];
                
                [UIView commitAnimations];

            }
        }
        
        self.view.userInteractionEnabled = YES;
        [appDelegate showActivity:self.view showOrHide:NO];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	
    [appDelegate showActivity:self.view showOrHide:NO];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex == 1) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Sorry! No Camera Found !!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
		else {
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = YES;
			[self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
	if(buttonIndex == 2) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary])
        {
            imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
	}
}

#pragma mark - Image Picker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker1 didFinishPickingImage:(UIImage *)imageSel editingInfo:(NSDictionary *)editingInfo {
    
	UIImage *scaledImage = imageSel; //[self imageWithImage:imageSel scaledToSize:CGSizeMake(300.0f, 400.0f)];
	[imvProfile setImage:scaledImage];
    imvProfile.contentMode = UIViewContentModeScaleAspectFill;
    [imvProfile setClipsToBounds: YES];
    [[imvProfile layer] setMasksToBounds:YES];
    [[imvProfile layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[imvProfile layer] setBorderWidth:0.7];
    [[imvProfile layer] setCornerRadius:imvProfile.frame.size.width/2.0];
    
    NSData *dataImage = UIImageJPEGRepresentation([imvProfile.image fixOrientation],0.80);
    [[NSUserDefaults standardUserDefaults] setObject:dataImage forKey:@"ImgUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
	[imagePicker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 9) {
        if ([string isEqualToString:@" "]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag==9) {
        if ([textField.text length] > 0) {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            } else {
  
                if (isFrameExtended) {
                    
                    isFrameExtended = NO;
                    [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [errorOverlay setAlpha:0.f];
                        [errorOverlay removeFromSuperview];
                    } completion:nil];
                    
                    [btnUsernameAccesary setHidden:YES];

                    [UIView commitAnimations];
                    
                }
            }
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1) {
        if ([textField.text length] > 0) {
            NSString *username = @"&";
            
            NSArray *array = [textField.text componentsSeparatedByString:@" "];
            for (int i = 0; i < [array count]; i++) {
                username = [username stringByAppendingString:[[array objectAtIndex:i] capitalizedString]];
            }
            
            txtUsername.text = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
            [textField resignFirstResponder];
            isUsernameAutoGenerated = YES;
            [self CheckUsernameExist:txtUsername.text];
        }
    } else if (textField.tag==9) {
        if ([textField.text length] > 0) {
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            } else {
                [textField resignFirstResponder];
                isUsernameAutoGenerated = NO;
                [self CheckUsernameExist:txtUsername.text];
            }
        }
    }
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *) textField
{
    if (textField.tag==9) {
        txtUsername.textColor = SELECTED_COLOR;
    }
    return YES;
}

@end