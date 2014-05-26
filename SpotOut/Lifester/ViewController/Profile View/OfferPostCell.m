//
//  OfferPostCell.m
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "OfferPostCell.h"

@implementation OfferPostCell


@synthesize imgProfileUser;
@synthesize lblUserName;

@synthesize imvOfferPost;
@synthesize btnOfferPost;
@synthesize lblDistanceFromLocation;
@synthesize lblPictureCount;

@synthesize lblOfferTitle;
@synthesize lblOfferPrice;
@synthesize lblOfferTime;

@synthesize lblTagNames;
@synthesize btnBookmark;
@synthesize lblDescription;
@synthesize btnReadMore;
@synthesize btnOfferLink;

@synthesize lblOfferLocation;
@synthesize lblLocationCategoryType;
@synthesize lblLocationStreet;
@synthesize lblLocationAddress;
@synthesize mapview;

@synthesize imgLine1;

@synthesize lblOfferPostTime;
@synthesize lblLikeCount;
@synthesize lblCommentCount;
@synthesize lblShareCount;

@synthesize btnLike;
@synthesize btnRePost;
@synthesize btnShare;
@synthesize btnComment;

@synthesize locationSection;
@synthesize viewInviteFriend;
@synthesize viewLikeComment;

@synthesize btnLocation;
@synthesize btnMapView;

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
