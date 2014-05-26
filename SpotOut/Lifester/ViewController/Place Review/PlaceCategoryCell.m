//
//  PlaceCategoryCell.m
//  Lifester
//
//  Created by MAC205 on 07/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "PlaceCategoryCell.h"

@implementation PlaceCategoryCell

@synthesize btnCategory1;
@synthesize btnOverlay1;
@synthesize lblCategory1;
@synthesize btnCategory2;
@synthesize btnOverlay2;
@synthesize lblCategory2;
@synthesize btnCategory3;
@synthesize btnOverlay3;
@synthesize lblCategory3;


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
