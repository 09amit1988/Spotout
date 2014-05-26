//
//  AddPlaceRatingOverlay.h
//  Lifester
//


#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
#import "OverlayView.h"
#import "RootViewDelegate.h"
#import "DYRateView.h"
#import "SSTextView.h"
#import "AppDelegate.h"
#import "AddLocationPlaceRating.h"
#import "LifeFeedPost.h"

@interface AddPlaceRatingOverlay : OverlayView <DYRateViewDelegate, UITextViewDelegate, AddLocationPlaceRatingDelegate, UITextViewDelegate>
{
    IBOutlet UIView *viewDoneButton;
    IBOutlet SSTextView *txtComment;
    IBOutlet UISlider *rateSlider;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIView *tipsView;
    IBOutlet UIImageView *imvWhiteBox;
    
    float lastContentSize;
    DYRateView *rateView;
    AppDelegate *appDelegate;
}
@property (nonatomic, retain) IBOutlet UIImageView *imvWhiteBox;
@property (nonatomic, retain) IBOutlet UIView *tipsView;
@property (nonatomic, retain) IBOutlet UIView *viewDoneButton;
@property (nonatomic, retain) IBOutlet SSTextView *txtComment;
@property (nonatomic, retain) IBOutlet UISlider *rateSlider;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) DYRateView *rateView;
@property (nonatomic, retain) AppDelegate *appDelegate;
@property (nonatomic, retain) LifeFeedPost *lifeFeedPost;
@property (nonatomic, retain) UIView *parentView;
@property (nonatomic, assign) float averageRating;

- (IBAction)btnDoneOverlayAction:(id)sender;
- (IBAction)sliderValueChangeAction:(id)sender;
- (IBAction)btnDoneHideKetboardAction:(id)sender;

+ (void)showAlert:(LifeFeedPost*)feedPost delegate:(id)sender withParentView:(UIView*)view withTag:(NSInteger)iTag;

@end