//
//  SearchViewController.h
//  Lifester
//
//  Created by MAC240 on 4/10/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "FSVenue.h"
#import "MFSideMenu.h"
#import "OHAttributedLabel.h"

enum SearchType {
	kSimpleSearch = 1,
	kUserSearch,
    kTagSearch
};



@interface SearchViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet UIView *searchView;
    IBOutlet UIView *resultView;
    IBOutlet UIView *noResultFoundView;
    IBOutlet UITableView *tblResult;
    IBOutlet UISearchBar *searchBar;
    
    IBOutlet UITextField *txtSearch;
    UIButton *btnLocationCity;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIButton *btnBack;
    IBOutlet UIImageView *imvSearchIcon;
    IBOutlet UILabel *lblMessage;
    
    AppDelegate *appDelegate;
    NSInteger pageNo;
    NSInteger searchType;
    
    NSInteger selectedIndex;
    int flag;
}
@property (nonatomic, retain) IBOutlet UIButton *btnLocationCity;
@property (nonatomic, retain) FSVenue *venue;
@property (nonatomic, retain) NSMutableArray *arrSearchResult;

- (IBAction)btnLocationCityAction:(id)sender;
- (IBAction)btnSearchAction:(id)sender;
- (IBAction)btnBackAction:(id)sender;



@end
