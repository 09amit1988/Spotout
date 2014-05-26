//
//  OfferReviewViewController.h
//  Lifester
//
//  Created by MAC240 on 1/13/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewDelegate.h"
#import "EventTimeSelectionOverlay.h"
#import "ELCImagePickerController.h"
#import "IconDownloader.h"
#import "FSVenue.h"
#import "CategorySelectionOverlay.h"
#import "SSTextView.h"
#import "AppDelegate.h"


@interface OfferReviewViewController : UIViewController <UITextFieldDelegate, RootViewDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, ELCImagePickerControllerDelegate, UITextViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *offerDescView;
    IBOutlet UIView *titleView;
    IBOutlet UIView *offerSectionView;
    
    IBOutlet UIView *locationSection;
    IBOutlet UIView *timeSection;
    IBOutlet UIView *sharePictureSection;
    IBOutlet UIView *priceSection;
    IBOutlet UIView *linkSection;
    IBOutlet UIView *tagSection;
    
    IBOutlet UIImageView *imageLocation;
    IBOutlet UIButton *btnClearLink;
    IBOutlet UIButton *btnClearTime;
    IBOutlet UIButton *btnClearCategory;
    IBOutlet UIButton *btnClearPrice;
    IBOutlet UIImageView *imvLine1;
    IBOutlet UIImageView *imvLine2;
    IBOutlet UIImageView *imvLine3;
    IBOutlet UIImageView *imvLine4;
    IBOutlet UIImageView *imvLine5;
    
    IBOutlet UITextField *txtOfferTitle;
    IBOutlet UILabel *lblWorkingTIme;
    IBOutlet UILabel *lblCategory;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblLink;
    IBOutlet UILabel *lblSharingPicture;
    IBOutlet UILabel *lblPrice;

    IBOutlet SSTextView *txtViewThoats;
    IBOutlet UIToolbar * toolBar;
    
    IBOutlet UIImageView *imvPriceWhiteBox;
    IBOutlet UITextField *txtPrice;
    IBOutlet UIButton *btnCurrency;
    IBOutlet UIPickerView* picker;
    IBOutlet UIView *pickerView;
    IBOutlet UIToolbar *pickerToolBar;
    IBOutlet UIView *viewDoneButton;
    IBOutlet UIView *priceOverlay;
    
    float lastContentSize;
    BOOL overlayTag;
    NSMutableArray *arrCategoryId;
    NSString *startEventTime;
    NSString *endEventTime;
    
    AppDelegate *appDelegate;
}
@property (nonatomic, retain) NSMutableArray *arrShareImage;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScollView;
@property (nonatomic, retain) FSVenue *venue;
@property (nonatomic, retain) NSArray *pickerData;

- (IBAction)btnLocationAction:(id)sender;
- (IBAction)btnStartEndTimeAction:(id)sender;
- (IBAction)btnSharePictureAction:(id)sender;
- (IBAction)btnPriceAction:(id)sender;
- (IBAction)onKeyReturn:(id)sender;
- (IBAction)btnClearLinkSelection:(id)sender;
- (IBAction)btnLinkAction:(id)sender;
- (IBAction)btnSelectCategoryAction:(id)sender;
- (IBAction)btnClearTimeSelection:(id)sender;
- (IBAction)btnClearCategorySelection:(id)sender;
- (IBAction)btnClearPrice:(id)sender;

- (IBAction)btnDoneOverlayAction:(id)sender;
- (IBAction)btnDonePickerViewAction:(id)sender;
- (IBAction)btnCancelPickerViewAction:(id)sender;
- (IBAction)btnCurrencySelectionAction:(id)sender;

@end
