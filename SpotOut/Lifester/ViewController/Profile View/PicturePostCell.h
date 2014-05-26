//
//  PicturePostCell.h
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicturePostCell : UITableViewCell
{
    IBOutlet UIImageView *imgProfileUser;
    IBOutlet UILabel *lblUserName;
    
    IBOutlet UIImageView *imvPicturePost;
    IBOutlet UIButton *btnPicturePost;
    IBOutlet UILabel *lblDistanceFromLocation;
    IBOutlet UILabel *lblPictureCount;
    
    IBOutlet UILabel *lblPictureTitle;
    IBOutlet UILabel *lblPictureLocationFirst;
    
    IBOutlet UILabel *lblTagNames;
    IBOutlet UIButton *btnBookmark;
    IBOutlet UILabel *lblDescription;
    IBOutlet UIButton *btnReadMore;
    IBOutlet UIButton *btnPictureLink;
    
    IBOutlet UIButton *btnPictureLocationSecond;
    IBOutlet UIImageView *imgLine1;
    
    IBOutlet UILabel *lblPicturePostTime;
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UILabel *lblShareCount;
    
    IBOutlet UIButton *btnLike;
    
    IBOutlet UIView *viewLocation;
    IBOutlet UIView *viewLikeComment;
}

@property (nonatomic,retain) IBOutlet UIImageView *imgProfileUser;
@property (nonatomic,retain) IBOutlet UILabel *lblUserName;

@property (nonatomic,retain) IBOutlet UIImageView *imvPicturePost;
@property (nonatomic,retain) IBOutlet UIButton *btnPicturePost;
@property (nonatomic,retain) IBOutlet UILabel *lblDistanceFromLocation;
@property (nonatomic,retain) IBOutlet UILabel *lblPictureCount;

@property (nonatomic,retain) IBOutlet UILabel *lblPictureTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblPictureLocationFirst;

@property (nonatomic,retain) IBOutlet UILabel *lblTagNames;
@property (nonatomic,retain) IBOutlet UIButton *btnBookmark;
@property (nonatomic,retain) IBOutlet UILabel *lblDescription;
@property (nonatomic,retain) IBOutlet UIButton *btnReadMore;
@property (nonatomic,retain) IBOutlet UIButton * btnPictureLink;

@property (nonatomic,retain) IBOutlet UIButton *btnPictureLocationSecond;
@property (nonatomic,retain) IBOutlet UIImageView *imgLine1;

@property (nonatomic,retain) IBOutlet UILabel *lblPicturePostTime;
@property (nonatomic,retain) IBOutlet UILabel *lblLikeCount;
@property (nonatomic,retain) IBOutlet UILabel *lblCommentCount;
@property (nonatomic,retain) IBOutlet UILabel *lblShareCount;

@property (nonatomic,retain) IBOutlet UIButton *btnLike;

@property (nonatomic,retain) IBOutlet UIView *viewLocation;
@property (nonatomic,retain) IBOutlet UIView *viewLikeComment;

@end
