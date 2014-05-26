//
//  UITableViewCell+NIB.h
//  Coffee Learning
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewCell (Extend)

+ (NSString *)cellID;
+ (id)dequeOrCreateInTable:(UITableView *)tableView;

@end
