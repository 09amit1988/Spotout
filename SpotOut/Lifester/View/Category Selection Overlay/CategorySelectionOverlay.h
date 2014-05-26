//
//  CategorySelectionOverlay.h
//  Lifester
//


#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
#import "OverlayView.h"
#import "RootViewDelegate.h"
#import "PlaceCategoryCell.h"
#import "StringHelper.h"
#import "SuggestPlaceViewController.h"
#import "AppDelegate.h"

@interface CategorySelectionOverlay : OverlayView <UITableViewDataSource, UITableViewDelegate>
{
	
    IBOutlet UIButton *btnDone;
    IBOutlet UIView *categoryOverlay;
    IBOutlet UITableView *tblCategory;
    IBOutlet UIView *viewDoneCategory;
}
@property (nonatomic, retain) IBOutlet UIView *viewDoneCategory;
@property (nonatomic, retain) IBOutlet UIButton *btnDone;
@property (nonatomic, retain) IBOutlet UIView *categoryOverlay;
@property (nonatomic, retain) IBOutlet UITableView *tblCategory;
@property (nonatomic, retain) NSMutableArray *arrCategory;

- (IBAction)btnDoneCategoryAction:(id)sender;

+ (void)showAlert:(NSString*)strHeader delegate:(id)sender withTag:(NSInteger)iTag;

@end