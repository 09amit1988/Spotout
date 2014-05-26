//
//  FollowerViewController.h
//  Lifester
//
//  Created by MAC240 on 4/23/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FollowerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tblFollower;
    
    int flag;
    NSInteger selectedIndex;
    AppDelegate *appDelegate;
}
@property (nonatomic, retain) NSMutableArray *arrFollowerList;
@property (nonatomic, assign) BOOL isFollowing;
@property (nonatomic, retain) NSNumber *profileID;

@end
