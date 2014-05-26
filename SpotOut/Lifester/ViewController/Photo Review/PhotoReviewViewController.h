//
//  PhotoReviewViewController.h
//  Lifester
//
//  Created by MAC240 on 2/24/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"
#import "AddLocation_IPhone5.h"
#import "AppDelegate.h"

@interface PhotoReviewViewController : UIViewController <RootViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIView *photoDescView;
    IBOutlet UIView *otherSectionView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *TitleView;
    
    IBOutlet UIView *otherSection;
    IBOutlet UIToolbar * toolBar;
    IBOutlet UIButton *btnClearLink;
    IBOutlet UIButton *btnClearCategory;
    IBOutlet UILabel *lblLink;
    IBOutlet UILabel *lblCategory;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblPicture;
    IBOutlet UIImageView *imvLine1;
    IBOutlet UIImageView *imvLine2;
    IBOutlet UIImageView *imvLine3;
    IBOutlet UIImageView *imageLocation;
    
    IBOutlet UITextField *txtPictureTitle;
    IBOutlet SSTextView *txtViewThoats;
    
    float lastContentSize;
    NSMutableArray *arrCategoryId;
    AppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet UIScrollView *imageScollView;
@property (nonatomic, retain) NSMutableArray *arrImages;
@property (nonatomic, retain) FSVenue *venue;

- (IBAction)btnLinkAction:(id)sender;
- (IBAction)btnSelectCategoryAction:(id)sender;
- (IBAction)onKeyReturn:(id)sender;
- (IBAction)btnClearLinkSelection:(id)sender;
- (IBAction)btnClearCategorySelection:(id)sender;


@end
