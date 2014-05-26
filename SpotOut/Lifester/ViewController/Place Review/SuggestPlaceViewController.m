//
//  SuggestPlaceViewController.m
//  Lifester
//
//  Created by MAC205 on 08/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "SuggestPlaceViewController.h"
#import "UIImage+Uiimage_Fixorientation.h"
#import "PlaceCategoryCell.h"
#import "JSON.h"
#import "Reachability.h"
#import "ViewController_IPhone5.h"
#import "StringHelper.h"
#import "CategorySelectionOverlay.h"
#import "PlaceDetailViewController.h"

@interface SuggestPlaceViewController ()

@end

@implementation SuggestPlaceViewController

@synthesize arrShareImage, imageScollView;
@synthesize venue;
@synthesize arrImageData;

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
    selectedIndex = -1;
    lastContentSize = 33.0;
    
    self.arrImageData = [[NSMutableArray alloc] init];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Place Review"];
    self.arrShareImage = [[NSMutableArray alloc] init];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 568);
    [self setupMenuBarButtonItems];

    
    [rateSlider setThumbImage: [UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    
    rateview = [[DYRateView alloc] initWithFrame:CGRectMake(65, 12, 234, 30) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
    rateview.alignment = RateViewAlignmentLeft;
    rateview.editable = NO;
    rateview.delegate = self;
    rateview.rate = 0;
    [rateSection addSubview:rateview];
    
    rateviewOverlay = [[DYRateView alloc] initWithFrame:CGRectMake(100, 120, 234, 30) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
    rateviewOverlay.alignment = RateViewAlignmentLeft;
    rateviewOverlay.editable = NO;
    rateviewOverlay.delegate = self;
    rateviewOverlay.rate = 0;
    [viewOverlay addSubview:rateviewOverlay];
    
    lblSharingPicture.textColor = NORMAL_COLOR;
    lblLink.textColor = NORMAL_COLOR;
    
    [btnClearLink setHidden:YES];
    [btnClearRate setHidden:YES];
    [btnClearCategory setHidden:YES];
    
    txtViewThoats.placeholder = @"Thoats about Location";
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
    imvLine2.frame = CGRectMake(imvLine2.frame.origin.x, imvLine2.frame.origin.y, imvLine2.frame.size.width, 0.7);
    imvLine3.frame = CGRectMake(imvLine3.frame.origin.x, imvLine3.frame.origin.y, imvLine3.frame.size.width, 0.7);
    imvLine4.frame = CGRectMake(imvLine4.frame.origin.x, imvLine4.frame.origin.y, imvLine4.frame.size.width, 0.7);
    
    [[viewTop layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[viewTop layer] setBorderWidth:0.7];
    [[viewLocation layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[viewLocation layer] setBorderWidth:0.7];
    [[viewEvent layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[viewEvent layer] setBorderWidth:0.7];
    
    
    [imageLocation setClipsToBounds: YES];
    [[imageLocation layer] setMasksToBounds:YES];
    [[imageLocation layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[imageLocation layer] setBorderWidth:0.0];
    [[imageLocation layer] setCornerRadius:0.0];
    
    [[categoryBackView layer] setCornerRadius:2.5];
    [[viewDoneCategory layer] setCornerRadius:2.5];
    [[viewDoneRating layer] setCornerRadius:2.5];
    
    if (self.venue) {
        lblLocation.text = venue.name;
        if ([venue.locationImage length] > 0) {
            [IconDownloader loadImageFromLink:venue.locationImage forImageView:imageLocation withPlaceholder:nil andContentMode:UIViewContentModeScaleAspectFit];
            imageLocation.frame = CGRectMake(17, 7, 30, 30);
            [[imageLocation layer] setBorderWidth:0.7];
            [[imageLocation layer] setCornerRadius:imageLocation.frame.size.width/2.0];
        } else {
            imageLocation.image = [UIImage imageNamed:@"location-icon1.png"];
            //imageLocation.frame = CGRectMake(25, 11, 15, 22);
            [[imageLocation layer] setBorderWidth:0.0];
        }
        
        [imageLocation setClipsToBounds: YES];
        [[imageLocation layer] setMasksToBounds:YES];
        [[imageLocation layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
        
        lblLocation.textColor = SELECTED_COLOR;
    } else {
        lblLocation.text = @"Location";
        lblLocation.textColor = NORMAL_COLOR;
        imageLocation.frame = CGRectMake(29, 11, 15, 22);
        imageLocation.image = [UIImage imageNamed:@"select-place-icon.png"];
    }

    txtHighlight.textColor = SELECTED_COLOR;
    txtViewThoats.textColor = SELECTED_COLOR;
    lblSliderValue.textColor = NORMAL_COLOR;
    
    [toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar sizeToFit];
    [txtViewThoats setInputAccessoryView:toolBar];
    
    txtViewThoats.placeholderTextColor = NORMAL_COLOR;
    txtViewThoats.textColor = SELECTED_COLOR;
    
    if ([txtHighlight respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtHighlight.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtHighlight.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    self.navigationItem.rightBarButtonItems = [self rightMenuBarButtonItem];
    self.navigationItem.leftBarButtonItems = [self leftMenuBarButtonItem];
}

- (NSArray *)leftMenuBarButtonItem {

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    negativeSpacer.width = 0;
    if (IS_IOS7)
        negativeSpacer.width = 0;
    
    UIButton *btnMainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMainMenu setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    [btnMainMenu addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    btnMainMenu.frame = CGRectMake(0, 0, 13, 22);
    
    UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btnMainMenu] autorelease];
    return [NSArray arrayWithObjects:negativeSpacer, backButtonItem, nil];

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
    
    if (lblLocation.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select Location."
                                                       delegate:Nil
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
        
    } else if (txtViewThoats.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please describe the location."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
        
    } else if ([self.arrShareImage count] <= 0) {
        if ([venue.arrPhotos count] > 0) {
            [self downloadFoursquareImages];
        } else {
            [self callSuggestPlaceReviewPostData:YES];
        }
    } else {
        NSLog(@"Proceed further");
        [self callSuggestPlaceReviewPostData:YES];
    }
}



#pragma mark - Action Method

- (IBAction)SelectImage:(id)sender {
    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:appname delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Take a Photo", @"Take from Gallery",nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
    [action release];
}

- (IBAction)deleteProperties:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    [self.arrShareImage removeObjectAtIndex:button.tag];
}

- (IBAction)btnRateAction:(id)sender
{
    [self overLayViewInfo];
}

- (IBAction)onOverlayviewPressed :(id)sender {
    
    [viewOverlay removeFromSuperview];
    
    int value = ((int)[rateSlider value]/3);
    NSString *string = [NSString stringWithFormat:@"%f",([rateSlider value]/3)];
    if ([string isEqualToString:@"0.333333"]) {
        rateview.rate = ((int)[rateSlider value]/3);
    } else {
        rateview.rate = [rateSlider value]/3;
    }
    [btnClearRate setHidden:NO];
    
    switch (value) {
        case 1:
            lblSliderValue.text = @"";
            break;
        case 2:
            lblSliderValue.text = @"";
            break;
        case 3:
            lblSliderValue.text = @"";
            break;
        case 4:
            lblSliderValue.text = @"";
            break;
        case 5:
            lblSliderValue.text = @"";
            break;
        default:
            break;
    }
    lblSliderValue.textColor = SELECTED_COLOR;
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

- (IBAction)btnClearRateSelection:(id)sender
{
    rateview.rate = 0;
    rateviewOverlay.rate = 0;
    rateSlider.value = 0;
    lblSliderValue.text = @"(optional)";
    lblSliderValue.textColor = NORMAL_COLOR;
    
    [btnClearRate setHidden:YES];
}

- (IBAction)btnClearLinkSelection:(id)sender
{
    lblLink.textColor = NORMAL_COLOR;
    lblLink.text = @"Link (optional)";
    
    [btnClearLink setHidden:YES];
}

- (IBAction)sliderValueChangeAction:(id)sender
{
    NSString *string = [NSString stringWithFormat:@"%f",([rateSlider value]/3)];
    if ([string isEqualToString:@"0.333333"]) {
        rateviewOverlay.rate = ((int)[rateSlider value]/3);
        lblValue.text = @"0";
    } else {
        float floor = round([rateSlider value]);
        rateviewOverlay.rate = floor/3;
    }
}

- (IBAction)btnLocationDetailAction:(id)sender
{
    PlaceDetailViewController *viewController = [[[PlaceDetailViewController alloc] initWithNibName:@"PlaceDetailViewController" bundle:nil] autorelease];
    viewController.venue = self.venue;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnHighlightAction:(id)sender
{
    
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
    }
    
    if ([lblLink.text isEqualToString:@"Link (optional)"]) {
    } else {
        txtLink.text = lblLink.text;
    }
    
    [alert show];
}

- (IBAction)btnSelectCategoryAction:(id)sender
{
    [CategorySelectionOverlay showAlert:@"" delegate:self withTag:1];
    //[self displayCategoryOverlay];
}

- (IBAction)btnClearCategorySelection:(id)sender
{
    [arrCategoryId removeAllObjects];
    for (UIButton *button in [otherSection subviews]) {
        if (button.tag == 1001) {
            [button removeFromSuperview];
        }
    }
    
    lblCategory.hidden = NO;
    [btnClearCategory setHidden:YES];
}

-(IBAction)onKeyReturn:(id)sender
{
    [txtViewThoats resignFirstResponder];
}

-(void)updateTextViewSize
{
    CGRect rect = txtViewThoats.frame;
    rect.size.width = txtViewThoats.contentSize.width;
    rect.size.height = txtViewThoats.contentSize.height;
    txtViewThoats.frame = rect;

    NSLog(@"Height ===== %.2f",rect.size.height);
    if (viewTop.frame.size.height < rect.size.height ) {
        CGRect rect1;
        rect1 = viewTop.frame;
        rect1.size.height = rect1.size.height + 16.0;
        viewTop.frame = rect1;
        
        CGRect rect2;
        rect2 = viewEvent.frame;
        rect2.origin.y = rect2.origin.y + 16.0;
        viewEvent.frame = rect2;
        
    } else if (viewTop.frame.size.height > rect.size.height) {
        CGRect rect1;
        rect1 = viewTop.frame;
        rect1.size.height = rect1.size.height - 16.0;
        viewTop.frame = rect1;
        
        CGRect rect2;
        rect2 = viewEvent.frame;
        rect2.origin.y = rect2.origin.y - 16.0;
        viewEvent.frame = rect2;
    }
}

//implement this delegate method as shown below
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == txtViewThoats) {
        isHighLightTextField = NO;
    }
    return YES;
}

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
        if (viewTop.frame.size.height < rect.size.height) {
            lastContentSize = height;
            [self updateTextViewSize];
        } else if (lastContentSize > height) {
            lastContentSize = height;
            [self updateTextViewSize];
        }
        [UITextView commitAnimations];
    }
}

#pragma mark - Web service call Methods

- (void)downloadFoursquareImages
{
    for(UIBarButtonItem *rightButton in self.navigationItem.rightBarButtonItems){
        [rightButton setEnabled:NO];
    }
    [appDelegate showActivity:self.view showOrHide:YES];
    for (int i = 0; i < [venue.arrPhotos count]; i++) {
        flag = 1;
        ASIHTTPRequest *requestImage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[venue.arrPhotos objectAtIndex:i]]];
        [requestImage setDelegate:self];
        [requestImage startAsynchronous];
    }
}

- (void)callSuggestPlaceReviewPostData:(BOOL)status
{
    if (status) {
        [appDelegate showActivity:self.view showOrHide:YES];
    }
    for(UIBarButtonItem *rightButton in self.navigationItem.rightBarButtonItems){
        [rightButton setEnabled:NO];
    }
    
    flag = 0;
    
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
    [request setPostValue:@"1" forKey:@"type"];
    
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
    
    if (txtViewThoats.text.length > 0) {
        [request setPostValue:txtViewThoats.text forKey:@"desc_place"];
    } else {
        [request setPostValue:@"" forKey:@"desc_place"];
    }
    
    [request setPostValue:venue.rating forKey:@"rating"];
    if (txtHighlight.text.length > 0) {
       [request setPostValue:txtHighlight.text forKey:@"highlights"];
    } else {
       [request setPostValue:@"" forKey:@"highlights"];
    }
    
    if (lblLink.text.length > 0 && ![lblLink.text isEqualToString:@"Link (optional)"]) {
       [request setPostValue:lblLink.text forKey:@"link"];
    } else {
       [request setPostValue:@"" forKey:@"link"];
    }
    [request setPostValue:strTagID forKey:@"tag_id"];
    
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
        if ([self.arrImageData count] > 0) {
            [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"share_picture"];
            
            for (int i = 0; i < [self.arrImageData count]; i++) {
                [request addData:[self.arrImageData objectAtIndex:i] withFileName:[NSString stringWithFormat:@"image%d.jpg",i] andContentType:@"image/jpeg" forKey:@"image_file[]"];
            }
        }
    }
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (flag == 0) {
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
            int back = 2; //Default to go back 2
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
    } else if (flag == 1) {
        NSData *dataImage  = [request responseData];
        [self.arrImageData addObject:dataImage];
        iOperations++;
        if ([venue.arrPhotos count] == iOperations) {
            [self callSuggestPlaceReviewPostData:NO];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    [appDelegate showActivity:self.view showOrHide:NO];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
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
        //highlightSection.frame = CGRectMake(highlightSection.frame.origin.x, height, highlightSection.frame.size.width, highlightSection.frame.size.height);
        
        //height = highlightSection.frame.size.height + height;
        linkSection.frame = CGRectMake(linkSection.frame.origin.x, height, linkSection.frame.size.width, linkSection.frame.size.height);
        
        height = linkSection.frame.size.height + height;
        otherSection.frame = CGRectMake(otherSection.frame.origin.x, height, otherSection.frame.size.width, otherSection.frame.size.height);
        
        height = otherSection.frame.size.height + height;
        viewEvent.frame = CGRectMake(viewEvent.frame.origin.x, viewEvent.frame.origin.y, viewEvent.frame.size.width, height);
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, viewEvent.frame.origin.y+viewEvent.frame.size.height+10.0);
        
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
        deleteBtn.frame = CGRectMake(workingFrame.origin.x+285, 0, 17, 17);
        [deleteBtn setImage:[UIImage imageNamed:@"x-icon.png"]forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteimage:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = index;
        
        [imageScollView addSubview:deleteBtn];
		[imageScollView addSubview:imageview];
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
        index ++ ;
	}
    
    //    self.arrShareImage = images;
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
    otherSection.frame = CGRectMake(otherSection.frame.origin.x, height, otherSection.frame.size.width, otherSection.frame.size.height);
    
    height = otherSection.frame.size.height + height;
    viewEvent.frame = CGRectMake(viewEvent.frame.origin.x, viewEvent.frame.origin.y, viewEvent.frame.size.width, height);
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, viewEvent.frame.origin.y+viewEvent.frame.size.height+10.0);
    
    if ([self.arrShareImage count] > 0) {
        lblSharingPicture.textColor = SELECTED_COLOR;
    } else {
        lblSharingPicture.textColor = NORMAL_COLOR;
    }
}

#pragma mark - ImagePicker Delegate Methods

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

#pragma mark - ImagePicker Delegate Methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

#pragma mark - ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
	[self.arrShareImage addObjectsFromArray:info];
    if (self.arrShareImage.count > 0)
    [self callimagesSetUp];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIIMagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker1 didFinishPickingImage:(UIImage *)imageSel editingInfo:(NSDictionary *)editingInfo {
	[self dismissModalViewControllerAnimated:YES];
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

#pragma mark - Display Ovrelay

-(void)overLayViewInfo {
    [[[[UIApplication sharedApplication]delegate] window] addSubview:viewOverlay];
    
    if (IS_IPHONE_5) {
    } else {
        viewDoneRating.frame = CGRectMake(viewDoneRating.frame.origin.x, 426, viewDoneRating.frame.size.width, viewDoneRating.frame.size.height);
    }
    
    viewOverlay.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    viewOverlay.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
}

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    viewOverlay.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    viewOverlay.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

#pragma mark - Rootview Delegate

-(void)AlertDialogDidComplete:(id)view
{
    CategorySelectionOverlay *overlay = (CategorySelectionOverlay*)view;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsSelected == 1"];
    NSArray *arrFiltered = [overlay.arrCategory filteredArrayUsingPredicate:predicate];
    
    if (arrCategoryId == nil) {
        arrCategoryId = [[NSMutableArray alloc]init];
    }
    [arrCategoryId removeAllObjects];
    
    if ([arrFiltered count] >= 1) {
        
        for (UIButton *button in [otherSection subviews]) {
            if (button.tag == 1001) {
                [button removeFromSuperview];
            }
        }
        
        float xOrigin = 63;
        for (int i = 0; i < [arrFiltered count]; i++) {
            NSDictionary *dictData = [arrFiltered objectAtIndex:i];
            
            float width = [[dictData objectForKey:@"category_name"] RAD_textWidthForFontName:@"HelveticaNeue" FontOfSize:14.0 MaxHeight:25.0];
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
            
            [otherSection addSubview:button];
            xOrigin = xOrigin + width + 10.0;
        }
        
        NSLog(@"Array for ID is ===== %@",arrCategoryId);
        lblCategory.hidden = YES;
        [btnClearCategory setHidden:NO];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select atleast 2 category."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void)AlertDialogDidNotComplete:(id)view
{
    
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
    if (isHighLightTextField) {
        containerFrame.origin.y = (self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height))+80;
    } else {
        //containerFrame.origin.y = (self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height))+160;
    }
    
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


#pragma mark - UItextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtHighlight) {
        isHighLightTextField = YES;
    } else {
        isHighLightTextField = NO;
    }
    
    return YES;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
