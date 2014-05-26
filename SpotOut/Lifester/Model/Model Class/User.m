//
//  User.m
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import "User.h"
#import "NSString+Extensions.h"

@implementation User

@synthesize userID;
@synthesize username;
@synthesize profileName;
@synthesize firstName;
@synthesize lastName;
@synthesize passKey;
@synthesize profileRating;

@synthesize profileImage;
@synthesize hasProfilePicture;

@synthesize followerCount;
@synthesize followingCount;
@synthesize reviewCount;

@synthesize followed;

- (User *)initWithDictionaryForLogin:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.userID = [dictionary objectForKey:@"user_id"];
        self.username = [dictionary objectForKey:@"username"];
        self.profileName = [dictionary objectForKey:@"ProfileName"];
        self.firstName = [dictionary objectForKey:@"f_name"];
        self.lastName = [dictionary objectForKey:@"l_name"];
        self.passKey = [dictionary objectForKey:@"pass_key"];
        self.profileRating = [[dictionary objectForKey:@"avg_rating_profile"] floatValue];
        
        if (![[[dictionary objectForKey:@"profile_image"] objectForKey:@"image_url"] checkNullText]) {
            self.profileImage = [[dictionary objectForKey:@"profile_image"] objectForKey:@"image_url"];
        } else {
            self.profileImage = @"";
        }
        
        self.hasProfilePicture = [[[dictionary objectForKey:@"profile_image"] objectForKey:@"has_profile_picture"] boolValue];
        
        self.followerCount = [dictionary objectForKey:@"follower_count"];
        self.followingCount = [dictionary objectForKey:@"following_count"];
        self.reviewCount = [dictionary objectForKey:@"review_count"];
    }
    return self;
}

- (User *)initWithDictionaryForProfileDetail:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.userID = [dictionary objectForKey:@"user_id"];
        self.username = [dictionary objectForKey:@"username"];
        self.profileName = [dictionary objectForKey:@"profilename"];
        self.firstName = [dictionary objectForKey:@"f_name"];
        self.lastName = [dictionary objectForKey:@"l_name"];
        self.profileRating = [[dictionary objectForKey:@"avg_rating_profile"] floatValue];
        
        if ([dictionary objectForKey:@"profile_image"]) {
            self.profileImage = [[dictionary objectForKey:@"profile_image"] objectForKey:@"profile_picture_id"];
            self.hasProfilePicture = [[[dictionary objectForKey:@"profile_image"] objectForKey:@"has_profiole_picture"] boolValue];
        } else {
            self.profileImage = @"";
            self.hasProfilePicture = NO;
        }
        
        
        
        self.followed = [[dictionary objectForKey:@"followed"] boolValue];
        
        self.followerCount = [dictionary objectForKey:@"follower_count"];
        self.followingCount = [dictionary objectForKey:@"num_following"];
        self.reviewCount = [dictionary objectForKey:@"review_count"];
    }
    return self;
}


@end
