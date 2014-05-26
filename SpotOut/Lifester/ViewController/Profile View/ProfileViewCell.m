//
//  ProfileViewCell.m
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "ProfileViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProfileViewCell

@synthesize imgLine1,viewLikeComment,viewRatePlace,locationSection;
@synthesize lblDescription;
@synthesize btnPlaceLink,btnReadMore,btnBookmark;
@synthesize lblCommentCount;
@synthesize lblDistanceFromLocation ,lblLikeCount,lblPictureCount,lblShareCount,lblTagNames,imgProfileUser,lblUserName,lblTime;
@synthesize imvPlacePost, btnPlacePost;
@synthesize lblActivityTitle, lblFirstLocationName, lblCategoryType;
@synthesize lblLocationAddress, lblLocationCategoryType, lblLocationStreet, lblSecondLocationName;
@synthesize mapview;

@synthesize btnLocation, btnMapView;
@synthesize btnLike, btnComment, btnShare, btnRePost;


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

@end
