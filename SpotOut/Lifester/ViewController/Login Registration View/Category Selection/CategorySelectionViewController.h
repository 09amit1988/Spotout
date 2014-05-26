//
//  CategorySelectionViewController.h
//  Lifester
//
//  Created by MAC240 on 1/8/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"


@interface CategorySelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView *backgroundView;
    IBOutlet UITableView *tblCategory;
    AppDelegate *appDelegateObj;
    
    BOOL flag;
}
@property (nonatomic, retain) NSMutableArray *arrCategory;

@end
