//
//  TextPostCell.m
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "TextPostCell.h"

@implementation TextPostCell


@synthesize imgProfileUser;
@synthesize lblUserName;

@synthesize lblTagNames;
@synthesize btnBookmark;
@synthesize lblDescription;
@synthesize btnReadMore;
@synthesize btnTextLink;

@synthesize imgLine1;
@synthesize lblTextPostTime;
@synthesize lblLikeCount;
@synthesize lblCommentCount;
@synthesize lblShareCount;

@synthesize btnLike;

@synthesize viewInviteFriend;
@synthesize viewLikeComment;


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
