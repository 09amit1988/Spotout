//
//  LoginView_IPhone5.m
//  Lifester
//
//  Created by App Developer on 24/01/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "LoginView_IPhone5.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "FbGraphFile.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "InviteFacebookFriendViewController.h"

@interface LoginView_IPhone5 ()

@end

@implementation LoginView_IPhone5

@synthesize fbGraph;
@synthesize strPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation==UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    appDelegateobj.shouldRotate = YES;
    return UIInterfaceOrientationMaskAll;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ProfImage"];
    
    UIFont *fontStyle = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
    
    userId.textColor = SELECTED_COLOR;
    password.textColor = SELECTED_COLOR;
    
    userId.font = fontStyle;
    password.font = fontStyle;
    
    if ([userId respondsToSelector:@selector(setAttributedPlaceholder:)]) {        
        userId.attributedPlaceholder = [[NSAttributedString alloc] initWithString:userId.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
        password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:password.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;
}

-(IBAction)CheckBtnCall:(id)sender {
    
    if (checkFlag==0) {
        checkFlag =1;
        [checkBtn setImage:[UIImage imageNamed:@"checkedtick.png"] forState:0];
    } else {
        checkFlag=0;
        [checkBtn setImage:[UIImage imageNamed:@"uncheckedtick.png"] forState:0];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    backgroundView.backgroundColor = VIEW_COLOR;
    backgroundView1.backgroundColor = VIEW_COLOR;
    self.view.backgroundColor = WHITE_BACKGROUND_COLOR;
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 6, 56, 32);
    [btnCancel.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel.titleLabel setTextColor:[UIColor whiteColor]];
    [btnCancel addTarget:self action:@selector(BackBtnCall) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnCancel] autorelease];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, backButtonItem, nil];
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Log In"];
    
    appDelegateobj = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPresentControllerNotification:) name:@"DismissNotificationIPhone5" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPresentControllerNotification:) name:@"DismissNotification4S" object:nil];
    
    scrollView.contentSize = CGSizeMake(320, 594);
    scrollView.showsVerticalScrollIndicator = NO;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LogInID"] length]) {
        
        userId.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"LogInID"];
    } else {
        userId.text = @"";
    }
    
    
    checkFlag = 0;
    //PrivacyView.backgroundColor = BACKGROUND_COLOR;
    [PrivacyView removeFromSuperview];
    webView.scrollView.delegate = self;
    
    termslbl.textColor = privacylbl.textColor = [UIColor colorWithRed:3/255.0f green:82/255.0f blue:110/255.0f alpha:1];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"T" forKey:@"type_3rdparty"];
    
    if ([appDelegateobj.accessToken length]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.DobStr forKey:@"DOB"];
        
        [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.SexStr forKey:@"Sex"];
        
        [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.fNameStr forKey:@"FName"];
        
        [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.lNameStr forKey:@"LName"];
        
        [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.EmailAddress forKey:@"EmailId"];
        
        [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.FBID forKey:@"FBID"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"F" forKey:@"type_3rdparty"];
        
        [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.accessToken forKey:@"accessToken"];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSURL *url = [NSURL URLWithString:appDelegateobj.imgUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"City_Short_Name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"State"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"State_Short_Name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Country_Short_Name"];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ImgUrl"];
        
        
        userId.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"EmailId"];
    }
    
    [[loginBg layer] setBorderColor:[[UIColor clearColor] CGColor]];
    [[loginBg layer] setBorderWidth:2.0];
    [[loginBg layer] setCornerRadius:5];
    [loginBg setClipsToBounds: YES];
    if (appDelegateobj.LoginFlag==FALSE) {
        
        [LoginBtn setTitle:@"Register" forState:0];
        // LoginBtn.frame = CGRectMake(115, 390, 89, 34);
        loginBg.image = [UIImage imageNamed:@"triple_dots.png"];
        BackLbl.hidden = NO;
        Agreelbl.hidden = NO;
        termslbl.hidden = NO;
        andlbl.hidden = NO;
        privacylbl.hidden = NO;
        checkBtn.hidden = NO;
        WebBtn1.hidden = NO;
        WebBtn2.hidden = NO;
        ForgotBtn.hidden = YES;
        QuestionImg.hidden = YES;
        userId.text = @"";
    }
    else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LName"];
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
        
        [LoginBtn setTitle:@"Login" forState:0];
        loginBg.image = [UIImage imageNamed:@"login_logo.png"];
        BackLbl.hidden = YES;
        Agreelbl.hidden = YES;
        termslbl.hidden = YES;
        andlbl.hidden = YES;
        privacylbl.hidden = YES;
        checkBtn.hidden = YES;
        checkFlag = 1;
        WebBtn1.hidden = YES;
        WebBtn2.hidden = YES;
        ForgotBtn.hidden = NO;
        QuestionImg.hidden = NO;
    }
    
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    model = [[currentDevice model] retain];
    deviceVersion = [[currentDevice systemVersion] retain];
    
    appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    name = [[currentDevice name] retain];
    deviceSpecs = [NSString stringWithFormat:@"%@ - %@ - %@ - %@", model, deviceVersion, appVersion, name];
    uuidString = [[self idForDevice] retain];
}

