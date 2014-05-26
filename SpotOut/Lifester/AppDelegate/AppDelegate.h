//
//  AppDelegate.h
//  Lifester
//
//  Created by App Developer on 24/01/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TJSpinner.h"
#import "CRNavigationController.h"
#import "IconDownloader.h"
#import "WhatsGoingViewController.h"
#import "MenuView.h"
#import "Foursquare2.h"
#import "User.h"
#import "MFSideMenuContainerViewController.h"
#import "CityMenuView.h"

@class MenuView;
@class CityMenuView;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, FBFriendPickerDelegate, FBWebDialogsDelegate, UIAlertViewDelegate, MenuViewDelegate, UITabBarControllerDelegate> {
    
    BOOL LoginFlag;
    int flag;
    NSString *dt,*userID,*PassKey,*choiceID,*hangOutID,*FeedID,*WallID,*SelectedChoiceID,*friendReqStr,*NotificationStr,*invitationStr,*newnotification,*friend_ID,*NewIncomeChatID,*NewChatStr,*LocationLikeCount;
    NSMutableArray *FriendArray,*selectedArr,*SelectedLocArr;
    int new_feedcount,new_chatcount;
    AVAudioPlayer *myAudioPlayer;
    
    int badgenumber;
    NSString *uuidString;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    
    /*+variable added by amit on 17/8/2013 to show guideline for unattended screen*/
    UIScrollView *scrollView;
    
    MenuView *menuView;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) AVAudioPlayer *myAudioPlayer;

@property (nonatomic,retain) NSString *dt,*userID,*PassKey;
@property (nonatomic) BOOL LoginFlag,shouldRotate;
@property (nonatomic) int flag;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) CRNavigationController *navigationController;

@property (nonatomic, retain) NSString *EmailAddress,*fNameStr,*lNameStr,*SexStr,*DobStr,*LocStr,*FBID,*accessToken;
@property (nonatomic, retain) NSString *imgUrl,*LoginFromFBFlag;

@property (nonatomic, assign) BOOL isLoginWithFacebook;
@property (nonatomic, assign) BOOL isSignUpWithFacebook;
@property (nonatomic, retain) NSMutableDictionary *dictFacebook;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

@property (retain, nonatomic) NSString *alertPassowrd;
@property (nonatomic, assign) BOOL IsNewFacebookRegistration;
@property (nonatomic, assign) BOOL isWallAddedNewPost;

@property (nonatomic, assign) NSInteger previousTabIndex;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) CityMenuView *cityMenuView;
// By Nikunj


- (void)openSession;
- (void)logout;
- (void)postUpdate;

- (NSString *) idForDevice;
- (void)showActivity:(UIView*)view showOrHide:(BOOL)showOrHide;
- (void)showActivityOnWindow:(UIWindow*)view showOrHide:(BOOL)showOrHide;

- (void)initializeTabBarController;
- (void)removeCityMenuOverlay;

// this will appear as the title in the navigation bar
+ (UILabel *)titleLabelWithTitle:(NSString *)title;
- (UIView *)searchViewInNavigation;

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error;
- (void)fbResync;

- (void)addMenuViewControllerOnWindow:(UIViewController*)viewContrller;
- (NSString*)convertPostTimeToString:(NSString*)time;


@end
