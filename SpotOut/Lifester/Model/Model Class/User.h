//
//  User.h
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSNumber *userID;
    NSString *username;
    NSString *profileName;
    NSString *firstName;
    NSString *lastName;
    NSString *passKey;
    float profileRating;
    
    NSString *profileImage;
    BOOL hasProfilePicture;
    
    NSNumber *followerCount;
    NSNumber *followingCount;
    NSNumber *reviewCount;
    
    BOOL followed;
    
}

@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *profileName;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *passKey;
@property (nonatomic, assign) float profileRating;

@property (nonatomic, retain) NSString *profileImage;
@property (nonatomic, assign) BOOL hasProfilePicture;

@property (nonatomic, retain) NSNumber *followerCount;
@property (nonatomic, retain) NSNumber *followingCount;
@property (nonatomic, retain) NSNumber *reviewCount;

@property (nonatomic, assign) BOOL followed;


- (User *)initWithDictionaryForLogin:(NSDictionary *)dictionary;
- (User *)initWithDictionaryForProfileDetail:(NSDictionary *)dictionary;

@end
