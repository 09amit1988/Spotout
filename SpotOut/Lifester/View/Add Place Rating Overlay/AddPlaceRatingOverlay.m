//
//  AddPlaceRatingOverlay.m
//  Lifester
//


#import <QuartzCore/QuartzCore.h>
#import "AddPlaceRatingOverlay.h"
#import "Reachability.h"
#import "JSON.h"

@implementation AddPlaceRatingOverlay

@synthesize viewDoneButton;
@synthesize txtComment;
@synthesize rateView;
@synthesize rateSlider;
@synthesize toolBar;
@synthesize appDelegate;
@synthesize lifeFeedPost;
@synthesize parentView;
@synthesize averageRating;
@synthesize tipsView;
@synthesize imvWhiteBox;

+ (void)showAlert:(LifeFeedPost*)feedPost delegate:(id)sender withParentView:(UIView*)view withTag:(NSInteger)iTag
{
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"AddPlaceRatingOverlay" bundle:[NSBundle mainBundle]];
    AddPlaceRatingOverlay *alert = (AddPlaceRatingOverlay *)controller.view;
    alert.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    alert.lifeFeedPost = feedPost;
    alert.parentView = view;
    alert.tag = iTag;
    alert.averageRating = feedPost.averageRating;
    
    alert.rateView = [[DYRateView alloc] initWithFrame:CGRectMake(97, 76, 125, 30) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
    alert.rateView.alignment = RateViewAlignmentCenter;
    alert.rateView.editable = NO;
    //alert.rateView.delegate = self;
    alert.rateView.rate = 0;
    [alert addSubview:alert.rateView];
    [alert.rateSlider setThumbImage: [UIImage imageNamed:@"slider.png"] forState:UIControlStateNormal];
    
    if (IS_IPHONE_5) {
        alert.viewDoneButton.frame = CGRectMake(alert.viewDoneButton.frame.origin.x, 504, alert.viewDoneButton.frame.size.width, alert.viewDoneButton.frame.size.height);
    } else {
        alert.viewDoneButton.frame = CGRectMake(alert.viewDoneButton.frame.origin.x, 456, alert.viewDoneButton.frame.size.width, alert.viewDoneButton.frame.size.height);
    }
    
    alert.txtComment.placeholder = @"Add tip (optional)";
    [[alert.viewDoneButton layer] setCornerRadius:2.5];
    
    [alert.toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [alert.toolBar setBackgroundImage:[UIImage imageNamed:@"Pickerbar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [alert.toolBar sizeToFit];
    [alert.txtComment setInputAccessoryView:alert.toolBar];
    
    alert.txtComment.placeholderTextColor = NORMAL_COLOR;
    alert.txtComment.textColor = SELECTED_COLOR;
    
    [[alert.tipsView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[alert.tipsView layer] setBorderWidth:0.9];
    [[alert.tipsView layer] setCornerRadius:3.0];
    
    [alert.imvWhiteBox setBackgroundColor:[UIColor whiteColor]];
    [[alert.imvWhiteBox layer] setCornerRadius:5.0];
    
    alert.delegate = sender;
	[alert show];
	[controller release];
}


#pragma mark - Action Method

- (IBAction)sliderValueChangeAction:(id)sender
{
    NSString *string = [NSString stringWithFormat:@"%f",([rateSlider value]/3)];
    if ([string isEqualToString:@"0.333333"]) {
        rateView.rate = ((int)[rateSlider value]/3);
    } else {
        float floor = round([rateSlider value]);
        rateView.rate = floor/3;
    }
}

- (IBAction)btnDoneOverlayAction:(id)sender
{
    NSLog(@"Rating ==== %f", [rateSlider value]/3);
    if (([rateSlider value]/3) < 0.33) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please first select rating."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    [dictParam setValue:[NSString stringWithFormat:@"%@", self.lifeFeedPost.placeReviewID] forKey:@"places_review_id"];
    [dictParam setValue:[NSString stringWithFormat:@"%.2f", rateView.rate] forKey:@"rating"];
    [dictParam setValue:txtComment.text forKey:@"tips_comment"];
    [dictParam setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"comment_user_id"];
    
    [appDelegate showActivity:self.parentView showOrHide:YES];
    AddLocationPlaceRating *placeRating = [[AddLocationPlaceRating alloc] init];
    placeRating._delegate = self;
    [placeRating callAddLocationPlaceRatingWebService:dictParam];
}

- (void)dismissOverlayAction
{
    [self dismissWithSuccess:YES animated:YES childView:self];
}

- (IBAction)btnDoneHideKetboardAction:(id)sender
{
    [txtComment resignFirstResponder];
}

#pragma mark - AddLocationPlaceRatingDelegate Methods

- (void)requestFinishedWithSuccess:(ASIHTTPRequest *)request
{
    NSString *receivedString = [request responseString];
    
    NSDictionary *responseObject = [receivedString JSONValue];
    NSDictionary *items = [responseObject objectForKey:@"raws"];
    
    if ([[[items valueForKey:@"status"] valueForKey:@"status_code"] isEqualToString:@"001"]) {
        self.averageRating = [[[items valueForKey:@"status"] valueForKey:@"Average_rating"] floatValue];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:appname
                                                            message:@"Place rating added successfully."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    }
    
    [appDelegate showActivity:self.parentView showOrHide:NO];
    [self dismissWithSuccess:YES animated:YES childView:self];
}

- (void)requestFinishedWithFailed:(ASIHTTPRequest *)request
{
    [appDelegate showActivity:self.parentView showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    [self dismissWithError:request.error animated:YES];
}

#pragma mark - TextView Delegate

-(void)textViewDidChange:(UITextView*)textView
{
    float height = textView.contentSize.height;
    //NSLog(@"content size === %f  and new size height === %f", height, lastContentSize);
    if (height >= 33) {
        [UITextView beginAnimations:nil context:nil];
        [UITextView setAnimationDuration:0.5];
        
        CGRect frame = textView.frame;
        frame.size.height = height; //Give it some padding
        textView.frame = frame;
        
        
        CGRect rect = txtComment.frame;
        if (tipsView.frame.size.height < rect.size.height) {
            lastContentSize = height;
            [self updateTextViewSize];
        } else if (lastContentSize > height) {
            lastContentSize = height;
            [self updateTextViewSize];
        }
        [UITextView commitAnimations];
    }
}

-(void)updateTextViewSize
{
    CGRect rect = txtComment.frame;
    rect.size.width = txtComment.contentSize.width;
    rect.size.height = txtComment.contentSize.height;
    txtComment.frame = rect;
    
    //NSLog(@"Height ===== %.2f",rect.size.height);
    
    if (tipsView.frame.size.height < rect.size.height ) {
        CGRect rect1;
        rect1 = tipsView.frame;
        rect1.size.height = rect1.size.height + 16.0;
        tipsView.frame = rect1;
        
        CGRect rect2;
        rect2 = imvWhiteBox.frame;
        rect2.size.height = rect2.size.height + 16.0;
        imvWhiteBox.frame = rect2;
    } else if (tipsView.frame.size.height > rect.size.height) {
        CGRect rect1;
        rect1 = tipsView.frame;
        rect1.size.height = rect1.size.height - 16.0;
        tipsView.frame = rect1;
        
        CGRect rect2;
        rect2 = imvWhiteBox.frame;
        rect2.size.height = rect2.size.height - 16.0;
        imvWhiteBox.frame = rect2;
    }
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
