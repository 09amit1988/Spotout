//
//  SuggestPlaceViewController.h
//  Lifester
//
//  Created by MAC205 on 08/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foursquare2.h"
#import "SSTextView.h"
#import "RootViewDelegate.h"
#import "EventTimeSelectionOverlay.h"
#import "ELCImagePickerController.h"
#import "DYRateView.h"
#import "FSVenue.h"
#import "AppDelegate.h"
#import "IconDownloader.h"
#import "ASIFormDataRequest.h"

@class AppDelegate;

@interface SuggestPlaceViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, RootViewDelegate, ELCImagePickerControllerDelegate,DYRateViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UIView *viewOverlay;
    
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *viewTop;
    IBOutlet UIView *viewLocation;
    IBOutlet UIView *viewEvent;
    IBOutlet UIView *rateSection;
    IBOutlet UIView *sharePictureSection;
    IBOutlet UIView *highlightSection;
    IBOutlet UIView *linkSection;
    IBOutlet UIView *otherSection;
    
    IBOutlet UIImageView *imvLine1;
    IBOutlet UIImageView *imvLine2;
    IBOutlet UIImageView *imvLine3;
    IBOutlet UIImageView *imvLine4;
    
    IBOutlet UIImageView *imageLocation;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblSharingPicture;
    IBOutlet UILabel *lblLink;
    IBOutlet UILabel *lblCategory;
    IBOutlet UITextField *txtHighlight;
    IBOutlet SSTextView *txtViewThoats;
    IBOutlet UIView *categoryBackView;
    
    IBOutlet UIButton *btnClearRate;
    IBOutlet UIButton *btnClearLink;
    IBOutlet UIButton *btnClearCategory;
    IBOutlet UIView *viewDoneRating;
    IBOutlet UIView *viewDoneCategory;
    
    NSString *ratingValue;
    NSMutableArray *arrCategoryId;
    
    IBOutlet UISlider *rateSlider;
    IBOutlet UILabel *lblSliderValue;
    
    NSInteger selectedIndex; //This is the index of the cell which will be expanded
    
    DYRateView *rateview;
    DYRateView *rateviewOverlay;
    BOOL isHighLightTextField;
    AppDelegate *appDelegate;
    float lastContentSize;
    
    int flag;
    int iOperations;
    IBOutlet UILabel *lblValue;
}

@property (nonatomic, retain) NSMutableArray *arrShareImage;
@property (nonatomic, retain) NSMutableArray *arrImageData;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScollView;
@property (nonatomic, retain) FSVenue *venue;

- (IBAction)onOverlayviewPressed :(id)sender;
- (IBAction)sliderValueChangeAction:(id)sender;
- (IBAction)btnRateAction:(id)sender;
- (IBAction)btnStartEndTimeAction:(id)sender;
- (IBAction)btnSharePictureAction:(id)sender;
- (IBAction)btnHighlightAction:(id)sender;
- (IBAction)btnLinkAction:(id)sender;
- (IBAction)btnSelectCategoryAction:(id)sender;
- (IBAction)onKeyReturn:(id)sender;
- (IBAction)btnLocationDetailAction:(id)sender;

- (IBAction)btnClearRateSelection:(id)sender;
- (IBAction)btnClearLinkSelection:(id)sender;
- (IBAction)btnClearCategorySelection:(id)sender;

@end
