//
//  ProfileViewCell.h
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"

@interface ProfileViewCell : UITableViewCell
{
    IBOutlet UIImageView *imgLine1;
    IBOutlet UIImageView *imgProfileUser;
    IBOutlet UIView * locationSection;
    IBOutlet UIView * viewRatePlace;
    IBOutlet UIView * viewLikeComment;
    
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblDescription;
    IBOutlet UIButton *btnPlaceLink;
    IBOutlet UIButton *btnReadMore;

    IBOutlet UIImageView *imvPlacePost;
    IBOutlet UIButton *btnPlacePost;
    
    IBOutlet UILabel *lblActivityTitle;
    IBOutlet UILabel *lblFirstLocationName;
    IBOutlet UILabel *lblCategoryType;
    IBOutlet UILabel *lblSecondLocationName;
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UILabel *lblShareCount;
    IBOutlet UILabel *lblTagNames;
    IBOutlet UILabel *lblDistanceFromLocation;
    IBOutlet THLabel *lblPictureCount;
    IBOutlet UILabel *lblTime;
    
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnComment;
    IBOutlet UIButton *btnShare;
    IBOutlet UIButton *btnRePost;
}
@property (nonatomic,retain) IBOutlet UIImageView *imgLine1;
@property (nonatomic,retain) IBOutlet UIView * locationSection;

@property (nonatomic, retain) IBOutlet UILabel *lblUserName;
@property (nonatomic, retain) IBOutlet UILabel *lblDescription;
@property (nonatomic, retain) IBOutlet UIButton *btnPlaceLink;
@property (nonatomic, retain) IBOutlet UIButton *btnReadMore;
@property (nonatomic, retain) IBOutlet UIButton *btnBookmark;

@property (nonatomic, retain) IBOutlet UIImageView *imvPlacePost;
@property (nonatomic, retain) IBOutlet UIButton *btnPlacePost;

@property (nonatomic, retain) IBOutlet UILabel *lblActivityTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblFirstLocationName;
@property (nonatomic, retain) IBOutlet UILabel *lblCategoryType;

@property (nonatomic, retain) IBOutlet UILabel *lblSecondLocationName;
@property (nonatomic, retain) IBOutlet UILabel *lblLocationCategoryType;
@property (nonatomic, retain) IBOutlet UILabel *lblLocationStreet;
@property (nonatomic, retain) IBOutlet UILabel *lblLocationAddress;
@property (nonatomic, retain) IBOutlet MKMapView *mapview;

@property (nonatomic, retain) IBOutlet UIButton *btnLocation;
@property (nonatomic, retain) IBOutlet UIButton *btnMapView;

@property (nonatomic, retain) IBOutlet UILabel *lblLikeCount;
@property (nonatomic, retain) IBOutlet UILabel *lblCommentCount;
@property (nonatomic, retain) IBOutlet UILabel *lblShareCount;
@property (nonatomic, retain) IBOutlet UILabel *lblTagNames;
@property (nonatomic, retain) IBOutlet UILabel *lblDistanceFromLocation;
@property (nonatomic, retain) IBOutlet THLabel *lblPictureCount;
@property (nonatomic, retain) IBOutlet UIImageView *imgProfileUser;
@property (nonatomic, retain) IBOutlet UIView * viewRatePlace;
@property (nonatomic, retain) IBOutlet UIView * viewLikeComment;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;

@property (nonatomic, retain) IBOutlet UIButton *btnLike;
@property (nonatomic, retain) IBOutlet UIButton *btnComment;
@property (nonatomic, retain) IBOutlet UIButton *btnShare;
@property (nonatomic, retain) IBOutlet UIButton *btnRePost;


@end
