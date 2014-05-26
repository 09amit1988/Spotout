//
//  FollowerListCell.h
//  Lifester
//

#import <UIKit/UIKit.h>

@interface FollowerListCell : UITableViewCell
{
	UIImageView *imvProfile;
    UILabel *lblprofileName;
    UILabel *lblUserName;
    UIButton *btnFollower;
}

@property(nonatomic, retain) IBOutlet UIImageView *imvProfile;
@property(nonatomic, retain) IBOutlet UILabel *lblprofileName;
@property(nonatomic, retain) IBOutlet UILabel *lblUserName;
@property(nonatomic, retain) IBOutlet UIButton *btnFollower;

@end
