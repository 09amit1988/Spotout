//
//  CRNavigationController.m
//  CRNavigationControllerExample
//
//  Created by Corey Roberts on 9/24/13.
//  Copyright (c) 2013 SpacePyro Inc. All rights reserved.
//

#import "CRNavigationController.h"
#import "CRNavigationBar.h"

@interface CRNavigationController ()

@end

@implementation CRNavigationController

- (id)init {
    self = [super initWithNavigationBarClass:[CRNavigationBar class] toolbarClass:nil];
    if(self) {
        // Custom initialization here, if needed.
        
        // To override the opacity of CRNavigationBar's barTintColor, set this value to YES.
        ((CRNavigationBar *)self.navigationBar).overrideOpacity = NO;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[CRNavigationBar class] toolbarClass:nil];
    if(self) {
        self.viewControllers = @[rootViewController];
        
        // To override the opacity of CRNavigationBar's barTintColor, set this value to YES.
        ((CRNavigationBar *)self.navigationBar).overrideOpacity = NO;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            ((CRNavigationBar *)self.navigationBar).barTintColor = NAVI_BARTINTCOLOR;
        } else {
            //((CRNavigationBar *)self.navigationBar).tintColor = NAVI_BARTINTCOLOR;
        }
        [((CRNavigationBar *)self.navigationBar) displayColorLayer:YES];
    }
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
