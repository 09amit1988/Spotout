//
//  LocationDetailViewController.h
//  Lifester
//
//  Created by MAC240 on 3/11/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LifeFeedPost.h"
#import "AppDelegate.h"
#import "FSConverter.h"
#import "FSVenue.h"
#import "AsyncImageView.h"
#import "PictureListingOverlay.h"
#import "RootViewDelegate.h"
#import "ASIFormDataRequest.h"
#import "AddPlaceRatingOverlay.h"


@interface LocationDetailViewController : UIViewController <DYRateViewDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, RootViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet UITableView *tblComments;
    IBOutlet UIView *headerView;
    IBOutlet UIView *detailView;
    
    IBOutlet UIImageView *imvLocation;
    IBOutlet UILabel *lblLocationName;
    IBOutlet UILabel *lblLocationType;
    IBOutlet UILabel *lblAddress1;
    IBOutlet UILabel *lblAddress2;
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *lblPictureCount;
    IBOutlet UIImageView *imvLineBottom;
    IBOutlet UIImageView *imvLineCenter;
    IBOutlet UIPageControl *pageControl;
    
    IBOutlet UIButton *btnRatePlace;
    IBOutlet UIImageView *imvRatePlace;
    IBOutlet UIImageView *imvDoneArrow;
    
    NSMutableArray *arrComments;
    AppDelegate *appDelegate;
    int slide;
    int flag;
}
@property (nonatomic, retain) LifeFeedPost *lifeFeedPost;
//@property (nonatomic, retain) FSVenue *venue;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSMutableArray *arrAllPhoto;
@property (nonatomic, retain) NSMutableArray *arrComments;

//+ (CGFloat)annotationPadding;
//+ (CGFloat)calloutHeight;

- (IBAction)btnMapSelectAction:(id)sender;
- (IBAction)btnShowPictureListingOverlayAction:(id)sender;
- (IBAction)btnDirectionAction:(id)sender;
- (IBAction)btnInviteFriendAction:(id)sender;
- (IBAction)btnRatePlaceAction:(id)sender;

@end
