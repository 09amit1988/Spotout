//
//  PhotoReviewViewController.m
//  Lifester
//
//  Created by MAC240 on 2/24/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "PhotoReviewViewController.h"
#import "JSON.h"


@interface PhotoReviewViewController ()

@end

@implementation PhotoReviewViewController

@synthesize arrImages,imageScollView,venue;

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Photo Review"];
    self.view.backgroundColor = VIEW_COLOR;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar sizeToFit];
    [txtViewThoats setInputAccessoryView:toolBar];
    
    txtViewThoats.placeholder = @"Describe picture";
    txtViewThoats.placeholderTextColor = NORMAL_COLOR;
    txtViewThoats.textColor = SELECTED_COLOR;
    
    [btnClearLink setHidden:YES];
    [btnClearCategory setHidden:YES];
    lblLink.textColor = NORMAL_COLOR;
    lblCategory.textColor = NORMAL_COLOR;
    lblPicture.textColor = SELECTED_COLOR;
    lblLocation.textColor = NORMAL_COLOR;
    
    txtPictureTitle.textColor = SELECTED_COLOR;
    if ([txtPictureTitle respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtPictureTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtPictureTitle.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    }

    [self setupMenuBarButtonItems];
    [self imageSetUp];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, 568);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
    imvLine2.frame = CGRectMake(imvLine2.frame.origin.x, imvLine2.frame.origin.y, imvLine2.frame.size.width, 0.7);
    imvLine3.frame = CGRectMake(imvLine3.frame.origin.x, imvLine3.frame.origin.y, imvLine3.frame.size.width, 0.7);
    
    [[otherSectionView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[otherSectionView layer] setBorderWidth:0.7];
    
    [[photoDescView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[photoDescView layer] setBorderWidth:0.7];
    
    [[TitleView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[TitleView layer] setBorderWidth:0.7];
    
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
    if (txtPictureTitle.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please enter picture title."
                                                       delegate:Nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
        
    } else if (txtViewThoats.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please describe the picture."
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
        [self callPhotoReviewPostData];
    }
}

#pragma mark - UIButton Methods

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
    }
    
    if ([lblLink.text isEqualToString:@"Link (optional)"]) {
    } else {
        txtLink.text = lblLink.text;
    }
    
    [alert show];
}

- (IBAction)btnLocationAction:(id)sender
{
    AddLocation_IPhone5 *viewController = [[AddLocation_IPhone5 alloc] initWithNibName:@"AddLocation_IPhone5" bundle:nil];
    viewController.iParentView = kPhotoView;
    viewController.objPhotoView = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnSelectCategoryAction:(id)sender
{
    [CategorySelectionOverlay showAlert:nil delegate:self withTag:1];
}

- (IBAction)btnClearLinkSelection:(id)sender
{
    lblLink.textColor = NORMAL_COLOR;
    lblLink.text = @"Link (optional)";
    
    [btnClearLink setHidden:YES];
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

#pragma mark - Rootview Delegate

-(void)AlertDialogDidComplete:(id)view
{
    CategorySelectionOverlay *overlay1 = (CategorySelectionOverlay*)view;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsSelected == 1"];
    NSArray *arrFiltered = [overlay1.arrCategory filteredArrayUsingPredicate:predicate];
    
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
            
            [otherSection addSubview:button];
            xOrigin = xOrigin + width + 10.0;
        }
        //NSLog(@"Array for ID is ===== %@",arrCategoryId);
        lblCategory.hidden = YES;
        [btnClearCategory setHidden:NO];
    }
}

