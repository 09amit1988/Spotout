//
//  FacebookFriendListViewController.h
//  Lifester
//
//  Created by Nikunj on 12/18/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface FacebookFriendListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    IBOutlet UIView *backgroundView;
    IBOutlet UITableView *tblFriends;
    IBOutlet UITextField *txtSearch;
    
    NSMutableArray *arrFriendList;
    NSMutableArray *arrSelectedList;
    NSMutableArray *arrSearched;
    
    AppDelegate *appDelegateObj;
}
@property (nonatomic, retain) NSMutableArray *arrFriendList;
@property (nonatomic, retain) NSMutableArray *arrSelectedList;
@property (nonatomic, retain) NSMutableArray *arrSearched;

@end
