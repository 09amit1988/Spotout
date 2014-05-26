//
//  JingDianMapCell.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingDianMapCell : UIView
{
    UILabel *lblLocation;
    UILabel *lblAddress;
    UILabel *lblDistance;
}
@property (nonatomic, strong) IBOutlet UILabel *lblLocation;
@property (nonatomic, strong) IBOutlet UILabel *lblAddress;
@property (nonatomic, strong) IBOutlet UILabel *lblDistance;
@property (nonatomic,strong) IBOutlet UILabel *lblWaitmins;
@property (nonatomic,strong) IBOutlet UILabel *lblTime;
@property (nonatomic,strong) IBOutlet UIButton *btnTimeEvent;


@end
