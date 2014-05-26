//
//  CallOutAnnotationVifew.m
//  IYLM
//
//

#import "CallOutAnnotationView.h"
#import <QuartzCore/QuartzCore.h>


#define  Arror_height 15

@interface CallOutAnnotationView ()

-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;
@end

@implementation CallOutAnnotationView
@synthesize contentView;


- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.opaque = YES;
        self.centerOffset = CGPointMake(-73, -68);
        //self.frame = CGRectMake(0, 0, 200, 70);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)];
        _contentView.backgroundColor   = [UIColor clearColor];
        [self addSubview:_contentView];
        //self.contentView = _contentView;
        //self.contentView.alpha = 0.8;
        
    }
    return self;
}

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

/*
-(void)drawInContext:(CGContextRef)context
{
	
   CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
   
    [self getDrawPath:context];
    CGContextFillPath(context);
    
//    CGContextSetLineWidth(context, 1.0);
//     CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    [self getDrawPath:context];
//    CGContextStrokePath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = 6.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), 
    // midy = CGRectGetMidY(rrect), 
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.7;
  //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}
 
 */


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
