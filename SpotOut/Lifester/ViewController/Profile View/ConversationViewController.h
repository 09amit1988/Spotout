//
//  ConversationViewController.h
//  Lifester
//
//  Created by MAC240 on 2/14/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AsyncImageView.h"

@interface ConversationViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *imvProfile;
    IBOutlet UIImageView *imvOnlineStatus;
    IBOutlet UILabel *lblProfileName;
    IBOutlet UILabel *lblOnlineStatus;
    IBOutlet UIImageView *imvDivideLine;
    
    IBOutlet UIView *noChatView;
    IBOutlet UIView *addCommentView;
    IBOutlet UITextField *txtComment;
}
@end
