//
//  CityMenuView.h
//  MediaApp
//
//  Created by Nikunj on 12/26/13.
//  Copyright (c) 2013 Jitendra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableNavigation.h"
#import "AppDelegate.h"
#import "ALRadialMenu.h"


@interface CityMenuView : UIView <ALRadialMenuDelegate>
{
    
}
@property (nonatomic, retain) IBOutlet UIButton *btnCityIcon;
@property (nonatomic, retain) IBOutlet UIButton *btnOverlay;

@property (strong, nonatomic) ALRadialMenu *socialMenu;

@end
