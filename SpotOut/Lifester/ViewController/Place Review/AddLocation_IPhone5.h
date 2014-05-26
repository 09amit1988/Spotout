//
//  AddLocation_IPhone5.h
//  Lifester
//
//  Created by App Developer on 28/02/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"
#import "AppDelegate.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "FSVenue.h"
#import "SuggestPlaceViewController.h"
#import "OfferReviewViewController.h"
#import "AddEventViewController.h"
#import "PhotoReviewViewController.h"
#import "SearchViewController.h"
#import "ActivityViewController.h"

enum AddLocationParentView {
	kSuggestPlaceView = 1,
	kEventView,
    kOfferView,
    kPhotoView,
    kActivityView
};


#define kGOOGLE_API_KEY @"AIzaSyD6CADsMuigQsBlD1X1vXIPuRQoxuhw3rQ"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@class AppDelegate;
@class PhotoReviewViewController;

@interface AddLocation_IPhone5 : UIViewController < MKMapViewDelegate, CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate >
{
    IBOutlet UIView *backgroundView;
    CLLocationManager *locationManager;
    IBOutlet UITextField *searchBar;
    IBOutlet UIImageView *imvSearchIcon;
    IBOutlet UIView *NoLocationView;
    IBOutlet UIButton *btnBackCity;
    CLLocationCoordinate2D currentCentre;
    
    CLLocation *currentLocation;
    int currenDist;
    BOOL firstLaunch;
    IBOutlet UITableView *LocTable;
    IBOutlet UIButton *btnFindCity;
    NSMutableArray *FetchArr,*tempResultArray;
    AppDelegate *appDelegateObj;
    
    NSString *pagetoken,*pagetoken1;
    NSInteger iParentView;
    NSInteger pendingOperation;
    BOOL isSearchCity;
}
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *footerActivityIndicator;
@property (nonatomic, retain) IBOutlet UITableView *LocTable;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *nearbyVenues;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) NSInteger iParentView;
@property (nonatomic, retain) FSVenue *cityVenue;
@property (nonatomic, assign) BOOL isComingFromSearchSection;

@property (nonatomic, retain) OfferReviewViewController *objOfferView;
@property (nonatomic, retain) AddEventViewController *objAddEvent;
@property (nonatomic, retain) PhotoReviewViewController *objPhotoView;
@property (nonatomic, retain) SearchViewController *objSearchView;
@property (nonatomic, retain) ActivityViewController *objActivityView;

- (IBAction)btnCitySearchPressed:(id)sender;
- (IBAction)btnBackCityAction:(id)sender;

@end
