//
//  DetailViewController.h
//  SpotOut
//
//  Created by Rakesh on 25/05/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LifeFeedPost.h"

@interface DetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate> {
    
    IBOutlet UITableView *tblDetail;
    NSMutableArray *arrPeople;
    NSMutableArray *arrDetail;
    NSMutableArray *arrImage;
}

@end
