//
//  UIView+NIB.h
//  Coffee Learning
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

+ (id)loadViewFromNib;
+ (id)loadViewFromNib:(NSString*)nibName;

@end
