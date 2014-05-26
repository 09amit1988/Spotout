//
//  AddEventViewController.h
//  Lifester
//
//  Created by MAC205 on 08/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewDelegate.h"
#import "EventTimeSelectionOverlay.h"
#import "ELCImagePickerController.h"
#import "FSVenue.h"
#import "IconDownloader.h"
#import "SSTextView.h"
#import "CategorySelectionOverlay.h"


@class EventTimeSelectionOverlay;

@interface AddEventViewController : UIViewController <UITextFieldDelegate, RootViewDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, ELCImagePickerControllerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *otherSection;
    IBOutlet UIView *eventDescView;
    IBOutlet UIView *locationView;
    IBOutlet UIView *viewEvent;
    IBOutlet UIView *timeView;
    IBOutlet UIView *sharePictureSection;
    IBOutlet UIView *linkSection;
    IBOutlet UIView *ticketView;
    IBOutlet SSTextView *txtViewThoats;
    IBOutlet UITextField *txtEventName;
    IBOutlet UIToolbar * toolBar;
    IBOutlet UIButton *btnClearLink;
    IBOutlet UIButton *btnClearCategory;
    IBOutlet UIButton *btnClearTime;
    IBOutlet UIButton *btnTicket;
    
    IBOutlet UIImageView *imageLocation;
    IBOutlet UIImageView *imvLine1;
    IBOutlet UIImageView *imvLine2;
    IBOutlet UIImageView *imvLine3;
    IBOutlet UIImageView *imvLine4;
    IBOutlet UIImageView *imvLine5;

    IBOutlet UILabel *lblSharingPicture;
    IBOutlet UILabel *lblWorkingTIme;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblCategory;
    IBOutlet UILabel *lblLink;
    IBOutlet UILabel *lblTicket;
    
    float lastContentSize;
    BOOL overlayTag;
    BOOL removeTicket;
    NSMutableArray *arrCategoryId;
    AppDelegate *appDelegate;
    
    NSString *startEventTime;
    NSString *endEventTime;
    int flag;
}
@property (nonatomic, retain) NSMutableArray *arrShareImage;
@property (nonatomic, retain) NSMutableArray *arrTicket;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScollView;
@property (nonatomic, retain) FSVenue *venue;

- (IBAction)btnLocationAction:(id)sender;
- (IBAction)btnStartEndTimeAction:(id)sender;
- (IBAction)btnSharePictureAction:(id)sender;
- (IBAction)onKeyReturn:(id)sender;
- (IBAction)btnClearLinkSelection:(id)sender;
- (IBAction)btnLinkAction:(id)sender;
- (IBAction)btnTicketPriceAction:(id)sender;
- (IBAction)btnSelectCategoryAction:(id)sender;

- (IBAction)btnClearCategorySelection:(id)sender;
- (IBAction)btnClearTimeSelection:(id)sender;

@end
