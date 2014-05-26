//
//  CustomNaviView.h
//  MediaApp
//
//  Created by Nikunj on 12/26/13.
//  Copyright (c) 2013 Jitendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@class MenuView;
@protocol MenuViewDelegate <NSObject>

@optional
- (void)hideMenuView;
- (void)didSelectUserProfile:(UIViewController*)viewController;
- (void)didSelecteSetting:(UIViewController*)viewController;
- (void)didSelectExploreView:(UIView *)viewController;
- (void)didSelecteRowAtMenuIndex:(NSInteger)index parentViewController:(UIViewController*)viewController;
@end

@interface MenuView : UIView <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView *tblMenuList;
    IBOutlet UIButton *btnSettings;
    IBOutlet UIButton *btnUserName;
    IBOutlet UIView *searchView;
    
    IBOutlet UITextField *txtSearch;
    IBOutlet UIButton *btnArrowUp;
    IBOutlet UIImageView *imvCity;
    IBOutlet UIImageView *imgProfile;
    
}

@property(nonatomic,assign) id <MenuViewDelegate> delegate;
@property(nonatomic,assign) UIViewController *parentViewController;
@property (nonatomic, retain) IBOutlet UITableView *tblMenuList;
@property (nonatomic, retain) IBOutlet UIImageView *imgProfile;
@property (nonatomic, retain) IBOutlet UIView *searchView;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet UIButton *btnUserName;

- (IBAction)btnSettingAction:(id)sender;
- (IBAction)btnUpArrowAction:(id)sender;
- (IBAction)btnUserProfileAction:(id)sender;
- (IBAction)btnCancelAction:(id)sender;

@end
