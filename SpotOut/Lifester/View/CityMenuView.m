//
//  CityMenuView.m
//  MediaApp
//
//  Created by Nikunj on 12/26/13.
//  Copyright (c) 2013 Jitendra. All rights reserved.
//

#import "CityMenuView.h"
#import "UIView+NIB.h"
#import "OfferReviewViewController.h"
#import "AddEventViewController.h"
#import "ActivityViewController.h"

@implementation CityMenuView

#pragma mark - Life cycle


@synthesize btnCityIcon, btnOverlay;

- (id)initWithFrame:(CGRect)frame
{
    self = [CityMenuView loadViewFromNib:@"CityMenuView"];
    if (self) {
        self.socialMenu = [[ALRadialMenu alloc] init];
        self.socialMenu.delegate = self;
        //[self.socialMenu buttonsWillAnimateFromButton:self.btnCityIcon withFrame:btnCityIcon.frame inView:self];
        
        [self buttonPressed:btnCityIcon];
    }
    return self;
}

- (IBAction)buttonPressed:(id)sender {
	//the button that brings the items into view was pressed
    
    if (IS_IPHONE_5) {
    } else {
        self.btnCityIcon.frame = CGRectMake(self.btnCityIcon.frame.origin.x, 434, self.btnCityIcon.frame.size.width, self.btnCityIcon.frame.size.height);
    }
    
    [self.socialMenu buttonsWillAnimateFromButton:sender withFrame:self.btnCityIcon.frame inView:self];
}

#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
	//FIXME: dipshit, change one of these variable names
	if (radialMenu == self.socialMenu) {
		return 3;
	}
	
	return 0;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
	if (radialMenu == self.socialMenu) {
		return 150;
	}
	
	return 0;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
	if (radialMenu == self.socialMenu) {
		return 105;
	}
	
	return 0;
}


- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
	if (radialMenu == self.socialMenu) {
		if (index == 1) {
			return [UIImage imageNamed:@"offer-menu.png"];
		} else if (index == 2) {
			return [UIImage imageNamed:@"events.png"];
		} else if (index == 3) {
			return [UIImage imageNamed:@"activities-menu.png"];
		}
	}
	
	return nil;
}

- (NSString *)radialMenuName:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index
{
    if (radialMenu == self.socialMenu) {
		if (index == 1) {
			return @"Offer";
		} else if (index == 2) {
			return @"Event";
		} else if (index == 3) {
			return @"Activity";
		}
	}
	
	return nil;
}

- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate removeCityMenuOverlay];
    
	if (radialMenu == self.socialMenu) {
		[self.socialMenu itemsWillDisapearIntoButton:self.btnCityIcon];
		if (index == 1) {
            OfferReviewViewController *viewController = [[OfferReviewViewController alloc]initWithNibName:@"OfferReviewViewController" bundle:nil];
            [appDelegate.tabBarController.navigationController pushViewController:viewController animated:YES];
		} else if (index == 2) {
			AddEventViewController *viewController = [[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
            [appDelegate.tabBarController.navigationController pushViewController:viewController animated:YES];
		} else if (index == 3) {
            ActivityViewController *viewController = [[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:nil];
            [appDelegate.tabBarController.navigationController pushViewController:viewController animated:YES];
		}
	}
    
}


@end
