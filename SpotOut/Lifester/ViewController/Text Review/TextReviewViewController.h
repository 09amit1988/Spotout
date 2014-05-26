//
//  TextReviewViewController.h
//  Lifester
//
//  Created by MAC240 on 2/24/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewDelegate.h"
#import "CategorySelectionOverlay.h"
#import "SSTextView.h"
#import "AppDelegate.h"


@interface TextReviewViewController : UIViewController <UITextFieldDelegate, RootViewDelegate>
{
    IBOutlet UIView *textDescView;
    IBOutlet UIToolbar * toolBar;
    IBOutlet UIButton *btnClearLink;
    IBOutlet UIButton *btnClearCategory;
    IBOutlet UILabel *lblLink;
    IBOutlet UILabel *lblCategory;
    IBOutlet UIView *otherSection;
    IBOutlet UIImageView *imvLine1;
    
    IBOutlet SSTextView *txtViewThoats;
    
    float lastContentSize;
    NSMutableArray *arrCategoryId;
    AppDelegate *appDelegate;
}

- (IBAction)btnLinkAction:(id)sender;
- (IBAction)btnSelectCategoryAction:(id)sender;
- (IBAction)onKeyReturn:(id)sender;
- (IBAction)btnClearLinkSelection:(id)sender;
- (IBAction)btnClearCategorySelection:(id)sender;


@end
