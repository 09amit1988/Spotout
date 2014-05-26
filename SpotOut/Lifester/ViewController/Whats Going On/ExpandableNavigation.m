//
//  ExpandableNavigation.m
//  PathMenuExample
//
//  Created by Tobin Schwaiger-Hastanan on 1/8/12.
//  Copyright (c) 2012 Tobin Schwaiger-Hastanan. All rights reserved.
//

#import "ExpandableNavigation.h"

@implementation ExpandableNavigation

@synthesize mainButton = _mainButton;
@synthesize overlayButton = _overlayButton;
@synthesize menuItems = _menuItems;
@synthesize radius = _radius;
@synthesize speed;
@synthesize bounce;
@synthesize bounceSpeed;
@synthesize expanded;
@synthesize transition;


- (id)initWithMenuItems:(NSArray*) menuItems mainButton:(UIButton*) mainButton radius:(CGFloat) radius overlay:(UIButton*)btnOverlay {

    if( self = [super init] ) {
        self.menuItems = menuItems;
        self.mainButton = mainButton;
        self.overlayButton = btnOverlay;
        self.radius = radius;
        self.speed = 0.30;
        self.bounce = 0.205;
        self.bounceSpeed = 0.2;
        expanded = NO;
        transition = NO;
        [self.overlayButton setHidden:YES];
        [self.overlayButton setAlpha:0.0];
        
        if( self.mainButton != nil ) {
            for (UIView* view in self.menuItems) {

                view.center = CGPointMake(self.mainButton.center.x/2, self.mainButton.center.y);// self.mainButton.center;
                view.alpha = 0.0;
            }
            
            [self.mainButton addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return self;
}

- (id)init {
    // calling the default init method is not allowed, this will raise an exception if it is called.
    if( self = [super init] ) {
        [self release];
        [self doesNotRecognizeSelector:_cmd];
    }
    return nil;
}

- (void) expand {
    transition = YES;
    
    [UIView animateWithDuration:self.speed animations:^{
        [self.overlayButton setHidden:NO];
        [self.overlayButton setAlpha:0.7];
        
        self.mainButton.transform = CGAffineTransformMakeRotation( 90.0 * M_PI/180 );
        [self.mainButton setImage:[UIImage imageNamed:@"cancel-city-icon.png"] forState:UIControlStateNormal];
    } completion:^(BOOL finished){
        
    }];
    
    for (UIView* view in self.menuItems) {
        int index = [self.menuItems indexOfObject:view];
        float angle = (90>=360)?(360/3):((3>1)?(90/(3-1)):0.0f);
        
        CGFloat oneOverCount = self.menuItems.count<=1?1.0:(1.0/(self.menuItems.count-1));
        CGFloat indexOverCount = index * oneOverCount;
        
        //CGFloat rad = (angle * (indexOverCount - 1) + 48) * (M_PI/180);
        CGFloat rad = ((1.0 - indexOverCount) * 90.0 )* (M_PI/180);
        CGAffineTransform rotation = CGAffineTransformMakeRotation( rad );
        CGFloat x = (self.radius + self.bounce * self.radius) * rotation.a;
        CGFloat y = (self.radius + self.bounce * self.radius) * rotation.c;
        CGPoint center = CGPointMake( view.center.x + x , view.center.y + y);
        [UIView animateWithDuration: self.speed
                              delay: self.speed * indexOverCount
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.center = center;
                             view.alpha = 1.0;
                         } 
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:self.bounceSpeed
                                              animations:^{
                                                  CGFloat x = self.bounce * self.radius * rotation.a;
                                                  CGFloat y = self.bounce * self.radius * rotation.c;
                                                  CGPoint center = CGPointMake( view.center.x - x , view.center.y - y);
                                                  //view.center = center;
                                                  view.alpha = 1.0;
                                              }];
                             if( view == self.menuItems.lastObject ) {
                                 expanded = YES;
                                 transition = NO;
                             }
                         }];                                                                        
    }
}

- (void) collapse {
    transition = YES;
    
    [UIView animateWithDuration:self.speed animations:^{
        self.mainButton.transform = CGAffineTransformMakeRotation( 0 );
    } completion:^(BOOL finished){
        [self.mainButton setImage:[UIImage imageNamed:@"main-icon-normal.png"] forState:UIControlStateNormal];
        [self.overlayButton setHidden:YES];
        [self.overlayButton setAlpha:0.0];
    }];
    
    for (UIView* view in self.menuItems) {
        int index = [self.menuItems indexOfObject:view];
        CGFloat oneOverCount = self.menuItems.count<=1?1.0:(1.0/(self.menuItems.count-1));
        CGFloat indexOverCount = index * oneOverCount;
        [UIView animateWithDuration:self.speed
                              delay:(1.0 - indexOverCount) * self.speed
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.center = self.mainButton.center;
                         } 
                         completion:^(BOOL finished){
                             view.alpha = 0.0;
                             if( view == self.menuItems.lastObject ) {
                                 expanded = NO;
                                 transition = NO;
                             }
                         }];                                                                         
    }
}

- (IBAction)press:(id)sender {
    if( !self.transition ) {
        if( !self.expanded ) {
            [self expand];
        } else {
            [self collapse];
        }
    }
}

- (void)dealloc {
    self.mainButton = nil;
    self.menuItems = nil;
    [super dealloc];
}

@end
