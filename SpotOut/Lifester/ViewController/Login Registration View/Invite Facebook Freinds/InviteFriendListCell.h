//
//  InviteFriendListCell.h
//  Lifester
//

#import <UIKit/UIKit.h>

@interface InviteFriendListCell : UITableViewCell  
{
	IBOutlet UIImageView *imvProfile;
    IBOutlet UILabel *lblUserName;
    IBOutlet UIButton *btnInvite;
}

@property(nonatomic, retain) IBOutlet UIImageView *imvProfile;
@property(nonatomic, retain) IBOutlet UILabel *lblUserName;
@property(nonatomic, retain) IBOutlet UIButton *btnInvite;

@end