- (NSString *) idForDevice
{
    NSString *result = @"";
    UIDevice *thisDevice = [UIDevice currentDevice];
    if ([thisDevice respondsToSelector: @selector(identifierForVendor)])
    {
        NSUUID *myID = [[UIDevice currentDevice] identifierForVendor];
        result = [myID UUIDString];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        result = [defaults objectForKey: @"appID"];
        if (!result)
        {
            CFUUIDRef myCFUUID = CFUUIDCreate(kCFAllocatorDefault);
            result = ( NSString *) CFUUIDCreateString(kCFAllocatorDefault, myCFUUID);
            [defaults setObject: result forKey: @"appID"];
            [defaults synchronize];
            CFRelease(myCFUUID);
        }
    }
    return result;
}

-(void) RegistrationWebServiceCall {
    
    self.view.userInteractionEnabled = NO;
    [appDelegateobj showActivity:self.view showOrHide:YES];
    
    flag=0;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    NSString *tempStr = @"";
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Sex"] isEqualToString:@"Male"] || [[[NSUserDefaults standardUserDefaults] valueForKey:@"Sex"] isEqualToString:@"male"]) {
        
        tempStr = @"M";
    }
    else {
        tempStr = @"F";
    }
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_registration" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    self.strPassword = password.text;
    
    [request setPostValue:userId.text forKey:@"login_email_id"];
    [request setPostValue:self.strPassword forKey:@"login_password"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"FName"] forKey:@"f_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"LName"] forKey:@"l_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"] forKey:@"dob"];
    //[request setPostValue:tempStr forKey:@"sex"];
    [request setPostValue:@"" forKey:@"street"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"City"] forKey:@"city_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"City_Short_Name"] forKey:@"city_short_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"State"] forKey:@"state_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"State_Short_Name"] forKey:@"state_short_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country"] forKey:@"country_long_name"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country_Short_Name"] forKey:@"country_short_name"];
    //[request setPostValue:appDelegateobj.didSelectChoiceID forKey:@"choice_id"];
    [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"lwfb"];
    
//    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"EmailId"] forKey:@"login_id_3rdparty"];
//    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"type_3rdparty"] forKey:@"type_3rdparty"];
//    [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"FBID"] forKey:@"access_id_3rdparty"];
//    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] forKey:@"access_token_3rdparty"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addData:[[NSUserDefaults standardUserDefaults] valueForKey:@"ImgUrl"] withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@"image_file"];
    
    [request startAsynchronous];
}

