//
//  StringHelper.m
//  Coffee Learning
//


#import "StringHelper.h"

@implementation NSString (StringHelper)

#pragma mark Methods to determine the height of a string for resizeable table cells

- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size {
    //Calculate the expected size based on the font and linebreak mode of your label
    
    CGFloat maxWidth = 270.0;
    CGSize maximumLabelSize = CGSizeMake(maxWidth,MAXFLOAT);
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size]
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.height;
}

- (CGFloat)RAD_textWidthForSystemFontOfSize:(CGFloat)size {
    //Calculate the expected size based on the font and linebreak mode of your label
    
    CGFloat maxHeight = 24.0;
    CGSize maximumLabelSize = CGSizeMake(MAXFLOAT,maxHeight);
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.width;
}

- (CGFloat)RAD_textWidthForFontName:(NSString*)fontName FontOfSize:(CGFloat)size MaxHeight:(CGFloat)maxHeight {
    //Calculate the expected size based on the font and linebreak mode of your label
    
    CGSize maximumLabelSize = CGSizeMake(MAXFLOAT,maxHeight);
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont fontWithName:fontName size:size]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.width;
}

- (CGFloat)RAD_textHeightForFontName:(NSString*)fontName FontOfSize:(CGFloat)size MaxWidth:(CGFloat)maxWidth {
    //Calculate the expected size based on the font and linebreak mode of your label
    
    CGSize maximumLabelSize = CGSizeMake(maxWidth,MAXFLOAT);
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont fontWithName:fontName size:size]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:NSLineBreakByWordWrapping];

    return expectedLabelSize.height;
}

- (CGFloat)RAD_textHeightForReviewSystomFontOfSize:(CGFloat)size {
    //Calculate the expected size based on the font and linebreak mode of your label
    
    CGFloat maxWidth = 285.0;
    CGSize maximumLabelSize = CGSizeMake(maxWidth,MAXFLOAT);
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size]
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.height;
}

- (CGFloat)RAD_textWidthForBoldSystemFontOfSize:(CGFloat)size {
    //Calculate the expected size based on the font and linebreak mode of your label
    
    CGFloat maxHeight = 21.0;
    CGSize maximumLabelSize = CGSizeMake(MAXFLOAT,maxHeight);
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont boldSystemFontOfSize:size]
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.width+5.0;
}


- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size {
	CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
	CGFloat height = [self RAD_textHeightForSystemFontOfSize:size];
    
	return CGRectMake(10.0f, 10.0f, width, height);
}

- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size {
	CGRect frame = aLabel.frame;
	frame.size.height = [self RAD_textHeightForSystemFontOfSize:size];
	aLabel.frame = frame;
	aLabel.text = self;
	[aLabel sizeToFit];
}


- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size {
	UILabel *lblCell = [[UILabel alloc] initWithFrame:[self RAD_frameForCellLabelWithSystemFontOfSize:size]];
	lblCell.textColor = [UIColor blackColor];
	lblCell.backgroundColor = [UIColor clearColor];
	lblCell.textAlignment = NSTextAlignmentLeft;
	lblCell.font = [UIFont systemFontOfSize:size];
	lblCell.text = self;
	lblCell.numberOfLines = 0;
	[lblCell sizeToFit];
	
	return [lblCell autorelease];
}

@end
