//
//  InviteFriendListCell.m
//  Lifester
//


#import "InviteFriendListCell.h"

@implementation InviteFriendListCell

@synthesize imvProfile;
@synthesize lblUserName;
@synthesize btnInvite;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    self.imvProfile = nil;
    self.lblUserName = nil;
    self.btnInvite = nil;
    [super dealloc];
}


@end
