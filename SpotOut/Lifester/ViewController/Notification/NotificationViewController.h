//
//  NotificationViewController.h
//  Lifester
//
//  Created by Nikunj on 1/6/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

@interface NotificationViewController : UIViewController
{
    StyledPageControl *pageControl;
}

- (IBAction)btnNotificationAction:(id)sender;
- (IBAction)btnMessagesAction:(id)sender;


@end
