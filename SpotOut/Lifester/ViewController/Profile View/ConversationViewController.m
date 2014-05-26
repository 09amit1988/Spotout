//
//  ConversationViewController.m
//  Lifester
//
//  Created by MAC240 on 2/14/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Conversation"];
    self.view.backgroundColor = VIEW_COLOR;
    
    [self setupMenuBarButtonItems];
    
    lblOnlineStatus.textColor = NORMAL_COLOR;
    [[self.view layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[self.view layer] setBorderWidth:1.0];
    [[addCommentView layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[addCommentView layer] setBorderWidth:1.0];
    imvDivideLine.frame = CGRectMake(imvDivideLine.frame.origin.x, imvDivideLine.frame.origin.y, imvDivideLine.frame.size.width, 0.7);
    
    txtComment.textColor = SELECTED_COLOR;
    if ([txtComment respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        txtComment.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtComment.placeholder attributes:@{NSForegroundColorAttributeName: NORMAL_COLOR}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    lblProfileName.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"profileName"];
    
    [imvProfile setClipsToBounds: YES];
    [[imvProfile layer] setMasksToBounds:YES];
    [[imvProfile layer] setBorderColor:[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor]];
    [[imvProfile layer] setBorderWidth:1.0];
    [[imvProfile layer] setCornerRadius:imvProfile.frame.size.width/2];
    imvProfile.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ProfImage"]]];
}

#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
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

#pragma mark - UIBarButtonItem Callbacks

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action Callbacks



#pragma mark - Custom Call


#pragma mark - Keyboard Notification

- (void) keyboardWillShow:(NSNotification *)note {
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = addCommentView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    addCommentView.frame = containerFrame;
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = addCommentView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    addCommentView.frame = containerFrame;
    [UIView commitAnimations];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