-(void)LoginWebServiceCall {
    
    self.view.userInteractionEnabled = NO;
    [appDelegateobj showActivity:self.view showOrHide:YES];
    
    appDelegateobj.LoginFlag=TRUE;
    
    flag=0;
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    #if TARGET_IPHONE_SIMULATOR
        appDelegateobj.dt = @"6f44395d0bbd6afd64bfba8710047bcabafb3a8d1bfa5725e398d0a2bbbe3359";
    #endif
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    
    [[NSUserDefaults standardUserDefaults] setObject:userId.text forKey:@"LogInID"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    //self.strPassword = password.text;
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_login" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:userId.text forKey:@"login_id"];
    [request setPostValue:self.strPassword forKey:@"login_password"];
    [request setPostValue:appName forKey:@"appname"];
    [request setPostValue:appVersion forKey:@"appversion"];
    [request setPostValue:uuidString forKey:@"device_uid"];
    [request setPostValue:appDelegateobj.dt forKey:@"device_token"];
    [request setPostValue:name forKey:@"device_name"];
    [request setPostValue:model forKey:@"device_model"];
    [request setPostValue:deviceVersion forKey:@"device_version"];
    [request setPostValue:@"iOS" forKey:@"device_os"];
    [request setPostValue:push_mode forKey:@"push_mode"];
    [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"lwfb"];
    
    if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
        
        [request setPostValue:[NSString stringWithFormat:@"%f %f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude] forKey:@"gps_coordinate"];
    }
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

-(void)UpdatePasswordWebServiceCall:(NSString *)newPassword isLoginWithFacebook:(BOOL)status
{
    flag=2;
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"do_app_updation" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    
    [request setPostValue:userId.text forKey:@"login_email_id"];
    [request setPostValue:newPassword forKey:@"login_password"];
    [request setPostValue:[NSNumber numberWithBool:status] forKey:@"lwfb"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (flag==0) {
        
        if (appDelegateobj.LoginFlag==FALSE) {
            
            NSString *receivedString = [request responseString];
            
            NSDictionary *responseObject = [receivedString JSONValue];
            NSArray *items = [responseObject objectForKey:@"raws"];
            
            if ([[[items valueForKey:@"status"] valueForKey:@"registration_status"] isEqualToString:@"true"]) {
                
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
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileName"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ProfImage"];
                
                appDelegateobj.LoginFromFBFlag = @"1";
                
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentTab"];
                
                if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
                    
                    [self LoginWebServiceCall];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alert.tag=1001;
                    [alert show];
                    [alert release];
                }
            }
            else {
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
                [self dismissViewControllerAnimated:NO completion:nil];
                
                appDelegateobj.userID = [[items valueForKey:@"dataset"] valueForKey:@"user_id"];
                appDelegateobj.PassKey = [[items valueForKey:@"dataset"] valueForKey:@"pass_key"];
                
                NSString *followingCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"following_count"]];
                NSString *followerCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"follower_count"]];
                [[NSUserDefaults standardUserDefaults] setObject:followingCount forKey:@"following_count"];
                [[NSUserDefaults standardUserDefaults] setObject:followerCount forKey:@"follower_count"];
                
                NSString *reviewCount = [NSString stringWithFormat:@"%@",[[items valueForKey:@"dataset"] valueForKey:@"review_count"]];
                [[NSUserDefaults standardUserDefaults] setObject:reviewCount forKey:@"review_count"];
                
                NSString *avg_rating = [NSString stringWithFormat:@"%.2f",[[[items valueForKey:@"dataset"] valueForKey:@"avg_rating_profile"] floatValue]];
                [[NSUserDefaults standardUserDefaults] setObject:avg_rating forKey:@"profile_rating"];
                
                [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.userID forKey:@"userID"];
                [[NSUserDefaults standardUserDefaults] setObject:appDelegateobj.PassKey forKey:@"PassKey"];
                
                
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
                
                [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentTab"];
                InviteFacebookFriendViewController *inviteFacebookFriendViewController = [[[InviteFacebookFriendViewController alloc] initWithNibName:@"InviteFacebookFriendViewController" bundle:nil] autorelease];
                [appDelegateobj.navigationController pushViewController:inviteFacebookFriendViewController animated:YES];

            } else if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"102"]) {
                // You are already registered with facebook not with normal user
                
                Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
                if (networkStatus == NotReachable) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:userId.text forKey:@"RegularEmailID"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NeedToCompareWithFacebookID"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    appDelegateobj.LoginFromFBFlag = @"0";
                    appDelegateobj.isLoginWithFacebook = YES;
                    appDelegateobj.isSignUpWithFacebook = NO;
                    [appDelegateobj logout];
                    [appDelegateobj openSession];
                }
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
    }
    else if (flag==1) {
        
        NSString *receivedString = [request responseString];
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        
        if ([[[items valueForKey:@"status"] valueForKey:@"update_status"] isEqualToString:@"true"]) {
            
        }
        else {
            
        }
    } else if (flag==2) {
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        NSLog(@"Update Password items  %@",items);
        if ([[[items valueForKey:@"status"] valueForKey:@"update_status"] isEqualToString:@"true"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"currentTab"];
            if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
                [self LoginWebServiceCall];
            }
            else {
                [appDelegateobj showActivity:self.view showOrHide:NO];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=1001;
                [alert show];
                [alert release];
            }
            
        } else {
            [appDelegateobj showActivity:self.view showOrHide:NO];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    self.view.userInteractionEnabled = YES;
    [appDelegateobj showActivity:self.view showOrHide:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	
	// NSString *receivedString = [request responseString];
    self.view.userInteractionEnabled = YES;
    [appDelegateobj showActivity:self.view showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - UIalertview delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==1001) {
        
        exit(1);
    }
}

-(IBAction)BackBtnCall {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)ForgetPassword:(id)sender {
    
    [userId resignFirstResponder];
    [password resignFirstResponder];
    
    [[[[UIApplication sharedApplication]delegate] window] addSubview:ChangeView];
//    [self.view addSubview:ChangeView];
}

-(IBAction)RemoveText:(id)sender {
    
    EmailID.text = @"";
}

-(IBAction)ResetPassword:(id)sender {
    
    [ChangeView removeFromSuperview];
    flag = 1;
    
    if (![EmailID.text length]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please Enter Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if ([self validateEmail2]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please Enter Proper Email Id" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else {
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else {
            
            self.view.userInteractionEnabled = NO;
            [appDelegateobj showActivity:self.view showOrHide:YES];
            
            int number = (arc4random()%99999999)+1;
            NSString *string = [NSString stringWithFormat:@"%i", number];
            
            NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
            [request setPostValue:@"1.0.0" forKey:@"api_version"];
            [request setPostValue:@"forgot_user_password" forKey:@"todoaction"];
            [request setPostValue:@"json" forKey:@"format"];
            
            [request setPostValue:EmailID.text forKey:@"email_id"];
            
            [request setDelegate:self];
            [request setRequestMethod:@"POST"];
            
            [request startAsynchronous];
        }
    }
}

-(IBAction)Clearfield {
    
    userId.text = @"";
}

-(void)hideKeyboard {
    
    [userId resignFirstResponder];
    [password resignFirstResponder];
    [EmailID resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self hideKeyboard];
    [ChangeView removeFromSuperview];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField  {
    
    [self hideKeyboard];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField==userId) {
        
//        const int movementDistance = 120;
//        const float movementDuration = 0.3f;
//        int movement = (YES ? -movementDistance : movementDistance);
//        [UIView beginAnimations: @"anim" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//        [UIView commitAnimations];
        
        // [self animateTextField:YES:120];
    }
    else if (textField==password) {
        
//        const int movementDistance = 180;
//        const float movementDuration = 0.3f;
//        int movement = (YES ? -movementDistance : movementDistance);
//        [UIView beginAnimations: @"anim" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//        [UIView commitAnimations];
        
        // [self animateTextField:YES:180];
    }
    else if (textField==EmailID) {
        
        const int movementDistance = 100;
        const float movementDuration = 0.3f;
        int movement = (YES ? -movementDistance : movementDistance);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        ChangeView.frame = CGRectOffset(ChangeView.frame, 0, movement);
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField==userId) {
        
//        const int movementDistance = 120;
//        const float movementDuration = 0.3f;
//        int movement = (NO ? -movementDistance : movementDistance);
//        [UIView beginAnimations: @"anim" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//        [UIView commitAnimations];
        
        // [self animateTextField:NO:120];
    }
    else if (textField==password) {
        
//        const int movementDistance = 180;
//        const float movementDuration = 0.3f;
//        int movement = (NO ? -movementDistance : movementDistance);
//        [UIView beginAnimations: @"anim" context: nil];
//        [UIView setAnimationBeginsFromCurrentState: YES];
//        [UIView setAnimationDuration: movementDuration];
//        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//        [UIView commitAnimations];
        
        // [self animateTextField:NO:180];
    }
    else if (textField==EmailID) {
        
        const int movementDistance = 100;
        const float movementDuration = 0.3f;
        int movement = (NO ? -movementDistance : movementDistance);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        ChangeView.frame = CGRectOffset(ChangeView.frame, 0, movement);
        [UIView commitAnimations];
    }
}

- (BOOL) validateEmail {
	if(![userId.text length])
		return TRUE;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTestcheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if([emailTestcheck evaluateWithObject:userId.text]) {
		return FALSE;
	}
	else {
		return TRUE;
	}
}

- (BOOL) validateEmail2 {
	if(![EmailID.text length])
		return TRUE;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTestcheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if([emailTestcheck evaluateWithObject:EmailID.text]) {
		return FALSE;
	}
	else {
		return TRUE;
	}
}

- (void)dismissPresentControllerNotification:(NSNotification*)note {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnLoginWithFacebookAction:(id)sender
{    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        appDelegateobj.LoginFromFBFlag = @"0";
        appDelegateobj.isLoginWithFacebook = YES;
        appDelegateobj.isSignUpWithFacebook = NO;
        [appDelegateobj logout];
        [appDelegateobj openSession];
    }
}


-(IBAction)LoginBtnCall:(id)sender {
    
    [self hideKeyboard];
    
    if (![userId.text length]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please Enter The Email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
    }
    else if (![password.text length]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please Enter The Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
    else if (appDelegateobj.LoginFlag==FALSE && [password.text length]<8) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Password Needs to be Eight Characters Long" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
    else {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        } else {
            
            if (checkFlag==1) {
                
                if (locationManager.location.coordinate.latitude!=0.000000 && locationManager.location.coordinate.latitude!=0.000000) {
                    if (appDelegateobj.LoginFlag==FALSE) {
                        
                        [self RegistrationWebServiceCall];
                    }
                    else {
                        self.strPassword = password.text;
                        [self LoginWebServiceCall];
                    }
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Turn On Location Services to Allow \"Spotly\" to Determine Your Location" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alert.tag=1001;
                    [alert show];
                    [alert release];
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"Please agree with terms and privacy policy" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
        }
    }
}

-(void)willPresentAlertView:(UIAlertView *)alertView{
    
    if (alertView.tag==1001) {
        
        UILabel *title = [alertView valueForKey:@"_titleLabel"];
        title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [title setTextColor:[UIColor whiteColor]];
        
        UILabel *body = [alertView valueForKey:@"_bodyTextLabel"];
        body.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [body setTextColor:[UIColor whiteColor]];
    }
}


-(IBAction)WebBtn1Call:(id)sender {
    
    [self.view addSubview:PrivacyView];
    [actind startAnimating];
    
    CGPoint top = CGPointMake(0, 0);
    [webView.scrollView setContentOffset:top animated:YES];
    WebHeadLbl.text = @"Terms";
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lifester-app.com/apps/terms_privacy_policy.html"]]];
    
    // [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lifester.india-web-design.com/terms_privacy_policy.html"]]];
}

-(IBAction)WebBtn2Call:(id)sender {
    
    [self.view addSubview:PrivacyView];
    [actind startAnimating];
    
    CGPoint top = CGPointMake(0, 0);
    [webView.scrollView setContentOffset:top animated:YES];
    WebHeadLbl.text = @"Privacy Policy";
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lifester-app.com/apps/terms_privacy_policy.html"]]];
    
    // [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lifester.india-web-design.com/terms_privacy_policy.html"]]];
}

-(IBAction)CancelWebCall:(id)sender {
    
    [PrivacyView removeFromSuperview];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [actind stopAnimating];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return nil;
}

-(void)LogoutFaceBook {
    
    NSString *client_id = @"184196118428813"; // @"477258729008795";
	
	//alloc and initalize our FbGraph instance
	self.fbGraph = [[[FbGraph alloc] initWithFbClientID:client_id] autorelease];
    
    fbGraph.accessToken = @"";
    
    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache release];
    
    // [self FaceBookWebCall];
}

@end