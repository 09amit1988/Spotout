//
//  SearchCell.m
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "SearchCell.h"


@implementation SearchCell

@synthesize imgLine1;
@synthesize profileView;
@synthesize postView;
@synthesize tagView;
@synthesize imvProfileUser;
@synthesize lblUserName;
@synthesize lblProfileName;
@synthesize lblLocationName;
@synthesize lblDescription;
@synthesize btnReadMore;
@synthesize lblTagNames;
@synthesize btnTagNames;
@synthesize btnFollow;

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
