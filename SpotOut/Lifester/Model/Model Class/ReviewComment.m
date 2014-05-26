//
//  ReviewComment.m
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import "ReviewComment.h"
#import "NSString+Extensions.h"

@implementation ReviewComment

@synthesize userID;
@synthesize username;
@synthesize profileName;
@synthesize profileImage;
@synthesize profileRating;

@synthesize hasProfilePicture;
@synthesize isReadMoreExplanded;

@synthesize profileReviewID;
@synthesize rating;
@synthesize comment;
@synthesize timeDifference;

- (ReviewComment *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.userID = [dictionary objectForKey:@"user_id"];
        self.profileReviewID = [dictionary objectForKey:@"profile_review_id"];
        self.isReadMoreExplanded = NO;
        
        if ([dictionary objectForKey:@"avg_rating"]) {
            self.profileRating = [[dictionary objectForKey:@"avg_rating"] floatValue];
        } else {
            self.profileRating = 0;
        }
        
        self.username = [dictionary objectForKey:@"username"];
        self.profileName = [dictionary objectForKey:@"profilename"];
        self.timeDifference = [dictionary objectForKey:@"time_difference"];
        
        if (![[dictionary objectForKey:@"profile_picture_id"] checkNullText]) {
            self.profileImage = [dictionary objectForKey:@"profile_picture_id"];
        } else {
            self.profileImage = @"";
        }
        
        self.hasProfilePicture = [[dictionary objectForKey:@"has_profiole_picture"] boolValue];
        if ([dictionary objectForKey:@"rating"]) {
            self.rating = [[dictionary objectForKey:@"rating"] floatValue];
        } else {
            self.rating = 0.0;
        }
        
        if ([dictionary objectForKey:@"comment"]) {
            self.comment = [dictionary objectForKey:@"comment"];
        } else {
            self.comment = @"";
        }
        
    }
    return self;
}

@end
