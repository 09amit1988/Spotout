//
//  AddTicketOverlay.h
//  Lifester
//


#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
#import "OverlayView.h"
#import "RootViewDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AddTicketOverlay : OverlayView <UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIView *viewDoneButton;
    IBOutlet UIView *addTicketView;
    IBOutlet UIButton *btnRemoveTicket;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIToolbar *pickerToolBar;
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    
    IBOutlet UIPickerView* picker;
    IBOutlet UIView *pickerView;
}
@property (nonatomic, retain) IBOutlet UIView *viewDoneButton;
@property (nonatomic, retain) IBOutlet UIView *addTicketView;
@property (nonatomic, retain) IBOutlet UIButton *btnRemoveTicket;
@property (nonatomic, retain) NSMutableArray *arrTicket;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) IBOutlet UIToolbar *pickerToolBar;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPickerView* picker;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property (nonatomic, retain) UITextField *selectTextfield;
@property (nonatomic, retain) UIButton *selectedButton;

@property (nonatomic, assign) float yOrigin;
@property (nonatomic, assign) NSInteger totalTicket;
@property (nonatomic, retain) NSArray *pickerData;


- (IBAction)btnDoneOverlayAction:(id)sender;
- (IBAction)btnAddTicketAction:(id)sender;
- (IBAction)btnRemoveTicketAction:(id)sender;
- (IBAction)btnDoneHideKeyboardAction:(id)sender;

+ (void)showAlert:(NSMutableArray*)ticket delegate:(id)sender withTag:(NSInteger)iTag;

@end