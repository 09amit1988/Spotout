//
//  Settings_IPhone5.m
//  Lifester
//
//  Created by App Developer on 19/03/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "Settings_IPhone5.h"
#import "JSON.h"
#import "FbGraphFile.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"


@interface Settings_IPhone5 ()

@end

@implementation Settings_IPhone5

@synthesize fbGraph,SoundTable,player,lastIndexPath;

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
    appDelegateObj.shouldRotate = YES;
    return UIInterfaceOrientationMaskAll;
}

-(IBAction)ChangePassword:(id)sender {
    
//    ChangePassword_IPhone5 *PasswordObj = [[ChangePassword_IPhone5 alloc] initWithNibName:@"ChangePassword_IPhone5" bundle:nil];
//    [self.navigationController pushViewController:PasswordObj animated:YES];
//    [PasswordObj release];
}

-(IBAction)AboutBtnCall:(id)sender {
    
//    aboutObj = [[About_Us_IPhone5 alloc] initWithNibName:@"About_Us_IPhone5" bundle:nil];
//    [self presentViewController:aboutObj animated:YES completion:nil];
//    [aboutObj release];
}

-(IBAction)FaceBookBtnTapped:(id)sender {
    
    if([[facebookBtn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"facebook_disconnect.png"]]) {
    // if ([fbGraph.accessToken length]) {
        
        [facebookBtn setImage:[UIImage imageNamed:@"facebook_connect.png"] forState:0];
        [self removeWebService];
    }
    else {
        [facebookBtn setImage:[UIImage imageNamed:@"facebook_disconnect.png"] forState:0];
        appDelegateObj.LoginFromFBFlag = @"1";
        
        [appDelegateObj openSession];
        
//        fbGraph.accessToken = @"";
//        
//        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
//            [cookies deleteCookie:cookie];
//        }
//        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
//        [NSURLCache setSharedURLCache:sharedCache];
//        [sharedCache release];
//        
//        [self FaceBookBtncall];
    }
}

//-(void)FaceBookBtncall {
//    
//    /*Facebook Application ID*/
//	NSString *client_id = @"184196118428813"; // @"477258729008795";
//	
//	//alloc and initalize our FbGraph instance
//	self.fbGraph = [[[FbGraph alloc] initWithFbClientID:client_id] autorelease];
//	
//	//begin the authentication process.....
//	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
//}
//
//-(void)GetmeInfo {
//    
//    FbGraphResponse *fb_graph_response = [fbGraph doGraphGet:@"me" withGetVars:nil];
//    
//    NSArray *items = [fb_graph_response.htmlResponse JSONValue];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[items valueForKey:@"id"] forKey:@"FBID"];
//    [[NSUserDefaults standardUserDefaults] setObject:[items valueForKey:@"email"] forKey:@"EmailId"];
//}
//
//- (void)fbGraphCallback:(id)sender {
//    	
//	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
//        
//		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
//		
//	} else {
//        [[NSUserDefaults standardUserDefaults] setObject:fbGraph.accessToken forKey:@"accessToken"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        [self GetmeInfo];
//    }
//    [self addWebService];
//}

-(void)addWebService {
    
    flag = 2;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else {
        
        self.view.userInteractionEnabled = NO;
        int number = (arc4random()%99999999)+1;
        NSString *string = [NSString stringWithFormat:@"%i", number];
        
        NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setPostValue:@"1.0.0" forKey:@"api_version"];
        [request setPostValue:@"connect_extended_login" forKey:@"todoaction"];
        [request setPostValue:@"json" forKey:@"format"];
        
        [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
        [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"EmailId"] forKey:@"login_id_3rdparty"];
        [request setPostValue:@"F" forKey:@"type_3rdparty"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"FBID"] forKey:@"access_id_3rdparty"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"] forKey:@"access_token_3rdparty"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
    }
}

