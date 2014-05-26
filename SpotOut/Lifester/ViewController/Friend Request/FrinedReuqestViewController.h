//
//  FrinedReuqestViewController.h
//  Lifester
//
//  Created by Nikunj on 1/6/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendRequestCell.h"
#import "AppDelegate.h"

@interface FrinedReuqestViewController : UIViewController
{
    IBOutlet UITableView *tblFriendList;
    IBOutlet UITextField *txtSearch;
}

- (IBAction)btnCancelAction:(id)sender;

@end
