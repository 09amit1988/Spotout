//
//  ODRefreshControl.m
//  ODRefreshControl
//
//  Created by Fabio Ritrovato on 6/13/12.
//  Copyright (c) 2012 orange in a day. All rights reserved.
//
// https://github.com/Sephiroth87/ODRefreshControl
//

#import "ODRefreshControl.h"

#define kTotalViewHeight    400
#define kOpenedViewHeight   54
#define kMinTopPadding      22
#define kMaxTopPadding      32
#define kMinTopRadius       12.5
#define kMaxTopRadius       16
#define kMinBottomRadius    3
#define kMaxBottomRadius    16
#define kMinBottomPadding   4
#define kMaxBottomPadding   6
#define kMinArrowSize       2
#define kMaxArrowSize       3
#define kMinArrowRadius     5
#define kMaxArrowRadius     7
#define kMaxDistance        53


@interface ODRefreshControl ()

@property (nonatomic, readwrite) BOOL refreshing;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalContentInset;


@end

@implementation ODRefreshControl

@synthesize refreshing = _refreshing;
@synthesize tintColor = _tintColor;

@synthesize scrollView = _scrollView;
@synthesize originalContentInset = _originalContentInset;
@synthesize lastTopPadding = _lastTopPadding;

static inline CGFloat lerp(CGFloat a, CGFloat b, CGFloat p)
{
    return a + (b - a) * p;
}

- (id)initInScrollView:(UIScrollView *)scrollView {
    return [self initInScrollView:scrollView activityIndicatorView:nil];
}

- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(UIView *)activity
{
    self = [super initWithFrame:CGRectMake(0, -(kTotalViewHeight + scrollView.contentInset.top), scrollView.frame.size.width, kTotalViewHeight)];
    
    if (self) {
        _lastTopPadding = 32;
        self.scrollView = scrollView;
        self.originalContentInset = scrollView.contentInset;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
        
        _activity = activity ? activity : [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center = CGPointMake(floor(self.frame.size.width / 2), floor(self.frame.size.height / 2));
        _activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _activity.alpha = 0;
        if ([_activity respondsToSelector:@selector(startAnimating)]) {
            [(UIActivityIndicatorView *)_activity startAnimating];
        }
        [self addSubview:_activity];
        
        
        
        _refreshing = NO;
        _canRefresh = YES;
        _ignoreInset = NO;
        _ignoreOffset = NO;
        _didSetInset = NO;
        _hasSectionHeaders = NO;
        _tintColor = [UIColor colorWithRed:155.0 / 255.0 green:162.0 / 255.0 blue:172.0 / 255.0 alpha:1.0];
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [_tintColor CGColor];
        _shapeLayer.strokeColor = [[[UIColor darkGrayColor] colorWithAlphaComponent:0.5] CGColor];
        _shapeLayer.lineWidth = 0.5;
        _shapeLayer.shadowColor = [[UIColor blackColor] CGColor];
        _shapeLayer.shadowOffset = CGSizeMake(0, 1);
        _shapeLayer.shadowOpacity = 0.4;
        _shapeLayer.shadowRadius = 0.5;
        [self.layer addSublayer:_shapeLayer];
        
        _arrowLayer = [CAShapeLayer layer];
        _arrowLayer.strokeColor = [[[UIColor darkGrayColor] colorWithAlphaComponent:0.5] CGColor];
        _arrowLayer.lineWidth = 0.5;
        _arrowLayer.fillColor = [[UIColor whiteColor] CGColor];
        [_shapeLayer addSublayer:_arrowLayer];
        
        _highlightLayer = [CAShapeLayer layer];
        _highlightLayer.fillColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.2] CGColor];
        [_shapeLayer addSublayer:_highlightLayer];
        
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading1.png"]];
        _imageView.frame = CGRectMake(138.0f, scrollView.frame.size.height - 190.0f, _imageView.image.size.width, _imageView.image.size.height);
        _imageView.alpha = 0;
        [self addSubview:_imageView];
        
       
        _pulseLayer = [[CALayer layer] retain];
        _pulseLayer.backgroundColor = [[UIColor clearColor] CGColor];
        _pulseLayer.bounds = CGRectMake(0., 0., 14., 23.);
        _pulseLayer.position = CGPointMake(160, scrollView.frame.size.height - 215.0f);
        //[self.layer addSublayer:_pulseLayer];
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.contents = (id)[[UIImage imageNamed:@"city-loader-icon.png"] CGImage];
        imageLayer.frame = _pulseLayer.bounds;
        imageLayer.masksToBounds = YES;
        [_pulseLayer addSublayer:imageLayer];
        [_pulseLayer removeAllAnimations];
        [_pulseLayer setNeedsDisplay];
        
        _eyeLayer = [[CALayer layer] retain];
        _eyeLayer.backgroundColor = [[UIColor clearColor] CGColor];
        _eyeLayer.bounds = CGRectMake(0., 0., 21., 8.);
        _eyeLayer.position = CGPointMake(160, scrollView.frame.size.height - 195.0f);
        //_eyeLayer.position = CGPointMake(160, 10);
        //[self.layer addSublayer:_eyeLayer];
        
        
        CALayer *imgEyeLayer = [CALayer layer];
        imgEyeLayer.contents = (id)[[UIImage imageNamed:@"eyes-loader-icon.png"] CGImage];
        imgEyeLayer.frame = _eyeLayer.bounds;
        imgEyeLayer.masksToBounds = YES;
        [_eyeLayer addSublayer:imgEyeLayer];
        [_eyeLayer removeAllAnimations];
        [_eyeLayer setNeedsDisplay];
        
       //[self.layer insertSublayer:_eyeLayer above:_shapeLayer];
//        [scrollView.layer insertSublayer:_eyeLayer below:_shapeLayer];
        
    }
    return self;
}
/*
- (void)drawRect:(CGRect)rect
{
//    // Get the current context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextBeginPath(context);
//    
//    // Add a filled rectangle to the current path
//    //[self addFilledRectangleToPathOnContext:context];
//    
//    // Add a stroked ellipse to the current path
//    CGRect ellipseRect = CGRectMake(160, 373, 21, 8);
//    CGContextAddEllipseInRect(context, ellipseRect);
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    
//    CGContextStrokePath(context);
//    
//    CGContextClosePath(context);
 
 
//    UIImage *backgroundImage = [UIImage imageNamed:@"eyes-loader-icon.png"];
//    
//    //[backgroundImage drawInRect:CGRectMake(160, 373, 21, 8) blendMode:kCGBlendModeDarken alpha:1.0f];
//    [backgroundImage drawInRect:CGRectMake(160, 373, 21, 8)];

    
        CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
//    CGRect drawingRect = CGRectMake(0.0,
//                                    0.0f,
//                                    100.0f,
//                                    200.0f);
//    
//
//    const CGFloat *rectColorComponents =
//    CGColorGetComponents([UIColor redColor].CGColor);
//    
//
//    CGContextSetFillColor(context, rectColorComponents);
//    
//
//    CGContextFillRect(context, drawingRect);
    
    
    CGRect ellipseRect = CGRectMake(160.0f,
                                    370.0f,   
                                    10.0f,
                                    10.0f);
    
    
    const CGFloat *ellipseColorComponents =
    CGColorGetComponents([UIColor redColor].CGColor);
    
    
    CGContextSetFillColor(context, ellipseColorComponents);
    
    
    CGContextFillEllipseInRect(context, ellipseRect);
}
*/

- (void)dealloc
{
    [super dealloc];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    self.scrollView = nil;
}

- (void)setEnabled:(BOOL)enabled
{
    super.enabled = enabled;
    _shapeLayer.hidden = !self.enabled;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
        self.scrollView = nil;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    _shapeLayer.fillColor = [_tintColor CGColor];
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    if ([_activity isKindOfClass:[UIActivityIndicatorView class]]) {
        [(UIActivityIndicatorView *)_activity setActivityIndicatorViewStyle:activityIndicatorViewStyle];
    }
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    if ([_activity isKindOfClass:[UIActivityIndicatorView class]]) {
        return [(UIActivityIndicatorView *)_activity activityIndicatorViewStyle];
    }
    return 0;
}

- (void)setActivityIndicatorViewColor:(UIColor *)activityIndicatorViewColor
{
    if ([_activity isKindOfClass:[UIActivityIndicatorView class]] && [_activity respondsToSelector:@selector(setColor:)]) {
        [(UIActivityIndicatorView *)_activity setColor:activityIndicatorViewColor];
    }
}

