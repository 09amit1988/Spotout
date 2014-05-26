//
//  LocationCell.h
//  Lifester
//
//  Created by MAC205 on 07/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell
{
    
}
@property (nonatomic, retain) IBOutlet UILabel *lblLocationName;
@property (nonatomic, retain) IBOutlet UILabel *lblAddress;
@property (nonatomic, retain) IBOutlet UIImageView *imvLocation;
@property (nonatomic, retain) IBOutlet UIImageView *imvBottomLine;

@end
