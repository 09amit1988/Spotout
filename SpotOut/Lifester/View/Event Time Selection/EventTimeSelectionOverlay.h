//
//  EventTimeSelectionOverlay.h
//  Lifester
//


#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
#import "OverlayView.h"
#import "RootViewDelegate.h"


@interface EventTimeSelectionOverlay : OverlayView
{
	IBOutlet UIButton *btnStartTime;
    IBOutlet UIButton *btnEndTime;
    IBOutlet UIButton *btnStartDate;
    IBOutlet UIButton *btnEndDate;
    IBOutlet UIDatePicker *picker;
    IBOutlet UIToolbar *pickerToolbar;
    
    IBOutlet UIBarButtonItem *doneBtn;
    NSInteger iSelectionOption;
}
@property (nonatomic, retain) IBOutlet UIButton *btnStartTime;
@property (nonatomic, retain) IBOutlet UIButton *btnEndTime;
@property (nonatomic, retain) IBOutlet UIButton *btnStartDate;
@property (nonatomic, retain) IBOutlet UIButton *btnEndDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *picker;
@property (nonatomic, retain) IBOutlet UIToolbar *pickerToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneBtn;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property (nonatomic, assign) NSInteger iSelectionOption;

@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;

@property (nonatomic, retain) IBOutlet UIView *viewDoneButton;
@property (nonatomic, retain) IBOutlet UIView *viewEventTimeSection;

- (IBAction)startTimeBtnAction:(id)sender;
- (IBAction)endTimeBtnAction:(id)sender;
- (IBAction)dismissOverlayAction:(id)sender;
- (IBAction)btnPickerDoneAction:(id)sender;
- (IBAction)startDateBtnAction:(id)sender;
- (IBAction)endDateBtnAction:(id)sender;


+ (void)showAlert:(NSString*)strHeader delegate:(id)sender withTag:(NSInteger)iTag;


@end