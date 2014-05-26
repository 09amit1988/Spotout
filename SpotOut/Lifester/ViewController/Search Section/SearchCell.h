//
//  SearchCell.h
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface SearchCell : UITableViewCell
{
    UIImageView *imgLine1;
    UIView *profileView;
    UIView *postView;
    UIView *tagView;
    
    UIImageView *imvProfileUser;
    UILabel *lblUserName;
    UILabel *lblProfileName;
    UILabel *lblLocationName;
    OHAttributedLabel *lblDescription;
    UIButton *btnReadMore;
    UILabel *lblTagNames;
    UIButton *btnTagNames;
    UIButton *btnFollow;
}

@property (nonatomic,retain) IBOutlet UIImageView *imgLine1;
@property (nonatomic,retain) IBOutlet UIView *profileView;
@property (nonatomic,retain) IBOutlet UIView *postView;
@property (nonatomic,retain) IBOutlet UIView *tagView;

@property (nonatomic, retain) IBOutlet UIImageView *imvProfileUser;
@property (nonatomic, retain) IBOutlet UILabel *lblUserName;
@property (nonatomic, retain) IBOutlet UILabel *lblProfileName;
@property (nonatomic, retain) IBOutlet UILabel *lblLocationName;
@property (nonatomic, retain) IBOutlet OHAttributedLabel *lblDescription;
@property (nonatomic, retain) IBOutlet UIButton *btnReadMore;
@property (nonatomic, retain) IBOutlet UILabel *lblTagNames;
@property (nonatomic, retain) IBOutlet UIButton *btnTagNames;
@property (nonatomic, retain) IBOutlet UIButton *btnFollow;

@end
