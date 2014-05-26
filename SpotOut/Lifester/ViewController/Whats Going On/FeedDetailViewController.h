//
//  FeedDetailViewController.h
//  Lifester
//
//  Created by MAC240 on 4/10/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LifeFeedPost.h"
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
#import "AddPlaceRatingOverlay.h"
#import <MapKit/MapKit.h>
#import "SFAnnotation.h"

@interface FeedDetailViewController : UIViewController <CLLocationManagerDelegate, RootViewDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *profileView;
    IBOutlet UIView *shareImageView;
    IBOutlet UIView *postDescView;
    IBOutlet UIView *locationView;
    IBOutlet UIView *ticketView;
    IBOutlet UIView *inviteFriendView;
    IBOutlet UIView *likeCommentView;
    
    IBOutlet UIImageView *imvLine1;
    
    IBOutlet UIImageView *imvProfileUser;
    IBOutlet UILabel *lblProfileName;
    IBOutlet UIImageView *imvFeedPost;
    IBOutlet UIButton *btnFeedPostImage;
    IBOutlet UILabel *lblDistanceFromLocation;
    IBOutlet UILabel *lblPictureCount;
        
    IBOutlet UIImageView *imvFeedType;
    IBOutlet UILabel *lblPostTitle;
    IBOutlet UILabel *lblPostPrice;
    IBOutlet UILabel *lblPostLocationType;
    IBOutlet MKMapView *mapview;
    
    IBOutlet UILabel *lblTagNames;
    IBOutlet UILabel *lblDescription;
    IBOutlet UIButton *btnLink;
    IBOutlet UIButton *btnBookmark;
    
    IBOutlet UILabel *lblLocationName;
    IBOutlet UILabel *lblCategoryType;
    IBOutlet UILabel *lblLocationAdress;
    IBOutlet UILabel *lblLocationCity;
    
    IBOutlet UILabel *lblFeedPostTime;
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UILabel *lblShareCount;
    
    IBOutlet UIButton *btnLikeFeed;
    
    int flag;
    DYRateView *placeRateView;
    AppDelegate *appDelegate;
}
@property (nonatomic, retain) LifeFeedPost *feedPost;
@property (nonatomic, assign) NSInteger lifeFeedID;

@property (nonatomic, retain) CLLocation *currentLocation;

- (IBAction)btnLikeAction:(id)sender;
- (IBAction)btnCommentAction:(id)sender;
- (IBAction)btnShareAction:(id)sender;
- (IBAction)btnRePostAction:(id)sender;

@end
