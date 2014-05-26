//
//  OfferReviewViewController.m
//  Lifester
//
//  Created by MAC240 on 1/13/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "OfferReviewViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "ELCAssetTablePicker.h"
#import "AddLocation_IPhone5.h"
#import "JSON.h"
#import "StringHelper.h"

@interface OfferReviewViewController ()

@end

@implementation OfferReviewViewController


@synthesize arrShareImage;
@synthesize imageScollView;
@synthesize venue;
@synthesize pickerData;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.arrShareImage = nil;
    self.venue = nil;
    self.pickerData = nil;
}

- (void)dealloc
{
    [super dealloc];
    [scrollView release];
    [offerDescView release];
    [titleView release];
    [offerSectionView release];
    
    [locationSection release];
    [timeSection release];
    [sharePictureSection release];
    [priceSection release];
    [linkSection release];
    [tagSection release];

    [imageLocation release];
    [btnClearLink release];
    [btnClearTime release];
    [btnClearCategory release];
    [btnClearPrice release];
    [imvLine1 release];
    [imvLine2 release];
    [imvLine3 release];
    [imvLine4 release];
    [imvLine5 release];
    
    [txtOfferTitle release];
    [lblWorkingTIme release];
    [lblCategory release];
    [lblLocation release];
    [lblLink release];
    [lblSharingPicture release];
    [lblPrice release];
    [txtViewThoats release];
    [toolBar release];
    [arrCategoryId release];
}

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Offer Review"];
    self.view.backgroundColor = VIEW_COLOR;
    self.arrShareImage = [[NSMutableArray alloc] init];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 568);
    [self setupMenuBarButtonItems];
    
    [btnClearLink setHidden:YES];
    [btnClearPrice setHidden:YES];
    [btnClearTime setHidden:YES];
    [btnClearCategory setHidden:YES];
    
    lblLink.textColor = NORMAL_COLOR;
    lblWorkingTIme.textColor = NORMAL_COLOR;
    lblSharingPicture.textColor = NORMAL_COLOR;
    lblPrice.textColor = NORMAL_COLOR;
    txtOfferTitle.textColor = SELECTED_COLOR;
    txtPrice.textColor = SELECTED_COLOR;
    
    if ([txtOfferTitle respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtOfferTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtOfferTitle.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
        txtPrice.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtPrice.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    [toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar sizeToFit];
    [txtViewThoats setInputAccessoryView:toolBar];
    [txtPrice setInputAccessoryView:toolBar];
    
    txtViewThoats.placeholder = @"Describe offer";
    txtViewThoats.placeholderTextColor = NORMAL_COLOR;
    txtViewThoats.textColor = SELECTED_COLOR;
    lblCategory.textColor = NORMAL_COLOR;
    lblLocation.textColor = NORMAL_COLOR;
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"Ccy" ascending:YES];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"]];
    NSMutableArray *uniqueGenres = [NSMutableArray array];
    for (NSDictionary *entity in array) {
        BOOL hasDuplicate = [[uniqueGenres filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Ccy == %@", [entity objectForKey:@"Ccy"]]] count] > 0;
        
        if (!hasDuplicate) {
            [uniqueGenres addObject:entity];
        }
    }
    self.pickerData = [uniqueGenres sortedArrayUsingDescriptors:@[sd]];
    
    [pickerToolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [pickerToolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [pickerToolBar sizeToFit];
    
    [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateNormal];
    [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateHighlighted];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
    imvLine2.frame = CGRectMake(imvLine2.frame.origin.x, imvLine2.frame.origin.y, imvLine2.frame.size.width, 0.7);
    imvLine3.frame = CGRectMake(imvLine3.frame.origin.x, imvLine3.frame.origin.y, imvLine3.frame.size.width, 0.7);
    imvLine4.frame = CGRectMake(imvLine4.frame.origin.x, imvLine4.frame.origin.y, imvLine4.frame.size.width, 0.7);
    imvLine5.frame = CGRectMake(imvLine5.frame.origin.x, imvLine5.frame.origin.y, imvLine5.frame.size.width, 0.7);
    
    [[titleView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[titleView layer] setBorderWidth:0.7];
    
    [[offerDescView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[offerDescView layer] setBorderWidth:0.7];
    
    [[offerSectionView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[offerSectionView layer] setBorderWidth:0.7];
    
    
    [imageLocation setClipsToBounds: YES];
    [[imageLocation layer] setMasksToBounds:YES];
    [[imageLocation layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[imageLocation layer] setBorderWidth:0.0];
    [[imageLocation layer] setCornerRadius:0.0];

    if (self.venue) {
        lblLocation.text = venue.name;
        if ([venue.locationImage length] > 0) {
            [IconDownloader loadImageFromLink:venue.locationImage forImageView:imageLocation withPlaceholder:nil andContentMode:UIViewContentModeScaleAspectFit];
            imageLocation.frame = CGRectMake(17, 7, 30, 30);
            [[imageLocation layer] setBorderWidth:0.7];
            [[imageLocation layer] setCornerRadius:imageLocation.frame.size.width/2.0];
        } else {
            imageLocation.image = [UIImage imageNamed:@"location-icon.png"];
            imageLocation.frame = CGRectMake(25, 11, 15, 22);
            [[imageLocation layer] setBorderWidth:0.0];
        }
        
        [imageLocation setClipsToBounds: YES];
        [[imageLocation layer] setMasksToBounds:YES];
        [[imageLocation layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
        
        lblLocation.textColor = SELECTED_COLOR;
    } else {
        lblLocation.text = @"Location";
        imageLocation.frame = CGRectMake(25, 11, 15, 22);
        imageLocation.image = [UIImage imageNamed:@"location-icon.png"];
        lblLocation.textColor = NORMAL_COLOR;
    }
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItems = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = CGRectMake(0, 0, 13, 22);
    return [[UIBarButtonItem alloc] initWithCustomView:btnBack] ;
}

- (NSArray *)rightMenuBarButtonItem {
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, 6, 56, 32);
    [btnDone.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone.titleLabel setTextColor:[UIColor whiteColor]];
    [btnDone addTarget:self action:@selector(rightSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnDone.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:17.0]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = -10;
    
    UIBarButtonItem *rightButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnDone] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, rightButtonItem, nil];
}

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    if (txtOfferTitle.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please enter offer name."
                                                       delegate:Nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
        
    } else if (txtViewThoats.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please describe the offer."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    } else if ([lblLocation.text isEqualToString:@"Location"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select Location."
                                                       delegate:Nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
        
    }
    else if ([lblWorkingTIme.text isEqualToString:@"Start - End Time"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select offer time."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    }
    else if ([lblPrice.text isEqualToString:@"Price"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select price."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    } else if (lblCategory.hidden == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select tags."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
    } else {
        [self callOfferReviewPostData];
    }
}

#pragma mark - UIButton Methods

- (IBAction)btnDoneOverlayAction:(id)sender
{
    [priceOverlay removeFromSuperview];
    lblPrice.text = [NSString stringWithFormat:@"%@ %@", txtPrice.text, [btnCurrency titleForState:UIControlStateNormal]];
    lblPrice.textColor = SELECTED_COLOR;
    [btnClearPrice setHidden:NO];
}

- (IBAction)btnCurrencySelectionAction:(id)sender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Ccy == %@", [btnCurrency titleForState:UIControlStateNormal]];
    NSArray *filArray = [self.pickerData filteredArrayUsingPredicate:predicate];
    if ([filArray count]>0) {
        NSInteger index = [self.pickerData indexOfObject:[filArray objectAtIndex:0]];
        [picker selectRow:index inComponent:0 animated:YES];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.7] ;
    if (IS_IPHONE_5) {
        pickerView.center = CGPointMake(self.view.center.x, 440);
    } else {
        pickerView.center = CGPointMake(self.view.center.x, 400);
    }
    [UIView commitAnimations];
}

- (IBAction)btnDonePickerViewAction:(id)sender
{
    NSDictionary *dictData = [pickerData objectAtIndex:[picker selectedRowInComponent:0]];
    [btnCurrency setTitle:[dictData objectForKey:@"Ccy"] forState:UIControlStateNormal];
    [btnCurrency setTitle:[dictData objectForKey:@"Ccy"] forState:UIControlStateHighlighted];
    
    CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGPoint offScreenCenter = CGPointZero;
	offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationDelegate:self];
	pickerView.center = offScreenCenter;
	[UIView commitAnimations];
}

- (IBAction)btnCancelPickerViewAction:(id)sender
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

- (IBAction)btnLocationAction:(id)sender
{
    AddLocation_IPhone5 *viewController = [[AddLocation_IPhone5 alloc] initWithNibName:@"AddLocation_IPhone5" bundle:nil];
    viewController.iParentView = kOfferView;
    viewController.objOfferView = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnStartEndTimeAction:(id)sender
{
    [EventTimeSelectionOverlay showAlert:nil delegate:self withTag:1];
}

- (IBAction)btnSharePictureAction:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:appname delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Take a Photo", @"Take from Gallery",nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
    [action release];
}

- (IBAction)btnPriceAction:(id)sender
{
    [self overLayViewInfo];
}

- (IBAction)btnSelectCategoryAction:(id)sender
{
    overlayTag = 2;
    [CategorySelectionOverlay showAlert:nil delegate:self withTag:1];
}

- (IBAction)btnClearCategorySelection:(id)sender
{
    [arrCategoryId removeAllObjects];
    for (UIButton *button in [tagSection subviews]) {
        if (button.tag == 1001) {
            [button removeFromSuperview];
        }
    }
    
    lblCategory.hidden = NO;
    [btnClearCategory setHidden:YES];
}

- (IBAction)btnClearTimeSelection:(id)sender
{
    lblWorkingTIme.textColor = NORMAL_COLOR;
    lblWorkingTIme.text = @"Start - End Time";
    
    startEventTime = @"";
    endEventTime = @"";
    [btnClearTime setHidden:YES];
}

- (IBAction)btnClearLinkSelection:(id)sender
{
    lblLink.textColor = NORMAL_COLOR;
    lblLink.text = @"Link (optional)";
    [btnClearLink setHidden:YES];
}

- (IBAction)btnClearPrice:(id)sender
{
    lblPrice.text = @"Price";
    lblPrice.textColor = NORMAL_COLOR;
    txtPrice.text = @"";
    [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateNormal];
    [btnCurrency setTitle:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode] forState:UIControlStateHighlighted];
    [btnClearPrice setHidden:YES];
}

- (IBAction)btnLinkAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                    message:@"Please enter link."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *txtLink = [alert textFieldAtIndex:0];
    txtLink.keyboardType = UIKeyboardTypeURL;
    txtLink.placeholder = @"http://";
    txtLink.textColor = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:66.0/255.0 alpha:1.0];
    if ([txtLink respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtLink.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtLink.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    if ([lblLink.text isEqualToString:@"Link (optional)"]) {
    } else {
        txtLink.text = lblLink.text;
    }
    
    [alert show];
}



-(IBAction)onKeyReturn:(id)sender
{
    [txtViewThoats resignFirstResponder];
    [txtOfferTitle resignFirstResponder];
    [txtPrice resignFirstResponder];
}

#pragma mark - Web service call Methods

- (void)callOfferReviewPostData
{
    [appDelegate showActivity:self.view showOrHide:YES];
    
    for(UIBarButtonItem *rightButton in self.navigationItem.rightBarButtonItems){
        [rightButton setEnabled:NO];
    }
    
    NSString *strTagID = @"";
    for (int i = 0; i < [arrCategoryId count]; i++) {
        if (i == [arrCategoryId count]-1) {
            strTagID = [strTagID stringByAppendingFormat:@"%@", [arrCategoryId objectAtIndex:i]];
        } else {
            strTagID = [strTagID stringByAppendingFormat:@"%@,", [arrCategoryId objectAtIndex:i]];
        }
    }
    
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"add_place_review" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:@"3" forKey:@"type"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:lblLocation.text forKey:@"location_name"];
    [request setPostValue:[NSString stringWithFormat:@"%f", venue.location.coordinate.latitude] forKey:@"lattitude"];
    [request setPostValue:[NSString stringWithFormat:@"%f", venue.location.coordinate.longitude] forKey:@"longitude"];
    [request setPostValue:venue.location.city forKey:@"city"];
    [request setPostValue:venue.location.state forKey:@"state"];
    [request setPostValue:venue.location.country forKey:@"country"];
    [request setPostValue:venue.venueId forKey:@"FoursqaureVenueID"];
    [request setPostValue:venue.categoryType forKey:@"LocationCategoryType"];
    [request setPostValue:venue.location.address forKey:@"address"];
    
    if (txtViewThoats.text.length > 0) {
        [request setPostValue:txtViewThoats.text forKey:@"desc_place"];
    } else {
        [request setPostValue:@"" forKey:@"desc_place"];
    }
    
    [request setPostValue:txtOfferTitle.text forKey:@"event_name"];
    
    if ([lblWorkingTIme.text isEqualToString:@"Start - End Time"]) {
        [request setPostValue:@"" forKey:@"event_start"];
        [request setPostValue:@"" forKey:@"event_end"];
    } else {
        NSArray *eventTime = [lblWorkingTIme.text componentsSeparatedByString:@" - "];
        if ([eventTime count] > 0) {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
            NSDate *start = [dateFormatter dateFromString:startEventTime];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [request setPostValue:[dateFormatter stringFromDate:start] forKey:@"event_start"];
        } else {
            [request setPostValue:@"" forKey:@"event_start"];
        }
        
        if ([eventTime count] > 1) {
            NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
            NSDate *end = [dateFormatter dateFromString:endEventTime];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [request setPostValue:[dateFormatter stringFromDate:end] forKey:@"event_end"];
        } else {
            [request setPostValue:@"" forKey:@"event_end"];
        }
    }
    
    
    
    [request setPostValue:venue.rating forKey:@"rating"];
    if (lblLink.text.length > 0 && ![lblLink.text isEqualToString:@"Link (optional)"]) {
        [request setPostValue:lblLink.text forKey:@"link"];
    } else {
        [request setPostValue:@"" forKey:@"link"];
    }
    [request setPostValue:strTagID forKey:@"tag_id"];
    [request setPostValue:lblPrice.text forKey:@"price"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    NSMutableArray *temparray =[[NSMutableArray alloc] init];
    if ([self.arrShareImage count] > 0) {
        [request setPostValue:[NSNumber numberWithBool:YES] forKey:@"share_picture"];
        
        for (int i = 0; i < [self.arrShareImage count]; i++) {
            NSData *dataImage = UIImageJPEGRepresentation([[self.arrShareImage objectAtIndex:i] objectForKey:UIImagePickerControllerOriginalImage],1.0);
            
            [temparray addObject:dataImage];
            [request addData:[temparray objectAtIndex:i] withFileName:[NSString stringWithFormat:@"image%d.jpg",i] andContentType:@"image/jpeg" forKey:@"image_file[]"];
        }
    } else {
        [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"share_picture"];
    }
    
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *receivedString = [request responseString];
    NSDictionary *responseObject = [receivedString JSONValue];
    NSDictionary *items = [responseObject objectForKey:@"raws"];
    
    [appDelegate showActivity:self.view showOrHide:NO];
    for(UIBarButtonItem *rightButton in self.navigationItem.rightBarButtonItems){
        [rightButton setEnabled:YES];
    }
    
    NSLog(@"Response ====== %@" ,items);
    if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"001"]) {
        appDelegate.isWallAddedNewPost = YES;
        int back = 1; //Default to go back 2
        int count = [self.navigationController.viewControllers count];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:count-(back+1)] animated:YES];
    } else if ([items isKindOfClass:[NSNull class]]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:@"No network" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:appname message:[[items valueForKey:@"status"] valueForKey:@"error_msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [appDelegate showActivity:self.view showOrHide:NO];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
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


#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textfield = [alertView textFieldAtIndex:0];
        NSLog(@"%@", textfield.text);
        lblLink.text = textfield.text;
        if ([textfield.text length] > 0) {
            lblLink.textColor = [UIColor colorWithRed:136.0/255.0 green:179.0/255.0 blue:199.0/255.0 alpha:1.0];
            [btnClearLink setHidden:NO];
        } else {
            lblLink.textColor = NORMAL_COLOR;
            lblLink.text = @"Link (optional)";
            [btnClearLink setHidden:YES];
        }
    }
}

#pragma mark - Custom Metohd

-(void)updateTextViewSize
{
    CGRect rect = txtViewThoats.frame;
    rect.size.width = txtViewThoats.contentSize.width;
    rect.size.height = txtViewThoats.contentSize.height;
    txtViewThoats.frame = rect;
    
    //NSLog(@"Height ===== %.2f",rect.size.height);
    
    if (offerDescView.frame.size.height < rect.size.height ) {
        CGRect rect1;
        rect1 = offerDescView.frame;
        rect1.size.height = rect1.size.height + 16.0;
        offerDescView.frame = rect1;
        
        CGRect rect2;
        rect2 = offerSectionView.frame;
        rect2.origin.y = rect2.origin.y + 16.0;
        offerSectionView.frame = rect2;
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + 16.0);
        
    } else if (offerDescView.frame.size.height > rect.size.height) {
        CGRect rect1;
        rect1 = offerDescView.frame;
        rect1.size.height = rect1.size.height - 16.0;
        offerDescView.frame = rect1;
        
        CGRect rect2;
        rect2 = offerSectionView.frame;
        rect2.origin.y = rect2.origin.y - 16.0;
        offerSectionView.frame = rect2;
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - 16.0);
    }
}

#pragma mark - Delegate for textview

-(void)textViewDidChange:(UITextView*)textView
{
    float height = textView.contentSize.height;
    //NSLog(@"content size === %f  and new size height === %f", height, lastContentSize);
        if (height >= 66) {
            [UITextView beginAnimations:nil context:nil];
            [UITextView setAnimationDuration:0.5];
    
            CGRect frame = textView.frame;
            frame.size.height = height; //Give it some padding
            textView.frame = frame;
    
            CGRect rect = txtViewThoats.frame;
            if (offerDescView.frame.size.height < rect.size.height) {
                lastContentSize = height;
                [self updateTextViewSize];
            } else if (lastContentSize > height) {
                lastContentSize = height;
                [self updateTextViewSize];
            }
            [UITextView commitAnimations];
        }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGRect frame = scrollView.frame;
    frame.origin.y = -50;
    [scrollView setFrame:frame];
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGRect frame = scrollView.frame;
    frame.origin.y = 0;
    [scrollView setFrame:frame];
    [UIView commitAnimations];
    return YES;
}


#pragma mark - UIActionSheet Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 2) {
        if(buttonIndex == 1) {
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Sorry! No Camera Found !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            } else {
                UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate =self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
        if(buttonIndex == 2) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate =self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
    } else {
        if(buttonIndex == 1) {
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Sorry! No Camera Found !!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            } else {
                UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                imagePicker.delegate =self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
        if(buttonIndex == 2) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
                elcPicker.imagePickerDelegate = self;
                
                [self presentViewController:elcPicker animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - Custom Metohd

- (IBAction)deleteimage:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    [self.arrShareImage removeObjectAtIndex:button.tag];
    
    [self callimagesSetUp];
    
    if ([self.arrShareImage count] == 0) {
        [imageScollView removeFromSuperview];
        
        float height = 45;
        sharePictureSection.frame = CGRectMake(sharePictureSection.frame.origin.x, sharePictureSection.frame.origin.y, sharePictureSection.frame.size.width, height);
        
        imvLine3.frame = CGRectMake(imvLine3.frame.origin.x, height-1, imvLine3.frame.size.width, 0.7);
        height = sharePictureSection.frame.size.height + sharePictureSection.frame.origin.y;
        linkSection.frame = CGRectMake(linkSection.frame.origin.x, height, linkSection.frame.size.width, linkSection.frame.size.height);
        
        height = linkSection.frame.size.height + height;
        tagSection.frame = CGRectMake(tagSection.frame.origin.x, height, tagSection.frame.size.width, tagSection.frame.size.height);
        
        height = tagSection.frame.size.height + height;
        offerSectionView.frame = CGRectMake(offerSectionView.frame.origin.x, offerSectionView.frame.origin.y, offerSectionView.frame.size.width, height);
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, offerSectionView.frame.origin.y+offerSectionView.frame.size.height+10.0);
        
        if ([self.arrShareImage count] > 0) {
            lblSharingPicture.textColor = SELECTED_COLOR;
        } else {
            lblSharingPicture.textColor = NORMAL_COLOR;
        }
    }
}

-(void) callimagesSetUp
{
    for (UIView *v in [imageScollView subviews]) {
        [v removeFromSuperview];
    }
    
	CGRect workingFrame = imageScollView.frame;
	workingFrame.origin.x = 0;
    workingFrame.origin.y = 0;
    
	int index = 0;
	for (NSDictionary *dict in self.arrShareImage) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
		UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
		[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = workingFrame;
		
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(workingFrame.origin.x+280, 0, 17, 17);
        [deleteBtn setImage:[UIImage imageNamed:@"x-icon.png"]forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteimage:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = index;
        
        [imageScollView addSubview:deleteBtn];
		[imageScollView addSubview:imageview];
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        index ++ ;
	}
    
    [imageScollView setPagingEnabled:YES];
	[imageScollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    imageScollView.frame = CGRectMake(10, 55, 300, imageScollView.frame.size.height);
    [sharePictureSection addSubview:imageScollView];
    
    float height = imageScollView.frame.size.height + 45.0 + 20.0;
    sharePictureSection.frame = CGRectMake(sharePictureSection.frame.origin.x, sharePictureSection.frame.origin.y, sharePictureSection.frame.size.width, height);
    
    imvLine3.frame = CGRectMake(imvLine3.frame.origin.x, height-1, imvLine3.frame.size.width, 0.7);
    
    height = sharePictureSection.frame.size.height + sharePictureSection.frame.origin.y;
    linkSection.frame = CGRectMake(linkSection.frame.origin.x, height, linkSection.frame.size.width, linkSection.frame.size.height);
    
    height = linkSection.frame.size.height + height;
    tagSection.frame = CGRectMake(tagSection.frame.origin.x, height, tagSection.frame.size.width, tagSection.frame.size.height);
    
    height = tagSection.frame.size.height + height;
    offerSectionView.frame = CGRectMake(offerSectionView.frame.origin.x, offerSectionView.frame.origin.y, offerSectionView.frame.size.width, height);
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, offerSectionView.frame.origin.y+offerSectionView.frame.size.height+10.0);
    
    if ([self.arrShareImage count] > 0) {
        lblSharingPicture.textColor = SELECTED_COLOR;
    } else {
        lblSharingPicture.textColor = NORMAL_COLOR;
    }
}


#pragma mark - ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.arrShareImage addObjectsFromArray:info];
        [self callimagesSetUp];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIIMagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker1 didFinishPickingImage:(UIImage *)imageSel editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.arrShareImage addObject:editingInfo];
    [self callimagesSetUp];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

#pragma mark - Keyboard Notification

- (void) keyboardWillShow:(NSNotification *)note {
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = self.view.frame;

	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.view.frame = containerFrame;
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.view.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.view.frame = containerFrame;
    [UIView commitAnimations];
}

#pragma mark - Rootview Delegate

-(void)AlertDialogDidComplete:(id)view
{
    if ([view isKindOfClass:[EventTimeSelectionOverlay class]]) {
        EventTimeSelectionOverlay *overlay = (EventTimeSelectionOverlay*)view;
        NSString *startDate = [overlay.btnStartDate titleForState:UIControlStateNormal];
        NSString *startTime = [overlay.btnStartTime titleForState:UIControlStateNormal];
        NSString *endDate = [overlay.btnEndDate titleForState:UIControlStateNormal];
        NSString *endTime = [overlay.btnEndTime titleForState:UIControlStateNormal];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:mm a"];
        NSDate *start = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", startDate, startTime]];
        NSDate *end = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", endDate, endTime]];
        [dateFormatter setDateFormat:@"MMM dd, hh:mm a"];
        
        startEventTime = overlay.startDate;
        endEventTime = overlay.endDate;
        
        lblWorkingTIme.text = [dateFormatter stringFromDate:start];
        if (end) {
            lblWorkingTIme.text = [lblWorkingTIme.text stringByAppendingFormat:@" - \n%@", [dateFormatter stringFromDate:end]];
        }
        
        lblWorkingTIme.textColor = SELECTED_COLOR;
        [btnClearTime setHidden:NO];
        [dateFormatter release];
    } else if ([view isKindOfClass:[CategorySelectionOverlay class]]) {
        CategorySelectionOverlay *overlay1 = (CategorySelectionOverlay*)view;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsSelected == 1"];
        NSArray *arrFiltered = [overlay1.arrCategory filteredArrayUsingPredicate:predicate];
        
        if (arrCategoryId == nil) {
            arrCategoryId = [[NSMutableArray alloc]init];
        }
        [arrCategoryId removeAllObjects];
        
        if ([arrFiltered count] >= 1) {
            for (UIButton *button in [tagSection subviews]) {
                if (button.tag == 1001) {
                    [button removeFromSuperview];
                }
            }
            
            float xOrigin = 63;
            for (int i = 0; i < [arrFiltered count]; i++) {
                NSDictionary *dictData = [arrFiltered objectAtIndex:i];
                
                float width = [[dictData objectForKey:@"category_name"] RAD_textWidthForFontName:@"HelveticaNeue" FontOfSize:14.0 MaxHeight:34.0];
                width = width + 40;
                
                [arrCategoryId addObject:[dictData objectForKey:@"id"]];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(xOrigin, 9, width, 25);
                [button setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:78.0/255.0 blue:77.0/255.0 alpha:1.0]];
                [button setTitle:[dictData objectForKey:@"category_name"] forState:UIControlStateNormal];
                [button setTitle:[dictData objectForKey:@"category_name"] forState:UIControlStateHighlighted];
                [button.titleLabel setFont:[UIFont fontWithName:HELVETICANEUEREGULAR size:14.0]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [[button layer] setCornerRadius:2.0];
                button.tag = 1001;
                
                [tagSection addSubview:button];
                xOrigin = xOrigin + width + 10.0;
            }
            NSLog(@"Array for ID is ===== %@",arrCategoryId);
            lblCategory.hidden = YES;
            [btnClearCategory setHidden:NO];
        }
    }
}

-(void)AlertDialogDidNotComplete:(id)view
{
    
}

#pragma mark - Display Ovrelay

-(void)overLayViewInfo {
    [[[[UIApplication sharedApplication]delegate] window] addSubview:priceOverlay];
    [[imvPriceWhiteBox layer] setCornerRadius:5.0];
    
    if (IS_IPHONE_5) {
        viewDoneButton.frame = CGRectMake(viewDoneButton.frame.origin.x, 504, viewDoneButton.frame.size.width, viewDoneButton.frame.size.height);
    } else {
        viewDoneButton.frame = CGRectMake(viewDoneButton.frame.origin.x, 420, viewDoneButton.frame.size.width, viewDoneButton.frame.size.height);
        
    }
    [[viewDoneButton layer] setCornerRadius:2.5];
    
    priceOverlay.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    priceOverlay.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
}

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    priceOverlay.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    priceOverlay.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

#pragma mark - UITextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.text length] > 0) {
        textField.textColor = SELECTED_COLOR;
    } else {
        textField.textColor = NORMAL_COLOR;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

@end