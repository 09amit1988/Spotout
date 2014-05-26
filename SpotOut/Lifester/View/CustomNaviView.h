//
//  CustomNaviView.h
//  MediaApp
//
//  Created by Nikunj on 12/26/13.
//  Copyright (c) 2013 Jitendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CustomNaviView : UIView
{
    UIButton *btnFriendRequest;
    UIButton *btnNotifications;
    UIButton *btnInvitations;
    UILabel *lblDate;
}
@property (nonatomic, retain) UIButton *btnFriendRequest;
@property (nonatomic, retain) UIButton *btnNotifications;
@property (nonatomic, retain) UIButton *btnInvitations;
@property (nonatomic, retain) UILabel *lblDate;

@property (nonatomic,assign) BOOL iscomingfromInvite;
@property (nonatomic, retain) UIViewController *viewController;

//+ (id)sharedInstance;

@end
