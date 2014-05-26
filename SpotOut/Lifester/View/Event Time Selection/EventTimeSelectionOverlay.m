//
//  EventTimeSelectionOverlay.m
//  Lifester
//


#import <QuartzCore/QuartzCore.h>
#import "EventTimeSelectionOverlay.h"

@implementation EventTimeSelectionOverlay

@synthesize btnStartTime, btnEndDate, btnStartDate;
@synthesize btnEndTime;
@synthesize pickerToolbar;
@synthesize picker;
@synthesize doneBtn;
@synthesize iSelectionOption;

@synthesize viewDoneButton;
@synthesize pickerView;
@synthesize viewEventTimeSection;

@synthesize startDate;
@synthesize endDate;

+ (void)showAlert:(NSString*)strHeader delegate:(id)sender withTag:(NSInteger)iTag
{
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"EventTimeSelectionOverlay" bundle:[NSBundle mainBundle]];
	EventTimeSelectionOverlay *alert = (EventTimeSelectionOverlay *)controller.view;
    
    [alert.pickerToolbar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [alert.pickerToolbar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [alert.pickerToolbar sizeToFit];
    [alert.doneBtn setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor], UITextAttributeTextColor,
                                      [UIFont fontWithName:@"HelveticaNeue-regular" size:14.0], UITextAttributeFont,
                                      nil] forState:UIControlStateNormal];
    alert.iSelectionOption = 1;
    alert.picker.backgroundColor = [UIColor whiteColor];
    
    [alert.btnStartDate setTitleColor:[UIColor colorWithRed:71.0/255.0 green:119.0/255.0 blue:149.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [alert.btnStartTime setTitleColor:[UIColor colorWithRed:71.0/255.0 green:119.0/255.0 blue:149.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [alert.btnEndDate setTitleColor:[UIColor colorWithRed:71.0/255.0 green:119.0/255.0 blue:149.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [alert.btnEndTime setTitleColor:[UIColor colorWithRed:71.0/255.0 green:119.0/255.0 blue:149.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [[alert.viewDoneButton layer] setCornerRadius:2.5];
    
    alert.startDate = @"";
    alert.endDate = @"";
    alert.delegate = sender;
	[alert show];
    
    if (IS_IPHONE_5) {
        alert.viewDoneButton.frame = CGRectMake(alert.viewDoneButton.frame.origin.x, 504, alert.viewDoneButton.frame.size.width, alert.viewDoneButton.frame.size.height);
        alert.viewEventTimeSection.frame = CGRectMake(alert.viewEventTimeSection.frame.origin.x, 84, alert.viewEventTimeSection.frame.size.width, alert.viewEventTimeSection.frame.size.height);
    } else {
        alert.viewDoneButton.frame = CGRectMake(alert.viewDoneButton.frame.origin.x, 456, alert.viewDoneButton.frame.size.width, alert.viewDoneButton.frame.size.height);
        alert.viewEventTimeSection.frame = CGRectMake(alert.viewEventTimeSection.frame.origin.x, 84, alert.viewEventTimeSection.frame.size.width, alert.viewEventTimeSection.frame.size.height);
    }
    
	[controller release];
}

#pragma mark - UIButton Action

- (IBAction)startDateBtnAction:(id)sender
{
    iSelectionOption = 1;
    picker.datePickerMode = UIDatePickerModeDate;
    picker.minimumDate = [NSDate date];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.5];
    if (IS_IPHONE_5) {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.frame.size.height-pickerView.frame.size.height, pickerView.frame.size.width, pickerView.frame.size.height);
    } else {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, 315, pickerView.frame.size.width, pickerView.frame.size.height);
    }
    [UIView commitAnimations];
}

- (IBAction)startTimeBtnAction:(id)sender
{
    iSelectionOption = 2;
    picker.datePickerMode = UIDatePickerModeTime;
    picker.minimumDate = [NSDate date];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.5];
    if (IS_IPHONE_5) {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.frame.size.height-pickerView.frame.size.height, pickerView.frame.size.width, pickerView.frame.size.height);
    } else {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, 315, pickerView.frame.size.width, pickerView.frame.size.height);
    }
    [UIView commitAnimations];
}

- (IBAction)endDateBtnAction:(id)sender
{
    iSelectionOption = 3;
    picker.datePickerMode = UIDatePickerModeDate;
    picker.minimumDate = [NSDate date];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.5];
    if (IS_IPHONE_5) {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.frame.size.height-pickerView.frame.size.height, pickerView.frame.size.width, pickerView.frame.size.height);
    } else {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, 315, pickerView.frame.size.width, pickerView.frame.size.height);
    }
    [UIView commitAnimations];
}

- (IBAction)endTimeBtnAction:(id)sender
{
    iSelectionOption = 4;
    picker.datePickerMode = UIDatePickerModeTime;
    picker.minimumDate = [NSDate date];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.5];
    if (IS_IPHONE_5) {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.frame.size.height-pickerView.frame.size.height, pickerView.frame.size.width, pickerView.frame.size.height);
    } else {
        pickerView.frame = CGRectMake(pickerView.frame.origin.x, 315, pickerView.frame.size.width, pickerView.frame.size.height);
    }
    [UIView commitAnimations];
}

- (IBAction)btnPickerDoneAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (iSelectionOption == 1) {
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        [self.btnStartDate setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateNormal];
        [self.btnStartDate setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateHighlighted];
        
        [self.btnStartDate setTitleColor:[UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    } else if (iSelectionOption == 2) {
        [dateFormatter setDateFormat:@"hh:mm a"];
        [self.btnStartTime setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateNormal];
        [self.btnStartTime setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateHighlighted];
        
        [self.btnStartTime setTitleColor:[UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    } else if (iSelectionOption == 3) {
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        [self.btnEndDate setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateNormal];
        [self.btnEndDate setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateHighlighted];
        
        [self.btnEndDate setTitleColor:[UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    } else if (iSelectionOption == 4) {
        [dateFormatter setDateFormat:@"hh:mm a"];
        [self.btnEndTime setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateNormal];
        [self.btnEndTime setTitle:[dateFormatter stringFromDate:picker.date] forState:UIControlStateHighlighted];
        
        [self.btnEndTime setTitleColor:[UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    [dateFormatter release];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.5];
    pickerView.frame = CGRectMake(pickerView.frame.origin.x, self.frame.size.height+pickerView.frame.size.height, pickerView.frame.size.width, pickerView.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)dismissOverlayAction:(id)sender
{
    if ([btnStartDate.titleLabel.text isEqualToString:@"Date"] || [btnStartTime.titleLabel.text isEqualToString:@"Start Time"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select first start date and time."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    self.startDate = [NSString stringWithFormat:@"%@ %@", [btnStartDate titleForState:UIControlStateNormal], [btnStartTime titleForState:UIControlStateNormal]];
    self.endDate = [NSString stringWithFormat:@"%@ %@", [btnEndDate titleForState:UIControlStateNormal], [btnEndTime titleForState:UIControlStateNormal]];
    
    [self dismissWithSuccess:YES animated:YES childView:self];
}

#pragma mark - Baseclass methods

- (void)dialogWillAppear {
	[super dialogWillAppear];
}

- (void)dialogWillDisappear {
	[super dialogWillDisappear];
}

- (void)dealloc {
	self.btnEndTime = nil;
	self.btnStartTime = nil;
    [super dealloc];
}


@end
