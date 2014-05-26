//
//  TextReviewViewController.m
//  Lifester
//
//  Created by MAC240 on 2/24/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "TextReviewViewController.h"
#import "JSON.h"

@interface TextReviewViewController ()

@end

@implementation TextReviewViewController

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
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Text Review"];
    self.view.backgroundColor = VIEW_COLOR;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar sizeToFit];
    [txtViewThoats setInputAccessoryView:toolBar];
    
    txtViewThoats.placeholder = @"Write something...";
    txtViewThoats.placeholderTextColor = NORMAL_COLOR;
    txtViewThoats.textColor = SELECTED_COLOR;

    
    [self setupMenuBarButtonItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [btnClearLink setHidden:YES];
    [btnClearCategory setHidden:YES];
    lblLink.textColor = NORMAL_COLOR;
    lblCategory.textColor = NORMAL_COLOR;
    
    imvLine1.frame = CGRectMake(imvLine1.frame.origin.x, imvLine1.frame.origin.y, imvLine1.frame.size.width, 0.7);
    
    [[otherSection layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[otherSection layer] setBorderWidth:0.7];
    
    [[textDescView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[textDescView layer] setBorderWidth:0.7];
    
    self.navigationController.navigationBarHidden = NO;
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
    if (txtViewThoats.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please enter the text."
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
        [self calltextReviewPostData];
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

#pragma mark - Web service call Methods

- (void)calltextReviewPostData
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
    [request setPostValue:@"4" forKey:@"type"];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    
    [request setPostValue:@"" forKey:@"location_name"];
    [request setPostValue:@"" forKey:@"lattitude"];
    [request setPostValue:@"" forKey:@"longitude"];
    [request setPostValue:@"" forKey:@"city"];
    [request setPostValue:@"" forKey:@"state"];
    [request setPostValue:@"" forKey:@"country"];
    [request setPostValue:@"" forKey:@"FoursqaureVenueID"];
    [request setPostValue:@"" forKey:@"LocationCategoryType"];
    
    if (txtViewThoats.text.length > 0) {
        [request setPostValue:txtViewThoats.text forKey:@"desc_place"];
    } else {
        [request setPostValue:@"" forKey:@"desc_place"];
    }
    
    if (lblLink.text.length > 0 && ![lblLink.text isEqualToString:@"Link (optional)"]) {
        [request setPostValue:lblLink.text forKey:@"link"];
    } else {
        [request setPostValue:@"" forKey:@"link"];
    }
    
    [request setPostValue:@"" forKey:@"event_name"];
    [request setPostValue:@"" forKey:@"event_start"];
    [request setPostValue:@"" forKey:@"event_end"];
    [request setPostValue:@"" forKey:@"rating"];
    
    [request setPostValue:strTagID forKey:@"tag_id"];
    [request setPostValue:[NSNumber numberWithBool:NO] forKey:@"share_picture"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
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
            button.frame = CGRectMake(xOrigin, 54, width, 25);
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
    
    if (textDescView.frame.size.height < rect.size.height ) {
        CGRect rect1;
        rect1 = textDescView.frame;
        rect1.size.height = rect1.size.height + 16.0;
        textDescView.frame = rect1;
        
        CGRect rect2;
        rect2 = otherSection.frame;
        rect2.origin.y = rect2.origin.y + 16.0;
        otherSection.frame = rect2;
    } else if (textDescView.frame.size.height > rect.size.height) {
        CGRect rect1;
        rect1 = textDescView.frame;
        rect1.size.height = rect1.size.height - 16.0;
        textDescView.frame = rect1;
        
        CGRect rect2;
        rect2 = otherSection.frame;
        rect2.origin.y = rect2.origin.y - 16.0;
        otherSection.frame = rect2;
    }
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
        if (textDescView.frame.size.height < rect.size.height) {
            lastContentSize = height;
            [self updateTextViewSize];
        } else if (lastContentSize > height) {
            lastContentSize = height;
            [self updateTextViewSize];
        }
        [UITextView commitAnimations];
    }
}



@end
