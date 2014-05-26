//
//  AddTicketOverlay.m
//  Lifester
//


#import <QuartzCore/QuartzCore.h>
#import "AddTicketOverlay.h"
#import "TDDatePickerController.h"

@implementation AddTicketOverlay

@synthesize viewDoneButton;
@synthesize addTicketView;
@synthesize arrTicket;
@synthesize toolBar;
@synthesize selectTextfield;
@synthesize selectedButton;
@synthesize yOrigin;
@synthesize scrollView;
@synthesize totalTicket;
@synthesize picker;
@synthesize pickerView;
@synthesize pickerToolBar;
@synthesize pickerData;
@synthesize btnRemoveTicket;

+ (void)showAlert:(NSMutableArray*)ticket delegate:(id)sender withTag:(NSInteger)iTag
{
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"AddTicketOverlay" bundle:[NSBundle mainBundle]];
    AddTicketOverlay *alert = (AddTicketOverlay *)controller.view;
    alert.arrTicket = [ticket mutableCopy];
    if (alert.arrTicket == nil) {
        alert.arrTicket = [[NSMutableArray alloc] init];
    }
    
    if (IS_IPHONE_5) {
        alert.viewDoneButton.frame = CGRectMake(alert.viewDoneButton.frame.origin.x, 504, alert.viewDoneButton.frame.size.width, alert.viewDoneButton.frame.size.height);
        alert.scrollView.frame = CGRectMake(alert.scrollView.frame.origin.x, alert.scrollView.frame.origin.y, alert.scrollView.frame.size.width, 423);
    } else {
        alert.viewDoneButton.frame = CGRectMake(alert.viewDoneButton.frame.origin.x, 456, alert.viewDoneButton.frame.size.width, alert.viewDoneButton.frame.size.height);
        alert.scrollView.frame = CGRectMake(alert.scrollView.frame.origin.x, alert.scrollView.frame.origin.y, alert.scrollView.frame.size.width, 370);
    }
    [[alert.viewDoneButton layer] setCornerRadius:2.5];
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"Ccy" ascending:YES];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"]];
    NSMutableArray *uniqueGenres = [NSMutableArray array];
    for (NSDictionary *entity in array) {
        BOOL hasDuplicate = [[uniqueGenres filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Ccy == %@", [entity objectForKey:@"Ccy"]]] count] > 0;
        
        if (!hasDuplicate) {
            [uniqueGenres addObject:entity];
        }
    }
    alert.pickerData = [uniqueGenres sortedArrayUsingDescriptors:@[sd]];
    
    [alert.toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [alert.toolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [alert.toolBar sizeToFit];
    
    [alert.pickerToolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [alert.pickerToolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [alert.pickerToolBar sizeToFit];
    
    alert.totalTicket = [alert.arrTicket count];
    alert.yOrigin = 0;
    if ([alert.arrTicket count] > 0) {
        for (int i = 0; i < [alert.arrTicket count]; i++) {
            UIView *ticketView = [[[UIView alloc] initWithFrame:CGRectMake(10, alert.yOrigin, 300, 89)] autorelease];
            [ticketView setBackgroundColor:[UIColor clearColor]];
            NSInteger tag = 1000+i;
            [ticketView setTag:tag];
            
            NSDictionary *dictData = [alert.arrTicket objectAtIndex:i];
            
            UIImageView *imvBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 89)] autorelease];
            [imvBackground setImage:[UIImage imageNamed:@"price-content-box.png"]];
            [ticketView addSubview:imvBackground];
            
            UITextField *txtTicketName = [[[UITextField alloc] initWithFrame:CGRectMake(10, 8, 274, 30)] autorelease];
            [txtTicketName setDelegate:alert];
            [txtTicketName setTag:10001];
            txtTicketName.placeholder = [NSString stringWithFormat:@"Ticket Name 1"];
            txtTicketName.text = [dictData objectForKey:@"ticketName"];
            txtTicketName.font = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
            [txtTicketName setAutocorrectionType:UITextAutocorrectionTypeNo];
            txtTicketName.borderStyle = UITextBorderStyleNone;
            txtTicketName.textColor = [UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
            if ([txtTicketName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                txtTicketName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtTicketName.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
            }
            txtTicketName.keyboardType = UIKeyboardTypeDefault;
            [ticketView addSubview:txtTicketName];
            
            UIImageView *imvLine = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 290, 0.7)] autorelease];
            [imvLine setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
            [ticketView addSubview:imvLine];
            
            UITextField *txtPrice = [[[UITextField alloc] initWithFrame:CGRectMake(10, 53, 175, 30)] autorelease];
            [txtPrice setDelegate:alert];
            [txtPrice setTag:10002];
            txtPrice.placeholder = [NSString stringWithFormat:@"Ticket price"];
            txtPrice.text = [dictData objectForKey:@"price"];
            txtPrice.font = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
            [txtPrice setAutocorrectionType:UITextAutocorrectionTypeNo];
            txtPrice.textColor = SELECTED_COLOR;
            if ([txtPrice respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                txtPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtPrice.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
            }
            txtPrice.keyboardType = UIKeyboardTypeDecimalPad;
            txtPrice.borderStyle = UITextBorderStyleNone;
            txtPrice.inputAccessoryView = alert.toolBar;
            [ticketView addSubview:txtPrice];
            
            UIButton *btnCurrency = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCurrency.frame = CGRectMake(219, 53, 72, 30);
            [btnCurrency setTitle:[dictData objectForKey:@"currency"] forState:UIControlStateNormal];
            [btnCurrency setTitle:[dictData objectForKey:@"currency"] forState:UIControlStateHighlighted];
            [btnCurrency setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [btnCurrency setTitleColor:[UIColor colorWithRed:84.0/255.0 green:172.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btnCurrency.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
            [btnCurrency setTag:10003];
            [btnCurrency addTarget:alert action:@selector(changeCurrencyAction:) forControlEvents:UIControlEventTouchUpInside];
            [ticketView addSubview:btnCurrency];
            
            [alert.scrollView addSubview:ticketView];
            
            alert.yOrigin = alert.yOrigin + ticketView.frame.size.height;
            alert.yOrigin = alert.yOrigin + 10;
        }
        
        [alert.btnRemoveTicket setHidden:NO];
    } else {
        UIView *ticketView = [[[UIView alloc] initWithFrame:CGRectMake(10, alert.yOrigin, 300, 89)] autorelease];
        [ticketView setBackgroundColor:[UIColor clearColor]];
        [ticketView setTag:1000];
        
        UIImageView *imvBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 89)] autorelease];
        [imvBackground setImage:[UIImage imageNamed:@"price-content-box.png"]];
        [ticketView addSubview:imvBackground];
        
        UITextField *txtTicketName = [[[UITextField alloc] initWithFrame:CGRectMake(10, 8, 274, 30)] autorelease];
        [txtTicketName setDelegate:alert];
        [txtTicketName setTag:10001];
        txtTicketName.placeholder = [NSString stringWithFormat:@"Ticket Name 1"];
        txtTicketName.font = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
        [txtTicketName setAutocorrectionType:UITextAutocorrectionTypeNo];
        txtTicketName.borderStyle = UITextBorderStyleNone;
        txtTicketName.textColor = [UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
        if ([txtTicketName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            txtTicketName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtTicketName.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
        }
        txtTicketName.keyboardType = UIKeyboardTypeDefault;
        [ticketView addSubview:txtTicketName];
        
        UIImageView *imvLine = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 290, 0.7)] autorelease];
        [imvLine setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
        [ticketView addSubview:imvLine];
        
        UITextField *txtPrice = [[[UITextField alloc] initWithFrame:CGRectMake(10, 53, 175, 30)] autorelease];
        [txtPrice setDelegate:alert];
        [txtPrice setTag:10002];
        txtPrice.placeholder = [NSString stringWithFormat:@"Ticket price"];
        txtPrice.font = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
        [txtPrice setAutocorrectionType:UITextAutocorrectionTypeNo];
        txtPrice.textColor = SELECTED_COLOR;
        if ([txtPrice respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            txtPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtPrice.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
        }
        txtPrice.keyboardType = UIKeyboardTypeDecimalPad;
        txtPrice.borderStyle = UITextBorderStyleNone;
        txtPrice.inputAccessoryView = alert.toolBar;
        [ticketView addSubview:txtPrice];
        
        UIButton *btnCurrency = [UIButton buttonWithType:UIButtonTypeCustom];
        //UIButton *btnCurrency = [[[UIButton alloc] initWithFrame:CGRectMake(219, 53, 72, 30)] autorelease];
        btnCurrency.frame = CGRectMake(219, 53, 72, 30);
        //NSString *currencyCode1 = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
        [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateNormal];
        [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateHighlighted];
        [btnCurrency setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btnCurrency setTitleColor:[UIColor colorWithRed:84.0/255.0 green:172.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnCurrency.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
        [btnCurrency setTag:10003];
        [btnCurrency addTarget:alert action:@selector(changeCurrencyAction:) forControlEvents:UIControlEventTouchUpInside];
        [ticketView addSubview:btnCurrency];
        
        [alert.scrollView addSubview:ticketView];
        
        alert.yOrigin = alert.yOrigin + ticketView.frame.size.height;
        alert.totalTicket++;
        
        [alert.btnRemoveTicket setHidden:YES];
    }
    
    alert.yOrigin = alert.yOrigin + 10;
    alert.addTicketView.frame = CGRectMake(alert.addTicketView.frame.origin.x, alert.yOrigin, alert.addTicketView.frame.size.width, alert.addTicketView.frame.size.height);
    alert.scrollView.contentSize = CGSizeMake(alert.scrollView.frame.size.width, alert.yOrigin+alert.addTicketView.frame.size.height+10);
   
    
    alert.delegate = sender;
	[alert show];
	[controller release];
}

#pragma mark - Action Method

- (IBAction)btnAddTicketAction:(id)sender
{
    [btnRemoveTicket setHidden:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    UIView *ticketView = [[[UIView alloc] initWithFrame:CGRectMake(10, yOrigin, 300, 89)] autorelease];
    [ticketView setBackgroundColor:[UIColor clearColor]];
    NSInteger tag = totalTicket + 1000;
    [ticketView setTag:tag];
    
    UIImageView *imvBackground = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 89)] autorelease];
    [imvBackground setImage:[UIImage imageNamed:@"price-content-box.png"]];
    [ticketView addSubview:imvBackground];
    
    UITextField *txtTicketName = [[[UITextField alloc] initWithFrame:CGRectMake(10, 8, 274, 30)] autorelease];
    [txtTicketName setDelegate:self];
    [txtTicketName setTag:10001];
    txtTicketName.placeholder = [NSString stringWithFormat:@"Ticket Name"];
    txtTicketName.font = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
    [txtTicketName setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtTicketName.borderStyle = UITextBorderStyleNone;
    txtTicketName.textColor = [UIColor colorWithRed:251.0/255.0 green:176.0/255.0 blue:64.0/255.0 alpha:1.0];
    if ([txtTicketName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtTicketName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtTicketName.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    }
    txtTicketName.keyboardType = UIKeyboardTypeDefault;
    [ticketView addSubview:txtTicketName];
    
    UIImageView *imvLine = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 290, 0.7)] autorelease];
    [imvLine setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
    [ticketView addSubview:imvLine];
    
    UITextField *txtPrice = [[[UITextField alloc] initWithFrame:CGRectMake(10, 53, 175, 30)] autorelease];
    [txtPrice setDelegate:self];
    [txtPrice setTag:10002];
    txtPrice.placeholder = [NSString stringWithFormat:@"Ticket price"];
    txtPrice.font = [UIFont fontWithName:HELVETICANEUEREGULAR size:14.0];
    [txtPrice setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPrice.textColor = SELECTED_COLOR;
    if ([txtPrice respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtPrice.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    }
    txtPrice.keyboardType = UIKeyboardTypeDecimalPad;
    txtPrice.borderStyle = UITextBorderStyleNone;
    txtPrice.inputAccessoryView = self.toolBar;
    [ticketView addSubview:txtPrice];
    
    UIButton *btnCurrency = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    btnCurrency.frame = CGRectMake(219, 53, 72, 30);
    [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateNormal];
    [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateHighlighted];
    [btnCurrency setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnCurrency setTitleColor:[UIColor colorWithRed:84.0/255.0 green:172.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnCurrency setTag:10003];
    [btnCurrency.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEMEDIUM size:14.0]];
    [btnCurrency addTarget:self action:@selector(changeCurrencyAction:) forControlEvents:UIControlEventTouchUpInside];
    [ticketView addSubview:btnCurrency];
    
    [self.scrollView addSubview:ticketView];
    
    yOrigin = yOrigin + ticketView.frame.size.height;
    yOrigin = yOrigin + 10;
    self.addTicketView.frame = CGRectMake(self.addTicketView.frame.origin.x, yOrigin, self.addTicketView.frame.size.width, self.addTicketView.frame.size.height);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, yOrigin+self.addTicketView.frame.size.height+10);

    [UIView commitAnimations];
    totalTicket++;
}

- (IBAction)btnRemoveTicketAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    int Tag = ((totalTicket-1)+1000);
    UIView *ticketView = (UIView*)[self.scrollView viewWithTag:Tag];
    yOrigin = yOrigin - ticketView.frame.size.height - 10;
    [ticketView removeFromSuperview];

    self.addTicketView.frame = CGRectMake(self.addTicketView.frame.origin.x, yOrigin, self.addTicketView.frame.size.width, self.addTicketView.frame.size.height);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, yOrigin+self.addTicketView.frame.size.height+10);
    [UIView commitAnimations];
    
    [self.arrTicket removeLastObject];
    totalTicket--;
    
    if (totalTicket == 0) {
        [btnRemoveTicket setHidden:YES];
    }
}

- (void)changeCurrencyAction:(id)sender
{
    self.selectedButton = (UIButton*)sender;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Ccy == %@", [selectedButton titleForState:UIControlStateNormal]];
    NSArray *filArray = [self.pickerData filteredArrayUsingPredicate:predicate];
    if ([filArray count]>0) {
        NSInteger index = [self.pickerData indexOfObject:[filArray objectAtIndex:0]];
        [picker selectRow:index inComponent:0 animated:YES];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.7] ;
    if (IS_IPHONE_5) {
        pickerView.center = CGPointMake(self.center.x, 430);
    } else {
        pickerView.center = CGPointMake(self.center.x, 400);
    }
    [UIView commitAnimations];
}

- (IBAction)btnPickerDoneAction:(id)sender
{
    NSDictionary *dictData = [pickerData objectAtIndex:[picker selectedRowInComponent:0]];
    [selectedButton setTitle:[dictData objectForKey:@"Ccy"] forState:UIControlStateNormal];
    [selectedButton setTitle:[dictData objectForKey:@"Ccy"] forState:UIControlStateHighlighted];
    
    CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGPoint offScreenCenter = CGPointZero;
	offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationDelegate:self];
	pickerView.center = offScreenCenter;
	[UIView commitAnimations];
}

- (IBAction)btnPickerCancelAction:(id)sender
{
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    
	CGPoint offScreenCenter = CGPointZero;
	offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationDelegate:self];
	pickerView.center = offScreenCenter;
	[UIView commitAnimations];
}


- (IBAction)btnDoneHideKeyboardAction:(id)sender
{
    [self.selectTextfield resignFirstResponder];
}

- (IBAction)btnDoneOverlayAction:(id)sender
{
    [self.arrTicket removeAllObjects];
    for (int i = 0; i < totalTicket; i++) {
        int Tag = i+1000;
        
        UIView *ticketView = (UIView*)[self.scrollView viewWithTag:Tag];
        NSString *ticketName = [(UITextField*)[ticketView viewWithTag:10001] text];
        NSString *price = [(UITextField*)[ticketView viewWithTag:10002] text];
        NSString *currecny = [(UIButton*)[ticketView viewWithTag:10003] titleForState:UIControlStateNormal];
        
        if (![ticketName length]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                            message:@"Please enter Ticket name."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        
        if (![price length]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                            message:@"Please enter Ticket price."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      ticketName, @"ticketName",
                                      price, @"price",
                                      currecny, @"currency", nil];
        
        [self.arrTicket addObject:dict1];
    }
    
    //NSLog(@"Array Ticket === %@", arrTicket);
    [self dismissWithSuccess:YES animated:YES childView:self];
}

- (void)dismissOverlayAction
{
    [self dismissWithSuccess:YES animated:YES childView:self];
}

#pragma Mark - UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dictData = [pickerData objectAtIndex:row];
    return [dictData objectForKey:@"Ccy"];
}

#pragma Mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.selectTextfield = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.selectTextfield = nil;
    return YES;
}

#pragma mark - Baseclass methods

- (void)dialogWillAppear {
	[super dialogWillAppear];
}

- (void)dialogWillDisappear {
	[super dialogWillDisappear];
}

- (void)dealloc {
    [super dealloc];
}


@end
