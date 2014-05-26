//
//  EventPostCell.h
//  Lifester
//
//  Created by MAC205 on 16/01/14.
//  Copyright (c) 2014 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface EventPostCell : UITableViewCell
{
    IBOutlet UIImageView *imgProfileUser;
    IBOutlet UILabel *lblUserName;
    
    IBOutlet UIImageView *imvEventPost;
    IBOutlet UIButton *btnEventPost;
    IBOutlet UILabel *lblDistanceFromLocation;
    IBOutlet UILabel *lblPictureCount;
    
    IBOutlet UILabel *lblEventTitle;
    IBOutlet UILabel *lblEventTime;
    IBOutlet UILabel *lblTicketAvailable;
    
    IBOutlet UILabel *lblTagNames;
    IBOutlet UIButton *btnBookmark;
    IBOutlet UILabel *lblDescription;
    IBOutlet UIButton *btnReadMore;
    IBOutlet UIButton *btnEventLink;
    
    IBOutlet UILabel *lblEventLocation;
    IBOutlet UILabel *lblLocationCategoryType;
    IBOutlet UILabel *lblLocationStreet;
    IBOutlet UILabel *lblLocationAddress;
    IBOutlet MKMapView *mapview;
    
    IBOutlet UIButton *btnMoreTickets;
    
    IBOutlet UILabel *lblEventPostTime;
    IBOutlet UILabel *lblLikeCount;
    IBOutlet UILabel *lblCommentCount;
    IBOutlet UILabel *lblShareCount;
    
    IBOutlet UIView *locationSection;
    IBOutlet UIView *viewTicket;
    IBOutlet UIView *viewInviteFriend;
    IBOutlet UIView *viewLikeComment;
    
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnComment;
    IBOutlet UIButton *btnShare;
    IBOutlet UIButton *btnRePost;
}

@property (nonatomic,retain) IBOutlet UIImageView *imgProfileUser;
@property (nonatomic,retain) IBOutlet UILabel *lblUserName;

@property (nonatomic,retain) IBOutlet UIImageView *imvEventPost;
@property (nonatomic,retain) IBOutlet UIButton *btnEventPost;
@property (nonatomic,retain) IBOutlet UILabel *lblDistanceFromLocation;
@property (nonatomic,retain) IBOutlet UILabel *lblPictureCount;

@property (nonatomic,retain) IBOutlet UILabel *lblEventTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblEventTime;
@property (nonatomic,retain) IBOutlet UILabel *lblTicketAvailable;

@property (nonatomic,retain) IBOutlet UILabel *lblTagNames;
@property (nonatomic,retain) IBOutlet UIButton *btnBookmark;
@property (nonatomic,retain) IBOutlet UILabel *lblDescription;
@property (nonatomic,retain) IBOutlet UIButton *btnReadMore;
@property (nonatomic,retain) IBOutlet UIButton *btnEventLink;

@property (nonatomic, retain) IBOutlet UIImageView *imvLine1;
@property (nonatomic,retain) IBOutlet UILabel *lblEventLocation;
@property (nonatomic, retain) IBOutlet UILabel *lblLocationCategoryType;
@property (nonatomic, retain) IBOutlet UILabel *lblLocationStreet;
@property (nonatomic, retain) IBOutlet UILabel *lblLocationAddress;
@property (nonatomic, retain) IBOutlet MKMapView *mapview;

@property (nonatomic,retain) IBOutlet UIButton *btnMoreTickets;
@property (nonatomic, retain) IBOutlet UIButton *btnLocation;
@property (nonatomic, retain) IBOutlet UIButton *btnMapView;

@property (nonatomic,retain) IBOutlet UILabel *lblEventPostTime;
@property (nonatomic,retain) IBOutlet UILabel *lblLikeCount;
@property (nonatomic,retain) IBOutlet UILabel *lblCommentCount;
@property (nonatomic,retain) IBOutlet UILabel *lblShareCount;

@property (nonatomic,retain) IBOutlet UIView *locationSection;
@property (nonatomic,retain) IBOutlet UIView *viewTicket;
@property (nonatomic,retain) IBOutlet UIView *viewInviteFriend;
@property (nonatomic,retain) IBOutlet UIView *viewLikeComment;

@property (nonatomic, retain) IBOutlet UIButton *btnLike;
@property (nonatomic, retain) IBOutlet UIButton *btnComment;
@property (nonatomic, retain) IBOutlet UIButton *btnShare;
@property (nonatomic, retain) IBOutlet UIButton *btnRePost;

@end
