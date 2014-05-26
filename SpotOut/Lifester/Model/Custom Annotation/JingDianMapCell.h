//
//  JingDianMapCell.h
//  IYLM
//

#import <UIKit/UIKit.h>

@interface JingDianMapCell : UIView
{
    UILabel *lblLocation;
    UILabel *lblAddress;
    UILabel *lblDistance;
}
@property (nonatomic, strong) IBOutlet UILabel *lblLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblAddress;
@property (nonatomic, strong) IBOutlet UILabel *lblDistance;
@property (nonatomic,strong) IBOutlet UILabel *lblWaitmins;
@property (nonatomic,strong) IBOutlet UILabel *lblTime;
@property (nonatomic,strong) IBOutlet UIButton *btnTimeEvent;
@property (nonatomic,strong) IBOutlet UILabel *lblMinute;
@property (nonatomic,strong) IBOutlet UIImageView *imgClock;


@end
