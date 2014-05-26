//
//  InviteFacebookFriendViewController.h
//  Lifester
//
//  Created by Nikunj on 12/18/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "CustomNaviView.h"


@interface InviteFacebookFriendViewController : UIViewController
{
    IBOutlet UIView *backgroundView;
    IBOutlet UIButton *buttonInviteFbFriend;
    
    AppDelegate *appDelegateObj;
    CustomNaviView *customnavi;
}

- (IBAction)btnInviteFriendAction:(id)sender;


@end
