//
//  LocationCell.m
//  Lifester
//
//  Created by MAC205 on 07/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

@synthesize lblLocationName;
@synthesize lblAddress;
@synthesize imvLocation;
@synthesize imvBottomLine;

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
