//
//  NewProfileViewController.h
//  Lifester
//
//  Created by YASH  on 01/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNaviView.h"
#import "ProfileViewCell.h"
#import "DYRateView.h"
#import "AppDelegate.h"
#import "RateProfileViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AddLocationPlaceRating.h"
#import "AddPlaceRatingOverlay.h"
#import "SFAnnotation.h"

@interface NewProfileViewController : UIViewController <DYRateViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet UIView *headerTableView;
    IBOutlet UIView *profileView;
    IBOutlet UITableView *tblProfile;
    IBOutlet UIImageView *imgProfileCover;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UIImageView *imgseperateline1;
    IBOutlet UIImageView *imgseperateline2;
    IBOutlet UIImageView *imvLineBottom;

    IBOutlet UIButton *btnFollow;
    
    IBOutlet UILabel *lblProfileName;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblReviewCount;
    IBOutlet UILabel *lblFollowerCount;
    IBOutlet UILabel *lblFollowingCount;
    
    DYRateView *rateview;
    AppDelegate *appDelegate;
    
    BOOL clickIndex;
    int flag;
    NSInteger selectedRow;
}
@property (nonatomic, retain) NSMutableArray *arrLifeFeed;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) User *user;

- (IBAction)btnSetCoverPictureAction:(id)sender;
- (IBAction)btnSetProfilePictureAction:(id)sender;

- (IBAction)btnRateProfileAction:(id)sender;
- (IBAction)btnSendMessageAction:(id)sender;
- (IBAction)btnFollowToggleAction:(id)sender;
- (IBAction)btnInfoAction:(id)sender;

- (IBAction)btnReviewAction:(id)sender;
- (IBAction)btnFollowerAction:(id)sender;
- (IBAction)btnFollowingAction:(id)sender;

@end