-(void)removeWebService {
    
    flag = 3;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        
        self.view.userInteractionEnabled = NO;
        int number = (arc4random()%99999999)+1;
        NSString *string = [NSString stringWithFormat:@"%i", number];
        
        NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setPostValue:@"1.0.0" forKey:@"api_version"];
        [request setPostValue:@"disconnect_extended_login" forKey:@"todoaction"];
        [request setPostValue:@"json" forKey:@"format"];
        
        [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
        [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
        [request setPostValue:@"F" forKey:@"type_3rdparty"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    scroller.contentSize=CGSizeMake(320,990);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [SubView removeFromSuperview];
}

-(IBAction)SoundBtnCall:(id)sender {
    
    [self.view addSubview:SubView];
    [self.SoundTable reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	//self.view.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:229/255.0f alpha:1];
    backgroundView.backgroundColor = VIEW_COLOR;
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    BtnTag = -1;
    
    Head1.textColor = Head2.textColor = Head3.textColor = Head4.textColor = [UIColor colorWithRed:0/255.0f green:73/255.0f blue:99/255.0f alpha:1];
    FacebookLbl.textColor = BadgeLbl.textColor = AlertLbl.textColor = PushSoundLbl.textColor = SoundLbl.textColor = PostLbl.textColor = LikesLbl.textColor = InvitaionsLbl.textColor = FrReqLbl.textColor = ChatLbl.textColor = [UIColor colorWithRed:3/255.0f green:82/255.0f blue:110/255.0f alpha:1];
    
    SoundNameLbl.text = @"Select";
    
    [SubView removeFromSuperview];
    SoundNameArr = [[NSArray alloc] initWithObjects:@"Cricket",@"Flute",@"Forest Birds",@"Glass Bells",@"Glass Wind Chimes",@"Wind Chimes",@"Woodpeckers",nil];
    
    appDelegateObj = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
//    TabObj = [[TabView alloc] initWithNibName:@"TabView" bundle:nil];
//    TabObj.view.frame = CGRectMake(0, 0, 320, 59);
//    if ([appDelegateObj.choiceID intValue]==0) {
//        [TabObj.intensionBtn setImage:[UIImage imageNamed:@"intention_icon.png"] forState:UIControlStateNormal];
//    }
//    else {
//        [TabObj.intensionBtn setImage:[UIImage imageNamed:@"intention_new_icon.png"] forState:UIControlStateNormal];
//    }
//    [TabObj.LifefeedBtn setImage:[UIImage imageNamed:@"lifefeed_icon.png"] forState:UIControlStateNormal];
//    [TabObj.jabberBtn setImage:[UIImage imageNamed:@"jabber_icon.png"] forState:UIControlStateNormal];
//    if ([appDelegateObj.hangOutID intValue]==0) {
//        
//        [TabObj.locationBtn setImage:[UIImage imageNamed:@"locations_icon.png"] forState:UIControlStateNormal];
//    }
//    else {
//        [TabObj.locationBtn setImage:[UIImage imageNamed:@"locations_new_icon.png"] forState:UIControlStateNormal];
//    }
//    [TabObj.profileBtn setImage:[UIImage imageNamed:@"profile_icon_ac.png"] forState:UIControlStateNormal];
//    [self.view addSubview:TabObj.view];
    
    
    flag = 1;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        
        self.view.userInteractionEnabled = NO;
        int number = (arc4random()%99999999)+1;
        NSString *string = [NSString stringWithFormat:@"%i", number];
        
        NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
        //[self GetUserPushSettings];
        //return;
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setPostValue:@"1.0.0" forKey:@"api_version"];
        [request setPostValue:@"get_user_settings" forKey:@"todoaction"];
        [request setPostValue:@"json" forKey:@"format"];
        
        [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
        [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
    }
}

-(void)GetUserPushSettings {
    
    flag = 4;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        
        self.view.userInteractionEnabled = NO;
        int number = (arc4random()%99999999)+1;
        NSString *string = [NSString stringWithFormat:@"%i", number];
        
        NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setPostValue:@"1.0.0" forKey:@"api_version"];
        [request setPostValue:@"get_user_push_settings" forKey:@"todoaction"];
        [request setPostValue:@"json" forKey:@"format"];
        
        [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
        [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    fbGraph.flag=0;
    [self supportedInterfaceOrientations];
    [self shouldAutorotate];
    
    NSLog(@"%@", [self.navigationController viewControllers]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)BackBtnCall:(id)sender {
    
    //[self.navigationController popViewControllerAnimated:YES];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(IBAction)LogoutBtnCall:(id)sender {
    
    flag = 0;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        
        self.view.userInteractionEnabled = NO;
        int number = (arc4random()%99999999)+1;
        NSString *string = [NSString stringWithFormat:@"%i", number];
        
        NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setPostValue:@"1.0.0" forKey:@"api_version"];
        [request setPostValue:@"do_app_logout" forKey:@"todoaction"];
        [request setPostValue:@"json" forKey:@"format"];
        
        [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
        [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (flag==0) {
        
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        NSLog(@"items %@",items);
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PassKey"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"choiceID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hangOutID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profileName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        appDelegateObj.isLoginWithFacebook = NO;
        appDelegateObj.isSignUpWithFacebook = NO;
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
    else if (flag==1) {
        
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        if ([[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
            
            if ([[[items valueForKey:@"status"] valueForKey:@"fetch_status"] isEqualToString:@"true"]) {
                
                if ([items valueForKey:@"extended_login_dataset"] == (id)[NSNull null]) {
                    
                    [facebookBtn setImage:[UIImage imageNamed:@"facebook_connect.png"] forState:0];
                }
                else {
                    
                    if ([[[[items valueForKey:@"extended_login_dataset"] objectAtIndex:0] valueForKey:@"access_token_3rdparty"] length]!=0) {
                        
                        [facebookBtn setImage:[UIImage imageNamed:@"facebook_disconnect.png"] forState:0];
                    }
                    else {
                        [facebookBtn setImage:[UIImage imageNamed:@"facebook_connect.png"] forState:0];
                    }
                }
                [self GetUserPushSettings];
            }
            else {
                
            }
        }
        else {
            //[self.navigationController popToRootViewControllerAnimated:YES];
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        [scroller addSubview:facebookBtn];
    }
    else if (flag==2) {
        
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        NSLog(@"items %@",items);
    }
    else if (flag==3) {
        
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        NSLog(@"items %@",items);
    }
    else if (flag==4) {
        
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        if ([[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
            
            if ([[[items valueForKey:@"status"] valueForKey:@"fetch_status"] isEqualToString:@"true"]) {
                
                push_badge = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_badge"] intValue];
                push_alert = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_alert"] intValue];
                push_sound = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_sound"] intValue];
                push_posts = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_posts"] intValue];
                push_likes = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_likes"] intValue];
                push_invitations = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_invitations"] intValue];
                push_requests = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_requests"] intValue];
                push_chats = [[[items valueForKey:@"push_settings_dataset"] valueForKey:@"push_chats"] intValue];
                
                if (push_badge==1) {
                    
                    [BadgeBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [BadgeBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                if (push_alert==1) {
                    
                    [AlertBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [AlertBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                if (push_sound==1) {
                    
                    [PushSoundBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [PushSoundBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                if (push_posts==1) {
                    
                    [PostBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [PostBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                if (push_likes==1) {
                    
                    [LikesBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [LikesBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                if (push_invitations==1) {
                    
                    [InvitationBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [InvitationBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                if (push_requests==1) {
                    
                    [RequestBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [RequestBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                if (push_chats==1) {
                    
                    [ChatBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
                }
                else {
                    [ChatBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
                }
                
                
                
                if ([[NSString stringWithFormat:@"%@",[[items valueForKey:@"push_settings_dataset"] valueForKey:@"sound_name"]] isEqualToString:@"<null>"]) {
                    
                    SoundNameLbl.text = @"Select";
                    sound_name = [[NSString stringWithFormat:@""] copy];
                }
                else {
                    sound_name = [[NSString stringWithFormat:@"%@",[[items valueForKey:@"push_settings_dataset"] valueForKey:@"sound_name"]] copy];
                    
                    NSString *TempStr = [[NSString stringWithFormat:@"%@",[[items valueForKey:@"push_settings_dataset"] valueForKey:@"sound_name"]] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                    
                    for (int f = 0; f < [SoundNameArr count]; f++) {
                        NSString * stringFromArray = [SoundNameArr objectAtIndex:f];
                        if ([[TempStr capitalizedString] isEqualToString:stringFromArray]) {
                            
                            NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:f inSection:0];
                            self.lastIndexPath = myIndexPath;
                            // [myIndexPath release];
                            break;
                        }
                    }
                    
                    SoundNameLbl.text = [TempStr capitalizedString];
                }
                [self.SoundTable reloadData];
            }
            else {
                
            }
        }
        else {
            //[self.navigationController popToRootViewControllerAnimated:YES];
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }
    else if (flag==5) {
        
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        if ([[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
            
            if ([[[items valueForKey:@"status"] valueForKey:@"update_status"] isEqualToString:@"true"]) {
                
            }
            else {
                
            }
        }
        else {
            //[self.navigationController popToRootViewControllerAnimated:YES];
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }
    else if (flag==6) {
        
        NSString *receivedString = [request responseString];
        
        NSDictionary *responseObject = [receivedString JSONValue];
        NSArray *items = [responseObject objectForKey:@"raws"];
        
        if ([[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
            
            if ([[[items valueForKey:@"status"] valueForKey:@"update_status"] isEqualToString:@"true"]) {
                
            }
            else {
                
            }
        }
        else {
            //[self.navigationController popToRootViewControllerAnimated:YES];
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }
    self.view.userInteractionEnabled = YES;
}

-(IBAction)BadgeBtnCall:(id)sender {
    
    if (push_badge==0) {
        
        push_badge = 1;
        
        [BadgeBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_badge = 0;
        [BadgeBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)AlertBtnCall:(id)sender {
    
    if (push_alert==0) {
        
        push_alert = 1;
        [AlertBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_alert = 0;
        [AlertBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)PushSountBtnCall:(id)sender {
    
    if (push_sound==0) {
        
        push_sound = 1;
        [PushSoundBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_sound = 0;
        [PushSoundBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)PostBtnCall:(id)sender {
    
    if (push_posts==0) {
        
        push_posts = 1;
        [PostBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_posts = 0;
        [PostBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)LikesBtnCall:(id)sender {
    
    if (push_likes==0) {
        
        push_likes= 1;
        [LikesBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_likes = 0;
        [LikesBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)InvitationBtnCall:(id)sender {
    
    if (push_invitations==0) {
        
        push_invitations = 1;
        [InvitationBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_invitations = 0;
        [InvitationBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)RequestBtnCall:(id)sender {
    
    if (push_requests==0) {
        
        push_requests = 1;
        [RequestBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_requests = 0;
        [RequestBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)ChatBtnCall:(id)sender {
    
    if (push_chats==0) {
        
        push_chats = 1;
        [ChatBtn setBackgroundImage:[UIImage imageNamed:@"notification_on_bttn.png"] forState:UIControlStateNormal];
    }
    else {
        push_chats = 0;
        [ChatBtn setBackgroundImage:[UIImage imageNamed:@"notification_off_bttn.png"] forState:UIControlStateNormal];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	
	// NSString *receivedString = [request responseString];
    self.view.userInteractionEnabled = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [SoundNameArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LazyTableCell";
    
	UITableViewCell *cell = [SoundTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    UILabel *NameLbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 13, 190, 18)];
    NameLbl.backgroundColor = [UIColor clearColor];
    NameLbl.tag= indexPath.row + 100;
    NameLbl.textColor = [UIColor colorWithRed:3/255.0f green:82/255.0f blue:110/255.0f alpha:1];
    NameLbl.text = [SoundNameArr objectAtIndex:indexPath.row];
    [cell.contentView addSubview:NameLbl];
    [NameLbl release];
    
    PlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 2, 40, 40)];
    PlayBtn.tag = indexPath.row + 200;
    [PlayBtn setImage:[UIImage imageNamed:@"play_bttn.png"] forState:UIControlStateNormal];
    [PlayBtn addTarget:self action:@selector(PlayBtnCall:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:PlayBtn];
    [PlayBtn release];
    
    
    UIImageView *imageView1 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]] autorelease];
    imageView1.frame = CGRectMake(5, 10, 20, 20);
    
    
    UIImageView *imageView2 = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selection_btn@2x.png"]] autorelease];
    imageView2.frame = CGRectMake(5, 10, 20, 20);
    
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        [cell.contentView addSubview:imageView2];
        // cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        [cell.contentView addSubview:imageView1];
        // cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lastIndexPath = indexPath;
    BtnTag = indexPath.row;
    [self.SoundTable reloadData];
    
}

-(IBAction)Save1BtnCall:(id)sender {
    
    flag = 5;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        
        self.view.userInteractionEnabled = NO;
        int number = (arc4random()%99999999)+1;
        NSString *string = [NSString stringWithFormat:@"%i", number];
        
        NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setPostValue:@"1.0.0" forKey:@"api_version"];
        [request setPostValue:@"set_user_generic_push_settings" forKey:@"todoaction"];
        [request setPostValue:@"json" forKey:@"format"];
        
        [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
        [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_badge] forKey:@"push_badge"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_alert] forKey:@"push_alert"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_sound] forKey:@"push_sound"];
        [request setPostValue:sound_name forKey:@"sound_name"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
    }
}

-(IBAction)Save2BtnCall:(id)sender {
    
    flag = 6;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        
        self.view.userInteractionEnabled = NO;
        int number = (arc4random()%99999999)+1;
        NSString *string = [NSString stringWithFormat:@"%i", number];
        
        NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
        [request setPostValue:@"1.0.0" forKey:@"api_version"];
        [request setPostValue:@"set_user_notification_push_settings" forKey:@"todoaction"];
        [request setPostValue:@"json" forKey:@"format"];
        
        [request setPostValue:appDelegateObj.userID forKey:@"user_id"];
        [request setPostValue:appDelegateObj.PassKey forKey:@"pass_key"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_posts] forKey:@"push_posts"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_likes] forKey:@"push_likes"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_invitations] forKey:@"push_invitations"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_requests] forKey:@"push_requests"];
        [request setPostValue:[NSString stringWithFormat:@"%d",push_chats] forKey:@"push_chats"];
        
        [request setDelegate:self];
        [request setRequestMethod:@"POST"];
        
        [request startAsynchronous];
    }
    
}

-(IBAction)SelectBtnCall:(id)sender {
    
    if (BtnTag==-1) {
        SoundNameLbl.text = @"Select";
        sound_name = @"";
    }
    else {
        SoundNameLbl.text = [SoundNameArr objectAtIndex:BtnTag];
        
        switch (BtnTag) {
            case 0:
                sound_name = @"cricket";
                break;
                
            case 1:
                sound_name = @"flute";
                break;
                
            case 2:
                sound_name = @"forest_birds";
                break;
                
            case 3:
                sound_name = @"glass_bells";
                break;
                
            case 4:
                sound_name = @"glass_wind_chimes";
                break;
                
            case 5:
                sound_name = @"wind_chimes";
                break;
                
            case 6:
                sound_name = @"woodpeckers";
                break;
                
            default:
                break;
        }
    }
    [SubView removeFromSuperview];
}

-(void)PlayBtnCall:(id)sender {
    
    UIButton *button = (UIButton *) sender;
        
    [button setImage:[UIImage imageNamed:@"pause_bttn.png"] forState:UIControlStateNormal];
    
    int BtnTag2 = [sender tag] - 199;
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",BtnTag2] ofType:@"mp3"];
    
    NSError *error;
    player =[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath] error:&error];
    
    if (error) {
        // NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
    }
    else {
        [player setDelegate:self];
        // [player setNumberOfLoops:3]; //just to make sure it is playing my file several times
        player.volume = 1.0f;
        
        if([player prepareToPlay]) { //It is always ready to play
            // NSLog(@"It is ready to play");
        }
        else {
            // NSLog(@"It is NOT ready to play ");
        }
        
        if([player play]) { //It is always playing
            
            self.view.userInteractionEnabled = NO;
            // NSLog(@"It should be playing");
        }
        else {
            // NSLog(@"An error happened");
        }
    }
    // [button setImage:[UIImage imageNamed:@"play_bttn.png"] forState:UIControlStateNormal];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag2 {
    
    if (flag2==YES) {
        
        self.view.userInteractionEnabled = YES;
        [self.SoundTable reloadData];
    }
}

@end
