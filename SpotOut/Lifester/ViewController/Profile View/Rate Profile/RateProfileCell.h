//
//  RateProfileCell.h
//  Lifester
//
//  Created by MAC205 on 13/02/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateProfileCell : UITableViewCell
{
    IBOutlet UIImageView *imvProfileUser;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblComment;
    
    IBOutlet UIImageView *imvClockIcon;
    IBOutlet UILabel *lblTimeDifference;
}
@property (nonatomic,retain) IBOutlet UIImageView *imvProfileUser;
@property (nonatomic,retain) IBOutlet UILabel *lblUserName;
@property (nonatomic,retain) IBOutlet UILabel *lblComment;

@property (nonatomic,retain) IBOutlet UIImageView *imvClockIcon;
@property (nonatomic,retain) IBOutlet UILabel *lblTimeDifference;

@end
