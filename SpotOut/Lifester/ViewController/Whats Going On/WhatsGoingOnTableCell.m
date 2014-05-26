//
//  WhatsGoingOnTableCell.m
//  Lifester
//
//  Created by YASH  on 27/12/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "WhatsGoingOnTableCell.h"

@implementation WhatsGoingOnTableCell
@synthesize imageCell;

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