#pragma mark - Custom Metohd

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
    
    if (photoDescView.frame.size.height < rect.size.height ) {
        CGRect rect1;
        rect1 = photoDescView.frame;
        rect1.size.height = rect1.size.height + 16.0;
        photoDescView.frame = rect1;
        
        CGRect rect2;
        rect2 = otherSectionView.frame;
        rect2.origin.y = rect2.origin.y + 16.0;
        otherSectionView.frame = rect2;
    } else if (photoDescView.frame.size.height > rect.size.height) {
        CGRect rect1;
        rect1 = photoDescView.frame;
        rect1.size.height = rect1.size.height - 16.0;
        photoDescView.frame = rect1;
        
        CGRect rect2;
        rect2 = otherSectionView.frame;
        rect2.origin.y = rect2.origin.y - 16.0;
        otherSectionView.frame = rect2;
    }
}

#pragma mark - Web service call Methods

- (void)callPhotoReviewPostData
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
    [request setPostValue:@"5" forKey:@"type"];
    
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
    
    [request setPostValue:@"" forKey:@"event_name"];
    [request setPostValue:txtPictureTitle.text forKey:@"picture_name"];
    [request setPostValue:venue.rating forKey:@"rating"];
    if (lblLink.text.length > 0 && ![lblLink.text isEqualToString:@"Link (optional)"]) {
        [request setPostValue:lblLink.text forKey:@"link"];
    } else {
        [request setPostValue:@"" forKey:@"link"];
    }
    [request setPostValue:strTagID forKey:@"tag_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    NSMutableArray *temparray =[[NSMutableArray alloc] init];
    if ([self.arrImages count] > 0) {
        [request setPostValue:[NSNumber numberWithBool:YES] forKey:@"share_picture"];
        
        for (int i = 0; i < [self.arrImages count]; i++) {
            NSData *dataImage = UIImageJPEGRepresentation([[self.arrImages objectAtIndex:i] objectForKey:UIImagePickerControllerOriginalImage],1.0);
            
            [temparray addObject:dataImage];
            [request addData:[temparray objectAtIndex:i] withFileName:[NSString stringWithFormat:@"image%d.jpg",i] andContentType:@"image/jpeg" forKey:@"image_file[]"];
        }
    } else {
        [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"share_picture"];
    }
    
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request {
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

#pragma mark - Delegate for textview

-(void)textViewDidChange:(UITextView*)textView
{
    float height = textView.contentSize.height;
    if (height >= 66) {
        [UITextView beginAnimations:nil context:nil];
        [UITextView setAnimationDuration:0.5];
        
        CGRect frame = textView.frame;
        frame.size.height = height; //Give it some padding
        textView.frame = frame;
        
        CGRect rect = txtViewThoats.frame;
        if (photoDescView.frame.size.height < rect.size.height) {
            lastContentSize = height;
            [self updateTextViewSize];
        } else if (lastContentSize > height) {
            lastContentSize = height;
            [self updateTextViewSize];
        }
        [UITextView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Custom Metohd

-(void)imageSetUp
{
    for (UIView *v in [imageScollView subviews]) {
        [v removeFromSuperview];
    }
    
	CGRect workingFrame = imageScollView.frame;
	workingFrame.origin.x = 0;
    workingFrame.origin.y = 0;
    
	int index = 0;
	for (NSDictionary *dict in self.arrImages) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
		UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
		//[imageview setContentMode:UIViewContentModeScaleAspectFit];
		imageview.frame = CGRectMake(workingFrame.origin.x, workingFrame.origin.y, 85, 80);
		
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(workingFrame.origin.x+85, 0, 17, 17);
        [deleteBtn setImage:[UIImage imageNamed:@"x-icon.png"]forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteimage:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = index;
        
       // [imageScollView addSubview:deleteBtn];
		[imageScollView addSubview:imageview];
		workingFrame.origin.x = workingFrame.origin.x + 85 + 10;
        index ++ ;
	}
    
    //    self.arrShareImage = images;
	[imageScollView setPagingEnabled:YES];
	[imageScollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    imageScollView.frame = CGRectMake(imageScollView.frame.origin.x, imageScollView.frame.origin.y, 258, imageScollView.frame.size.height);
    //[self.view addSubview:imageScollView];

}

@end
