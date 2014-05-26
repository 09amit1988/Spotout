//
//  MoreViewController.h
//  Lifester
//
//  Created by MAC240 on 5/6/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface MoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView *tableHeaderView;
    IBOutlet UITableView *tblMore;
    
    IBOutlet UILabel *lblProfileName;
    IBOutlet UILabel *lblUsername;
    IBOutlet UIImageView *imvProfileImage;
    IBOutlet FXBlurView *blurView;
}

- (IBAction)btnProfileViewAction:(id)sender;

@end
