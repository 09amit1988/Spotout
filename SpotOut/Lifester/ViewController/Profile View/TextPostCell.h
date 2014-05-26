//
//  TextPostCell.h
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextPostCell : UITableViewCell
{
    IBOutlet UIImageView *imgProfileUser;
    IBOutlet UILabel *lblUserName;
    
    IBOutlet UILabel *lblTagNames;
    IBOutlet UIButton *btnBookmark;
    IBOutlet UILabel *lblDescription;
    IBOutlet UIButton *btnReadMore;
    IBOutlet UIButton *btnTextLink;
    
    IBOutlet UIImageView *imgLine1;
    IBOutlet UILabel *lblTextPostTime;
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UILabel *lblShareCount;
    
    IBOutlet UIButton *btnLike;
    
    IBOutlet UIView *viewInviteFriend;
    IBOutlet UIView *viewLikeComment;
}

@property (nonatomic,retain) IBOutlet UIImageView *imgProfileUser;
@property (nonatomic,retain) IBOutlet UILabel *lblUserName;

@property (nonatomic,retain) IBOutlet UILabel *lblTagNames;
@property (nonatomic,retain) IBOutlet UIButton *btnBookmark;
@property (nonatomic,retain) IBOutlet UILabel *lblDescription;
@property (nonatomic,retain) IBOutlet UIButton *btnReadMore;
@property (nonatomic,retain) IBOutlet UIButton * btnTextLink;

@property (nonatomic,retain) IBOutlet UIImageView *imgLine1;
@property (nonatomic,retain) IBOutlet UILabel *lblTextPostTime;
@property (nonatomic,retain) IBOutlet UILabel *lblLikeCount;
@property (nonatomic,retain) IBOutlet UILabel *lblCommentCount;
@property (nonatomic,retain) IBOutlet UILabel *lblShareCount;

@property (nonatomic,retain) IBOutlet UIButton *btnLike;

@property (nonatomic,retain) IBOutlet UIView *viewInviteFriend;
@property (nonatomic,retain) IBOutlet UIView *viewLikeComment;

@end
