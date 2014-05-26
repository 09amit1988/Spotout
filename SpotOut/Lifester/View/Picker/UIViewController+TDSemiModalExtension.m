//
//  UIViewController+TDSemiModalExtension.m
//  TDSemiModal
//
//  Created by Nathan  Reed on 18/10/10.
//  Copyright 2010 Nathan Reed. All rights reserved.
//

#import "UIViewController+TDSemiModalExtension.h"

@implementation UIViewController (TDSemiModalExtension)

// Use this to show the modal view (pops-up from the bottom)
- (void) presentSemiModalViewController:(TDSemiModalViewController*)vc {
#define DEGREES_TO_RADIANS(x) (M_PI * (x)/180.0)

	
	UIView* modalView = vc.view;
	UIView* coverView = vc.coverView;

	//UIWindow* mainWindow = [(id)[[UIApplication sharedApplication] delegate] window];

	CGPoint middleCenter = self.view.center;
	CGSize offSize = [UIScreen mainScreen].bounds.size;

	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];

	CGPoint offScreenCenter = CGPointZero;
    
    if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        //iPhone, iPhone retina
        if(orientation == UIInterfaceOrientationLandscapeLeft ||
           orientation == UIInterfaceOrientationLandscapeRight) {
            
            offScreenCenter = CGPointMake(offSize.height / 2.0, offSize.width * 1.2);
            middleCenter = CGPointMake(middleCenter.y, middleCenter.x);
            [modalView setBounds:CGRectMake(0, 0, 480, 320)];
        }
        else {
            offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.2);
            [modalView setBounds:CGRectMake(0, 0, 320, 480)];
            [coverView setFrame:CGRectMake(0, 0, 320, 480)];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
                [modalView setBounds:CGRectMake(0, -80, 320, 568)];
                [coverView setFrame:CGRectMake(0, -80, 320, 568)];
            }
        }
    }
    else //568 height
    {
        // iPhone 5
        if(orientation == UIInterfaceOrientationLandscapeLeft ||
           orientation == UIInterfaceOrientationLandscapeRight) {
            
            offScreenCenter = CGPointMake(offSize.height / 2.0, offSize.width * 1.2);
            middleCenter = CGPointMake(middleCenter.y, middleCenter.x);
            [modalView setBounds:CGRectMake(0, 0, 568, 320)];
        }
        else {
            offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.2);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                [modalView setBounds:CGRectMake(0, -90, 320, 568)];
                [coverView setFrame:CGRectMake(0, -90, 320, 568)];
                modalView.center = offScreenCenter;
            } else {
                [modalView setBounds:CGRectMake(0, -90, 320, 568)];
                [coverView setFrame:CGRectMake(0, -90, 320, 568)];
            }
        }
    }
    
	// we start off-screen
	//modalView.center = offScreenCenter;
	 
	coverView.alpha = 0.0f;
	
	[self.view addSubview:coverView];
	[self.view addSubview:modalView];
	
	// Show it with a transition effect
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	
	modalView.center = middleCenter;
	coverView.alpha = 0.5;

	[UIView commitAnimations];

}

// Use this to slide the semi-modal view back down.
-(void) dismissSemiModalViewController:(TDSemiModalViewController*)vc {
	//double animationDelay = 0.5;
	UIView* modalView = vc.view;
	UIView* coverView = vc.coverView;

	CGSize offSize = [UIScreen mainScreen].bounds.size;

	CGPoint offScreenCenter = CGPointZero;
	
	UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
	if(orientation == UIInterfaceOrientationLandscapeLeft || 
			orientation == UIInterfaceOrientationLandscapeRight) {
		offScreenCenter = CGPointMake(offSize.height / 2.0, offSize.width * 1.5);		
	}
	else {
		offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	}

	[UIView beginAnimations:nil context:modalView];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(dismissSemiModalViewControllerEnded:finished:context:)];
	modalView.center = offScreenCenter;
	coverView.alpha = 0.0f;
	[UIView commitAnimations];

	[coverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6];

}

- (void) dismissSemiModalViewControllerEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIView* modalView = (UIView*)context;
	[modalView removeFromSuperview];

}

@end
