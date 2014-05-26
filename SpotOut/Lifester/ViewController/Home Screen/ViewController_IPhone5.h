//
//  ViewController_IPhone5.h
//  LifeSter
//
//  Created by App Developer on 24/01/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView_IPhone5.h"
#import "SwipeView.h"
#import "FbGraph.h"
#import "RegistrationView.h"
#import "AppDelegate.h"
#import "UsernameViewController.h"

@class RegistrationView,LoginView_IPhone5,CategoryView_IPhone5;

@interface ViewController_IPhone5 : UIViewController < SwipeViewDelegate, SwipeViewDataSource > {
    
    LoginView_IPhone5 *loginObj;
    IBOutlet UIImageView *frontImg;
    IBOutlet UIImageView *imgEarth;
    IBOutlet UIImageView *imvBackground;
    
    FbGraph *fbGraph;
    NSArray *ImageArr;
    AppDelegate *appDelegateObj;
    RegistrationView *registerObj;
    
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSignUp;
    IBOutlet UIButton *btnFacebookSignUp;
    
    BOOL isLoadFirstTime;
    int slide;
}

@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, strong) NSArray *ImageArr;
@property (nonatomic, strong) IBOutlet SwipeView *swipeView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

-(IBAction)SignUpWithFb:(id)sender;
-(IBAction)LoginBtncall:(id)sender;
-(IBAction)SignUpBtncall:(id)sender;

@end