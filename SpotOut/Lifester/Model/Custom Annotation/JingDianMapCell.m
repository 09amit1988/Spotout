//
//  JingDianMapCell.m
//  IYLM
//


#import "JingDianMapCell.h"

@implementation JingDianMapCell

@synthesize lblAddress;
@synthesize lblLocation;
@synthesize lblDistance,lblTime,lblWaitmins,btnTimeEvent,imgClock,lblMinute;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
    UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 15)];
    _contentView.backgroundColor   = [UIColor clearColor];
    [self addSubview:_contentView];
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor colorWithRed:51.0/255.0 green:120.0/255.0 blue:147.0/255.0 alpha:1.0] CGColor];
    self.layer.shadowOpacity = 0.5;
    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);


}

-(void)drawInContext:(CGContextRef)context
{
	
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
        CGContextSetLineWidth(context, 1.3);
         CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:51.0/255.0 green:120.0/255.0 blue:147.0/255.0 alpha:0.8].CGColor);
        [self getDrawPath:context];
        CGContextStrokePath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = 1.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-7;
    CGContextMoveToPoint(context, midx+7, maxy);
    CGContextAddLineToPoint(context,midx, maxy+7);
    CGContextAddLineToPoint(context,midx-7, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}



@end
