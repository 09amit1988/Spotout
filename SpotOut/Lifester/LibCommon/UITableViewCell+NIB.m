//
//  UITableViewCell+NIB.m
//  Coffee Learning
//

#include "UITableViewCell+NIB.h"
#include "UIView+NIB.h"

@implementation UITableViewCell (Extend)

+ (id)loadViewFromNib
{
	id object = [super loadViewFromNib];
	if ([object isKindOfClass:self]) {
		UITableViewCell *cell = object;
		[cell setValue:[self cellID] forKey:@"_reuseIdentifier"];
		return cell;
	}
	
	return nil;
}

+ (NSString*)cellID
{
	return [self description];
}

+ (id)dequeOrCreateInTable:(UITableView*)tableView
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[self cellID]];
	return cell ? cell : [self loadViewFromNib];
}

@end
