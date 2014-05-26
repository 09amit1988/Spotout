//
//  NearFriendViewController.h
//  Lifester
//
//  Created by Nikunj on 12/30/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewProfileMainCell.h"

@interface NearFriendViewController : UIViewController 
{
    IBOutlet UIView *annotationDetailView;
    IBOutlet UIImageView *imvActivityImage;
}

- (IBAction)btnSideBarMenuAction:(id)sender;
- (IBAction)btnSettingAction:(id)sender;

@end
