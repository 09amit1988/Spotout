//
//  CategoryCell.m
//  Lifester
//
//  Created by MAC205 on 07/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize btnCategory1;
@synthesize imvDone1;
@synthesize lblCategory1;

@synthesize btnCategory2;
@synthesize imvDone2;
@synthesize lblCategory2;
@synthesize imvActivity2;
@synthesize lblActivity2;

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
