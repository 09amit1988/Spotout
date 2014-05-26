//
//  WhatsGoingViewController.h
//  Lifester
//
//  Created by YASH  on 27/12/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhatsGoingOnTableCell.h"
#import "AddEventViewController.h"
#import "CustomNaviView.h"
#import "ELCImagePickerController.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EGORefreshTableHeaderView.h"
#import "RefreshTableHeaderView.h"
#import "ODRefreshControl.h"
#import "AddLocationPlaceRating.h"
#import "AddPlaceRatingOverlay.h"
#import <QuartzCore/QuartzCore.h>

@class ExpandableNavigation;

@interface WhatsGoingViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate, CLLocationManagerDelegate, AddLocationPlaceRatingDelegate, RootViewDelegate, UIAlertViewDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet UITableView *tblWhatsGoingOn;
    
    ExpandableNavigation* navigation;
    
    AppDelegate *appDelegate;
    CustomNaviView *naviTitle;
    
    int flag;
    NSInteger lastRow;
    BOOL _reloading;
    NSInteger selectedRow;
    
}
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) BOOL viewAppear;
@property (nonatomic, retain) NSMutableArray *arrShareImage;
@property (retain) ExpandableNavigation* navigation;
@property (nonatomic, retain) NSMutableArray *arrLifeFeed;

- (IBAction)onMenuPressed:(id)sender;
- (IBAction)btnOverlayAction:(id)sender;

- (IBAction)btnSuggestionAction:(id)sender;
- (IBAction)btnAddEventAction:(id)sender;
- (IBAction)btnOfferAction:(id)sender;
- (IBAction)btnPhotoAction:(id)sender;
- (IBAction)btnVideoAction:(id)sender;

@end
