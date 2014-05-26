//
//  RateProfileViewController.h
//  Lifester
//
//  Created by MAC205 on 13/02/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RateProfileCell.h"
#import "SSTextView.h"
#import "DYRateView.h"
#import "AsyncImageView.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "ReviewComment.h"
#import "User.h"

@interface RateProfileViewController : UIViewController<UITextViewDelegate,DYRateViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *tblComment;
    IBOutlet UIToolbar * toolBar;
    IBOutlet UIView *headerTableView;
    IBOutlet UIView *commentView;
    IBOutlet SSTextView *txtAddComment;
    IBOutlet UIView *addCommentView;
    IBOutlet UIButton *btnDone;
    IBOutlet UIImageView *imvDivideLine;
    
    IBOutlet UIImageView *imvCommentProfile;
    IBOutlet UILabel *lblProfileName;
    DYRateView *profileRateView;
    IBOutlet UILabel *lblOwnComment;
    IBOutlet UIButton *btnMore;
    IBOutlet UIImageView *imvClockIcon;
    IBOutlet UILabel *lblTimeDifference;
    
    IBOutlet UISlider *rateSlider;
    DYRateView *rateview;
    
    BOOL isMoreExpanded;
    int flag;
    float lastContentSize;
    AppDelegate *appDelegate;
}
@property (nonatomic, assign) BOOL isOtherUser;
@property (nonatomic, retain) NSNumber *profileID;
@property (nonatomic, retain) User *user;

@property (nonatomic, assign) BOOL isRatingAdded;
@property (nonatomic, retain) NSMutableArray *arrReviews;
@property (nonatomic, retain) ReviewComment *reviewPersonal;

- (IBAction)sliderValueChangeAction:(id)sender;
- (IBAction)btnDoneHideKeyboardAction:(id)sender;
- (IBAction)btnEditRateProfileRatingAction:(id)sender;
- (IBAction)btnSaveProfileRatingAction:(id)sender;

- (IBAction)btnMoreToggleAction:(id)sender;

@end
