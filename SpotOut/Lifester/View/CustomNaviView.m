//
//  CustomNaviView.m
//  MediaApp
//
//  Created by Nikunj on 12/26/13.
//  Copyright (c) 2013 Jitendra. All rights reserved.
//

#import "CustomNaviView.h"
#import "NotificationViewController.h"
#import "FrinedReuqestViewController.h"
#import "InvitationsViewController.h"
#import "MFSideMenu.h"
#import "SearchViewController.h"

@implementation CustomNaviView

@synthesize btnFriendRequest;
@synthesize btnInvitations;
@synthesize btnNotifications;
@synthesize lblDate;
@synthesize viewController;
@synthesize iscomingfromInvite;

#pragma mark - Life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor redColor];
        
        btnInvitations = [UIButton buttonWithType:UIButtonTypeCustom]; // chat_normal.png | chat_select.png
        btnInvitations.frame = CGRectMake(18, 12, 22, 22);
        [btnInvitations setImage:[UIImage imageNamed:@"event-icon.png"] forState:UIControlStateNormal];
        [btnInvitations setImage:[UIImage imageNamed:@"event-icon-marked.png"] forState:UIControlStateSelected];
        lblDate = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 22, 17)];
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.textColor = NAVI_BARTINTCOLOR;
    
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd"];
        NSString *dateNumber = [dateFormatter stringFromDate:[NSDate date]];
        lblDate.text = dateNumber;
        lblDate.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:15.0];
        lblDate.textAlignment = NSTextAlignmentCenter;
        [self.btnInvitations addSubview:lblDate];
        [btnInvitations addTarget:self action:@selector(btnInvitationsAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btnFriendRequest = [UIButton buttonWithType:UIButtonTypeCustom]; // user_request_none.png | user_request_select.png
        btnFriendRequest.frame = CGRectMake(62, 12, 22, 22);
        [btnFriendRequest setImage:[UIImage imageNamed:@"nav-search icon-white.png"] forState:UIControlStateNormal];
        [btnFriendRequest setImage:[UIImage imageNamed:@"nav-search icon-blue.png"] forState:UIControlStateSelected];
        [btnFriendRequest addTarget:self action:@selector(btnFriendRequestAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btnNotifications = [UIButton buttonWithType:UIButtonTypeCustom]; // notification_normal.png | notification_select.png
        btnNotifications.frame = CGRectMake(106, 13, 20, 22);
        [btnNotifications setImage:[UIImage imageNamed:@"notification-icon-marked.png"] forState:UIControlStateSelected];
        [btnNotifications setImage:[UIImage imageNamed:@"notification-icon.png"] forState:UIControlStateNormal];
        [btnNotifications addTarget:self action:@selector(btnNotificationsAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btnFriendRequest];
        [self addSubview:btnInvitations];
        [self addSubview:btnNotifications];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIButton Methods

- (void)btnFriendRequestAction:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CRNavigationController *naviController = viewController.menuContainerViewController.centerViewController;
    //NSLog(@"ViewController ==== %@", naviController.viewControllers);
    if (btnFriendRequest.selected == YES) {
        btnFriendRequest.selected = NO;
        
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:naviController.viewControllers];
        [array removeLastObject];
        naviController.viewControllers = array;
    } else {
        btnFriendRequest.selected = YES;
        
        SearchViewController *myProfileObj = [[SearchViewController alloc] init];
        if (appDelegate.IsNewFacebookRegistration) {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1],[naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], [naviController.viewControllers objectAtIndex:4], myProfileObj, nil];
            naviController.viewControllers = controllers;
        } else {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1],[naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], myProfileObj, nil];
            naviController.viewControllers = controllers;
        }
    }
}

- (void)btnInvitationsAction:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CRNavigationController *naviController = viewController.menuContainerViewController.centerViewController;
    //NSLog(@"ViewController ==== %@", naviController.viewControllers);
    if (btnInvitations.isSelected) {
        btnInvitations.selected = NO;
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:naviController.viewControllers];
        [array removeLastObject];
        naviController.viewControllers = array;
    } else {
        btnInvitations.selected = YES;
        
        InvitationsViewController *myProfileObj = [[InvitationsViewController alloc] init];
        if (appDelegate.IsNewFacebookRegistration) {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1],[naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], [naviController.viewControllers objectAtIndex:4], myProfileObj, nil];
            naviController.viewControllers = controllers;
        } else {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1],[naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], myProfileObj, nil];
            naviController.viewControllers = controllers;
        }
    }
}

- (void)btnNotificationsAction:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CRNavigationController *naviController = viewController.menuContainerViewController.centerViewController;
    //NSLog(@"ViewController ==== %@", naviController.viewControllers);
    if (btnNotifications.selected == YES) {
        btnNotifications.selected = NO;
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:naviController.viewControllers];
        [array removeLastObject];
        naviController.viewControllers = array;
    } else {
        btnNotifications.selected = YES;
        NotificationViewController *myProfileObj = [[NotificationViewController alloc] init];
        if (appDelegate.IsNewFacebookRegistration) {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1],[naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], [naviController.viewControllers objectAtIndex:4], myProfileObj, nil];
            naviController.viewControllers = controllers;
        } else {
            NSArray *controllers = [NSArray arrayWithObjects:[naviController.viewControllers objectAtIndex:0],
                                    [naviController.viewControllers objectAtIndex:1],[naviController.viewControllers objectAtIndex:2], [naviController.viewControllers objectAtIndex:3], myProfileObj, nil];
            naviController.viewControllers = controllers;
        }
    }
}


@end