- (UIColor *)activityIndicatorViewColor
{
    if ([_activity isKindOfClass:[UIActivityIndicatorView class]] && [_activity respondsToSelector:@selector(color)]) {
        return [(UIActivityIndicatorView *)_activity color];
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSInteger iOS7Value = 60.0f;
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        if (!_ignoreInset) {
            //self.originalContentInset = [[change objectForKey:@"new"] UIEdgeInsetsValue];
            //self.frame = CGRectMake(0, -(kTotalViewHeight + self.scrollView.contentInset.top), self.scrollView.frame.size.width, kTotalViewHeight);
            self.originalContentInset = [[change objectForKey:@"new"] UIEdgeInsetsValue];
//            [self.layer addSublayer:_pulseLayer];
//            [self.layer addSublayer:_eyeLayer];
            
            if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            {
                self.frame = CGRectMake(0, -(kTotalViewHeight + self.scrollView.contentInset.top) + iOS7Value, self.scrollView.frame.size.width, kTotalViewHeight);
            } else {
                self.frame = CGRectMake(0, -(kTotalViewHeight + self.scrollView.contentInset.top), self.scrollView.frame.size.width, kTotalViewHeight);
            }
        }
        return;
    }
    
    if (!self.enabled || _ignoreOffset) {
        return;
    }

    CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y + self.originalContentInset.top;
    
    if (_refreshing) {
        if (offset != 0) {
            // Keep thing pinned at the top
            
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _shapeLayer.position = CGPointMake(0, kMaxDistance + offset + kOpenedViewHeight);
            [CATransaction commit];

            //_activity.center = CGPointMake(floor(self.frame.size.width / 2), MIN(offset + self.frame.size.height + floor(kOpenedViewHeight / 2), self.frame.size.height - kOpenedViewHeight/ 2));

            _ignoreInset = YES;
            _ignoreOffset = YES;
            
            if (offset < 0) {
                // Set the inset depending on the situation
                if (offset >= -kOpenedViewHeight) {
                    if (!self.scrollView.dragging) {
                        if (!_didSetInset) {
                            _didSetInset = YES;
                            _hasSectionHeaders = NO;
                            if([self.scrollView isKindOfClass:[UITableView class]]){
                                for (int i = 0; i < [(UITableView *)self.scrollView numberOfSections]; ++i) {
                                    if ([(UITableView *)self.scrollView rectForHeaderInSection:i].size.height) {
                                        _hasSectionHeaders = YES;
                                        break;
                                    }
                                }
                            }
                        }
                        if (_hasSectionHeaders) {
                            [self.scrollView setContentInset:UIEdgeInsetsMake(MIN(-offset, kOpenedViewHeight) + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                        } else {
                            [self.scrollView setContentInset:UIEdgeInsetsMake(kOpenedViewHeight + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                        }
                    } else if (_didSetInset && _hasSectionHeaders) {
                        [self.scrollView setContentInset:UIEdgeInsetsMake(-offset + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                    }
                }
            } else if (_hasSectionHeaders) {
                [self.scrollView setContentInset:self.originalContentInset];
            }
            _ignoreInset = NO;
            _ignoreOffset = NO;
        }
        return;
    } else {
        // Check if we can trigger a new refresh and if we can draw the control
        BOOL dontDraw = NO;
        if (!_canRefresh) {
            if (offset >= 0) {
                // We can refresh again after the control is scrolled out of view
                _canRefresh = YES;
                _didSetInset = NO;
            } else {
                dontDraw = YES;
            }
        } else {
            if (offset >= 0) {
                // Don't draw if the control is not visible
                dontDraw = YES;
            }
        }
        if (offset > 0 && _lastOffset > offset && !self.scrollView.isTracking) {
            // If we are scrolling too fast, don't draw, and don't trigger unless the scrollView bounced back
            _canRefresh = NO;
            dontDraw = YES;
        }
        if (dontDraw) {
            _shapeLayer.path = nil;
            _shapeLayer.shadowPath = nil;
            //_arrowLayer.path = nil;
            //_highlightLayer.path = nil;
            _lastOffset = offset;
            return;
        }
    }
    
    _lastOffset = offset;
    
    BOOL triggered = NO;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    //Calculate some useful points and values
    CGFloat verticalShift = MAX(0, -((kMaxTopRadius + kMaxBottomRadius + kMaxTopPadding + kMaxBottomPadding) + offset));
    CGFloat distance = MIN(kMaxDistance, fabs(verticalShift));
    CGFloat percentage = 1 - (distance / kMaxDistance);
    
    CGFloat currentTopPadding = lerp(kMinTopPadding, kMaxTopPadding, percentage);
    CGFloat currentTopRadius = lerp(kMinTopRadius, kMaxTopRadius, percentage);
    CGFloat currentBottomRadius = lerp(kMinBottomRadius, kMaxBottomRadius, percentage);
    CGFloat currentBottomPadding =  lerp(kMinBottomPadding, kMaxBottomPadding, percentage);
    
    CGPoint bottomOrigin = CGPointMake(floor(self.bounds.size.width / 2), self.bounds.size.height - currentBottomPadding -currentBottomRadius);
    CGPoint topOrigin = CGPointZero;
    if (distance == 0) {
        topOrigin = CGPointMake(floor(self.bounds.size.width / 2), bottomOrigin.y);
    } else {
        topOrigin = CGPointMake(floor(self.bounds.size.width / 2), self.bounds.size.height + offset + currentTopPadding + currentTopRadius);
        if (percentage == 0) {
            bottomOrigin.y -= (fabs(verticalShift) - kMaxDistance);
            triggered = YES;
        }
    }
    
    
//    CGRect drawingRect = CGRectMake(topOrigin.x-7, topOrigin.y-32, 3, 12);  /* Height */
//    
//        /* Get the red color */
//        const CGFloat *rectColorComponents =
//        CGColorGetComponents([UIColor redColor].CGColor);
//    
//        /* Draw with red fill color */
//        CGContextSetFillColor(context, rectColorComponents);
//    
//        /* Now draw the rectangle */
//        CGContextFillRect(context, drawingRect);
    
    
//    CGPathAddRect(path, NULL, CGRectMake(topOrigin.x-7, topOrigin.y-32, 3, 12));
//    CGPathAddRect(path, NULL, CGRectMake(topOrigin.x-3, topOrigin.y-35, 3, 25));
//    CGPathAddRect(path, NULL, CGRectMake(topOrigin.x+2, topOrigin.y-25, 3, 23));
//    CGPathAddRect(path, NULL, CGRectMake(topOrigin.x+6, topOrigin.y-25, 3, 21));
    
//    UIColor *aColor = [UIColor redColor];
//    [aColor setFill];
//    CGContextSaveGState(context);
    
    //Top semicircle
    CGPathAddArc(path, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0, M_PI, YES);
    
    //Left curve
    CGPoint leftCp1 = CGPointMake(lerp((topOrigin.x - currentTopRadius), (bottomOrigin.x - currentBottomRadius), 0.1), lerp(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint leftCp2 = CGPointMake(lerp((topOrigin.x - currentTopRadius), (bottomOrigin.x - currentBottomRadius), 0.9), lerp(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint leftDestination = CGPointMake(bottomOrigin.x - currentBottomRadius, bottomOrigin.y);
    
    CGPathAddCurveToPoint(path, NULL, leftCp1.x, leftCp1.y, leftCp2.x, leftCp2.y, leftDestination.x, leftDestination.y);
    
    //Bottom semicircle
    CGPathAddArc(path, NULL, bottomOrigin.x, bottomOrigin.y, currentBottomRadius, M_PI, 0, YES);
    
    //Right curve
    CGPoint rightCp2 = CGPointMake(lerp((topOrigin.x + currentTopRadius), (bottomOrigin.x + currentBottomRadius), 0.1), lerp(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint rightCp1 = CGPointMake(lerp((topOrigin.x + currentTopRadius), (bottomOrigin.x + currentBottomRadius), 0.9), lerp(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint rightDestination = CGPointMake(topOrigin.x + currentTopRadius, topOrigin.y);
    
    CGPathAddCurveToPoint(path, NULL, rightCp1.x, rightCp1.y, rightCp2.x, rightCp2.y, rightDestination.x, rightDestination.y);
    CGPathCloseSubpath(path);
    
    
//    CGContextRef myContext = UIGraphicsGetCurrentContext();
//    // ********** Your drawing code here ********** // 2
//    CGContextSetRGBFillColor (myContext, 1, 0, 0, 1);// 3
//    CGContextFillRect (myContext, CGRectMake (0, 0, 200, 100 ));// 4
//    CGContextSetRGBFillColor (myContext, 0, 0, 1, .5);// 5
//    CGContextFillRect (myContext, CGRectMake (0, 0, 100, 200));

   
    
    
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    
//    CGRect rectangle = CGRectMake(topOrigin.x, topOrigin.y, 100, 100);
//    CGContextRef context1 = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(context1, 1.0, 1.0, 0.0, 1.0);
//    CGContextSetRGBStrokeColor(context1, 1.0, 1.0, 0.0, 1.0);
//    CGContextFillRect(context1, rectangle);
    
    
//    UIImage *image = [UIImage imageNamed:@"eyes-loader-icon.png"];
//    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
//    CGContextTranslateCTM(context, 0, image.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextDrawImage(context, imageRect, image.CGImage);
    
//    UIImage *eyes = [UIImage imageNamed:@"eyes-loader-icon.png"];
//    CGRect imageRect = CGRectMake(0, 0, eyes.size.width, eyes.size.height);
    
    //UIGraphicsBeginImageContext(self.bounds.size);
    //UIGraphicsBeginImageContext(CGSizeMake(21, 8));
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 8), NO, [UIScreen mainScreen].scale);
    // Fig 2 comment these lines to have Fig 2
    //CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, 373);
    //CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    // Fig 2 Applying the above transformations results in Fig 1
    
//    //CGRectMake(138.0f, scrollView.frame.size.height - 190.0f, _imageView.image.size.width, _imageView.image.size.height)
//    UIImage *natureImage = [UIImage imageNamed:@"eyes-loader-icon.png"];
//    CGRect natureImageRect = CGRectMake(160, 365, 21, 8);
//    
//    UIImage *segmentImage = [self image:natureImage];
//    CGContextSaveGState(UIGraphicsGetCurrentContext());
//    //CGSize segmentImgaeSize = segmentImage.size;
////    CGFloat newPointX = (self.innerRadius+segmentImgaeSize.width/2.00) * cos(angle) + centerPoint.x;
////    CGFloat newPointY = (self.innerRadius+segmentImgaeSize.height/2.00) * sin(angle) + centerPoint.y;
////    CGRect rect = CGRectMake((newPointX-segmentImgaeSize.width/2.00),(newPointY-segmentImgaeSize.height/2.00), segmentImgaeSize.width, segmentImgaeSize.height);
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), natureImageRect, segmentImage.CGImage);
//    CGContextRestoreGState(UIGraphicsGetCurrentContext());
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:segmentImage];
//    imageView.frame = natureImageRect;
//    [self.layer addSublayer:imageView.layer];
    
    //[natureImage drawInRect:natureImageRect];
//    [natureImage drawInRect:natureImageRect blendMode:kCGBlendModeNormal alpha:1];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    //draw image in the context
//    //CGContextDrawImage(context, CGRectMake(160, 373, 21, 8), image.CGImage);
//    //[image drawInRect:CGRectMake(160, 410, 21, 8)];
//    
//    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, image.size.height);
//    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(160, 410, 21, 8), image.CGImage);
    
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    //NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:@"Image.png"];
//    //[fileManager createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
//    NSData *imageData = UIImagePNGRepresentation(image);
//    NSError *writeError = nil;
//    BOOL success = [imageData writeToFile:finalPath options:0 error:&writeError];
//    if (!success || writeError != nil)
//    {
//        NSLog(@"Error Writing: %@",writeError.description);
//    }
    
    if (!triggered) {
        // Set paths
        
        _shapeLayer.path = path;
        _shapeLayer.shadowPath = path;
        
        // Add the arrow shape
        
        CGFloat currentArrowSize = lerp(kMinArrowSize, kMaxArrowSize, percentage);
        CGFloat currentArrowRadius = lerp(kMinArrowRadius, kMaxArrowRadius, percentage);
        CGFloat arrowBigRadius = currentArrowRadius + (currentArrowSize / 2);
        CGFloat arrowSmallRadius = currentArrowRadius - (currentArrowSize / 2);
        
        CGMutablePathRef arrowPath = CGPathCreateMutable();
        CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowBigRadius, 0, 3 * M_PI_2, NO);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius - currentArrowSize);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x + (2 * currentArrowSize), topOrigin.y - arrowBigRadius + (currentArrowSize / 2));
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + (2 * currentArrowSize));
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + currentArrowSize);
        CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowSmallRadius, 3 * M_PI_2, 0, YES);
        CGPathCloseSubpath(arrowPath);
        _arrowLayer.path = arrowPath;
        [_arrowLayer setFillRule:kCAFillRuleEvenOdd];
        CGPathRelease(arrowPath);
        
        // Add the highlight shape
        
        CGMutablePathRef highlightPath = CGPathCreateMutable();
        CGPathAddArc(highlightPath, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0, M_PI, YES);
        CGPathAddArc(highlightPath, NULL, topOrigin.x, topOrigin.y + 1.25, currentTopRadius, M_PI, 0, NO);
        
        _highlightLayer.path = highlightPath;
        [_highlightLayer setFillRule:kCAFillRuleNonZero];
        CGPathRelease(highlightPath);

        
        // CGRectMake(0, -(kTotalViewHeight + scrollView.contentInset.top), scrollView.frame.size.width, kTotalViewHeight)
        
//        /* The rectangular space in which the ellipse has to be drawn */
//        CGRect ellipseRect = CGRectMake(160.0f,   /* X */
//                                        370.0f,   /* Y */
//                                        5.0f,   /* Width */
//                                        5.0f);  /* Height */
//        
//        /* The blue color's components */
//        const CGFloat *ellipseColorComponents =
//        CGColorGetComponents([UIColor redColor].CGColor);
//        
//        /* Set the blue color as the current fill color */
//        CGContextSetFillColor(context, ellipseColorComponents);
//        
//        /* And finally draw the ellipse */
//        CGContextFillEllipseInRect(context, ellipseRect);
        
//        float absolute = fabsf(_lastOffset);
//        if (absolute > 68) {
//            float origin = 353 - (absolute-64);
//            _pulseLayer.position = CGPointMake(160, origin);
//        } else {
//            _pulseLayer.position = CGPointMake(160, 353);
//        }
//        
//        
//        if (absolute > 68) {
//            float origin = 373 - (absolute-64);
//            _eyeLayer.position = CGPointMake(160, origin);
//        } else {
//            _eyeLayer.position = CGPointMake(160, 373);
//        }
        
        
//        NSLog(@"Eye Layer === %@", NSStringFromCGPoint(_eyeLayer.position));
//        NSLog(@"Offset Layer === %f", _lastOffset);
//        NSLog(@"Current Top Padding ==== %f", currentTopPadding);
    } else {
        // Start the shape disappearance animation
        
        CGFloat radius = lerp(kMinBottomRadius, kMaxBottomRadius, 0.2);
        CABasicAnimation *pathMorph = [CABasicAnimation animationWithKeyPath:@"path"];
        pathMorph.duration = 0.15;
        pathMorph.fillMode = kCAFillModeForwards;
        pathMorph.removedOnCompletion = NO;
        CGMutablePathRef toPath = CGPathCreateMutable();
        CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, 0, M_PI, YES);
        CGPathAddCurveToPoint(toPath, NULL, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y);
        CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, M_PI, 0, YES);
        CGPathAddCurveToPoint(toPath, NULL, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y);
        CGPathCloseSubpath(toPath);
        pathMorph.toValue = (__bridge id)toPath;
        [_shapeLayer addAnimation:pathMorph forKey:nil];
        
        CABasicAnimation *shadowPathMorph = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        shadowPathMorph.duration = 0.15;
        shadowPathMorph.fillMode = kCAFillModeForwards;
        shadowPathMorph.removedOnCompletion = NO;
        shadowPathMorph.toValue = (__bridge id)toPath;
        [_shapeLayer addAnimation:shadowPathMorph forKey:nil];
        CGPathRelease(toPath);
        
        CABasicAnimation *shapeAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shapeAlphaAnimation.duration = 0.1;
        shapeAlphaAnimation.beginTime = CACurrentMediaTime() + 0.1;
        shapeAlphaAnimation.toValue = [NSNumber numberWithFloat:0];
        shapeAlphaAnimation.fillMode = kCAFillModeForwards;
        shapeAlphaAnimation.removedOnCompletion = NO;
        [_shapeLayer addAnimation:shapeAlphaAnimation forKey:nil];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.duration = 0.1;
        alphaAnimation.toValue = [NSNumber numberWithFloat:0];
        alphaAnimation.fillMode = kCAFillModeForwards;
        alphaAnimation.removedOnCompletion = NO;
        [_arrowLayer addAnimation:alphaAnimation forKey:nil];
        //[_eyeLayer addAnimation:alphaAnimation forKey:nil];
        //[_pulseLayer addAnimation:alphaAnimation forKey:nil];
        [_highlightLayer addAnimation:alphaAnimation forKey:nil];
        
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        //_activity.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        //_imageView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        [CATransaction commit];
        
        [UIView animateWithDuration:0.2 delay:0.15 options:UIViewAnimationOptionCurveLinear animations:^{
            _imageView.alpha = 1;
            //_imageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
            [self startLoadingAnimation];
            
            //_activity.alpha = 1;
            //_activity.layer.transform = CATransform3DMakeScale(1, 1, 1);
        } completion:nil];
        
        self.refreshing = YES;
        _canRefresh = NO;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    CGPathRelease(path);
}

- (void)startLoadingAnimation
{    
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=1; i <= 4; i++) {
        NSString *strImgeName = [NSString stringWithFormat:@"loading%d.png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        if (!image) {
            NSLog(@"Could not load image named: %@", strImgeName);
        }
        else {
            [imgListArray addObject:image];
        }
    }
    [_imageView setAnimationImages:imgListArray];
    //_imageView.animationRepeatCount = 4;
    _imageView.animationDuration = 1.0;
    [_imageView startAnimating];
}

- (UIImage *)image:(UIImage *)img
{
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    //     CGContextTranslateCTM(context, 0, img.size.height);
    //    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}


- (void)stopLoadingAnimation
{
    [_imageView stopAnimating];
}

- (void)beginRefreshing
{
    if (!_refreshing) {
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.duration = 0.0001;
        alphaAnimation.toValue = [NSNumber numberWithFloat:0];
        alphaAnimation.fillMode = kCAFillModeForwards;
        alphaAnimation.removedOnCompletion = NO;
        
        [_shapeLayer addAnimation:alphaAnimation forKey:nil];
        [_arrowLayer addAnimation:alphaAnimation forKey:nil];
        //[_eyeLayer addAnimation:alphaAnimation forKey:nil];
        //[_pulseLayer addAnimation:alphaAnimation forKey:nil];
        [_highlightLayer addAnimation:alphaAnimation forKey:nil];
        
        _imageView.alpha = 1;
        //_imageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        [self startLoadingAnimation];
        
        //_activity.alpha = 1;
        //_activity.layer.transform = CATransform3DMakeScale(1, 1, 1);

        CGPoint offset = self.scrollView.contentOffset;
        _ignoreInset = YES;
        [self.scrollView setContentInset:UIEdgeInsetsMake(kOpenedViewHeight + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
        _ignoreInset = NO;
        [self.scrollView setContentOffset:offset animated:NO];

        self.refreshing = YES;
        _canRefresh = NO;
        
    }
}

- (void)endRefreshing
{
    if (_refreshing) {
        self.refreshing = NO;
        // Create a temporary retain-cycle, so the scrollView won't be released
        // halfway through the end animation.
        // This allows for the refresh control to clean up the observer,
        // in the case the scrollView is released while the animation is running
        __block UIScrollView *blockScrollView = self.scrollView;
        [UIView animateWithDuration:0.4 animations:^{
            _ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            _ignoreInset = NO;
            
            _imageView.alpha = 0;
            //_imageView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
            [self stopLoadingAnimation];
            
            //_activity.alpha = 0;
            //_activity.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        } completion:^(BOOL finished) {
            [_shapeLayer removeAllAnimations];
            _shapeLayer.path = nil;
            _shapeLayer.shadowPath = nil;
            _shapeLayer.position = CGPointZero;
            
            [_arrowLayer removeAllAnimations];
            _arrowLayer.path = nil;
            //[_eyeLayer removeAllAnimations];
            //[_pulseLayer removeAllAnimations];
            
            [_highlightLayer removeAllAnimations];
            _highlightLayer.path = nil;
            // We need to use the scrollView somehow in the end block,
            // or it'll get released in the animation block.
            _ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            _ignoreInset = NO;
        }];
    }
}

@end
