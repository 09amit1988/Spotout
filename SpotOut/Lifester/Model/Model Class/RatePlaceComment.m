//
//  RatePlaceComment.m
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import "RatePlaceComment.h"
#import "NSString+Extensions.h"

@implementation RatePlaceComment

@synthesize userID;
@synthesize username;
@synthesize profileName;
@synthesize profileImagePath;
@synthesize hasProfilePicture;

@synthesize placeReviewID;
@synthesize rating;
@synthesize comment;
@synthesize commentUserID;
@synthesize timeDifference;

- (RatePlaceComment *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.userID = [dictionary objectForKey:@"user_id"];
        self.placeReviewID = [dictionary objectForKey:@"place_review_id"];
        self.commentUserID = [dictionary objectForKey:@"comment_userid"];
        
        self.username = [dictionary objectForKey:@"username"];
        self.profileName = [dictionary objectForKey:@"profilename"];
        self.timeDifference = [dictionary objectForKey:@"time_difference"];
        
        if (![[dictionary objectForKey:@"profile_picture_id"] checkNullText]) {
            self.profileImagePath = [dictionary objectForKey:@"profile_picture_id"];
        } else {
            self.profileImagePath = @"";
        }
        
        self.hasProfilePicture = [[dictionary objectForKey:@"has_profiole_picture"] boolValue];
        if ([dictionary objectForKey:@"rating"]) {
            self.rating = [[dictionary objectForKey:@"rating"] floatValue];
        } else {
            self.rating = 0.0;
        }
        
        if ([dictionary objectForKey:@"tips_comment"]) {
            self.comment = [dictionary objectForKey:@"tips_comment"];
        } else {
            self.comment = @"";
        }
        
    }
    return self;
}

@end
