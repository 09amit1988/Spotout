//
//  LoginView.h
//  Lifester
//
//  Created by App Developer on 24/01/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FbGraph.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "InviteFacebookFriendViewController.h"
#import "WhatsGoingViewController.h"

@class MenuViewController;
@class WhatsGoingViewController;


@interface LoginView : UIViewController < UITextFieldDelegate, UIAlertViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIWebViewDelegate, UIScrollViewDelegate > {
    
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    IBOutlet UITextField *userId,*password;
    IBOutlet UIImageView *loginBg;
    
    WhatsGoingViewController *homeObj;
    AppDelegate *appDelegateobj;
    IBOutlet UIButton *LoginBtn;
    FbGraph *fbGraph;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    NSString *model,*deviceVersion,*deviceSpecs,*uuidString,*appVersion,*name;
    BOOL canRotate;
    IBOutlet UIView *backgroundView;
    IBOutlet UIView *backgroundView1;
    
    IBOutlet UILabel *BackLbl,*Agreelbl,*termslbl,*andlbl,*privacylbl,*WebHeadLbl;
    IBOutlet UIButton *checkBtn,*WebBtn1,*WebBtn2;
    IBOutlet UIView *PrivacyView;
    IBOutlet UIWebView *webView;
    int checkFlag,flag;
    IBOutlet UIActivityIndicatorView *actind;
    
    IBOutlet UIImageView *QuestionImg;
    IBOutlet UIButton *ForgotBtn;
    IBOutlet UIView *ChangeView;
    IBOutlet UITextField *EmailID;
    IBOutlet UILabel *SubViewHead;
}
@property(nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSString *strPassword;

-(IBAction)ForgetPassword:(id)sender;
- (IBAction)btnLoginWithFacebookAction:(id)sender;
-(IBAction)Clearfield;
-(IBAction)LoginBtnCall:(id)sender;
-(void)hideKeyboard;
-(IBAction)BackBtnCall;
- (BOOL) validateEmail;

@end
