//
//  FollowerListCell.m
//  Lifester
//


#import "FollowerListCell.h"

@implementation FollowerListCell

@synthesize imvProfile;
@synthesize lblprofileName;
@synthesize lblUserName;
@synthesize btnFollower;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)dealloc {
    self.imvProfile = nil;
    self.lblprofileName = nil;
    self.lblUserName = nil;
    self.btnFollower = nil;
    [super dealloc];
}


@end
