//
//  PictureListingOverlay.h
//  Lifester
//


#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
#import "OverlayView.h"
#import "RootViewDelegate.h"


@interface PictureListingOverlay : OverlayView <UIScrollViewDelegate, UIActionSheetDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *bottomView;
    IBOutlet UILabel *lblPictureCount;
    
    NSInteger currentIndex;
}
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *lblPictureCount;
@property (nonatomic, retain) IBOutlet UIView *bottomView;
@property (nonatomic, retain) NSMutableArray *arrPictures;

- (IBAction)btnSavePictureInCameraRollAction:(id)sender;
- (IBAction)dismissOverlayAction:(id)sender;
+ (void)showAlert:(NSMutableArray*)arrPicture delegate:(id)sender withTag:(NSInteger)iTag currentIndex:(NSInteger)index;

@end