//
//  EventPostCell.m
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "EventPostCell.h"

@implementation EventPostCell

@synthesize imgProfileUser;
@synthesize lblUserName;

@synthesize imvEventPost;
@synthesize btnEventPost;
@synthesize lblDistanceFromLocation;
@synthesize lblPictureCount;

@synthesize lblEventTitle;
@synthesize lblEventTime;
@synthesize lblTicketAvailable;

@synthesize lblTagNames;
@synthesize btnBookmark;
@synthesize lblDescription;
@synthesize btnReadMore;
@synthesize btnEventLink;

@synthesize imvLine1;
@synthesize lblEventLocation;
@synthesize lblLocationCategoryType;
@synthesize lblLocationStreet;
@synthesize lblLocationAddress;
@synthesize mapview;

@synthesize btnMoreTickets;

@synthesize lblEventPostTime;
@synthesize lblLikeCount;
@synthesize lblCommentCount;
@synthesize lblShareCount;

@synthesize btnLike;
@synthesize btnComment;
@synthesize btnShare;
@synthesize btnRePost;

@synthesize locationSection;
@synthesize viewTicket;
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
