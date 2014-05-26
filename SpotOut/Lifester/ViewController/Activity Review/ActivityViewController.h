//
//  AcitivityViewController.h
//  SpotOut
//
//  Created by MAC240 on 5/15/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"
#import "RootViewDelegate.h"
#import "ELCImagePickerController.h"
#import "FSVenue.h"
#import "CategorySelectionOverlay.h"
#import "AppDelegate.h"

@interface ActivityViewController : UIViewController <UITextFieldDelegate, RootViewDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, ELCImagePickerControllerDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *activityDescView;
    IBOutlet UIView *titleView;
    IBOutlet UIView *activitySectionView;
    
    IBOutlet UIView *locationSection;
    IBOutlet UIView *sharePictureSection;
    IBOutlet UIView *linkSection;
    IBOutlet UIView *tagSection;
    
    IBOutlet UIImageView *imageLocation;
    IBOutlet UIButton *btnClearLink;
    IBOutlet UIButton *btnClearCategory;
    IBOutlet UIImageView *imvLine1;
    IBOutlet UIImageView *imvLine2;
    IBOutlet UIImageView *imvLine3;
    
    IBOutlet UITextField *txtActivityTitle;
    IBOutlet UILabel *lblCategory;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblLink;
    IBOutlet UILabel *lblSharingPicture;
    
    IBOutlet SSTextView *txtViewThoats;
    IBOutlet UIToolbar *toolBar;
    
    float lastContentSize;
    NSMutableArray *arrCategoryId;
    
    AppDelegate *appDelegate;
}
@property (nonatomic, retain) NSMutableArray *arrShareImage;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScollView;
@property (nonatomic, retain) FSVenue *venue;

- (IBAction)btnLocationAction:(id)sender;
- (IBAction)btnSharePictureAction:(id)sender;
- (IBAction)onKeyReturn:(id)sender;
- (IBAction)btnClearLinkSelection:(id)sender;
- (IBAction)btnLinkAction:(id)sender;
- (IBAction)btnSelectCategoryAction:(id)sender;
- (IBAction)btnClearCategorySelection:(id)sender;



@end
