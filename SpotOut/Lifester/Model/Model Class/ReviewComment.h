//
//  ReviewComment.h
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewComment : NSObject

{
    NSNumber *userID;
    NSString *username;
    NSString *profileName;
    NSString *profileImage;
    float profileRating;
    
    BOOL hasProfilePicture;
    BOOL isReadMoreExplanded;
    
    float rating;
    NSString *comment;
    NSNumber *profileReviewID;
    NSInteger commentUserID;
    NSString *timeDifference;
}

@property (nonatomic, assign) NSNumber *userID;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *profileName;
@property (nonatomic, retain) NSString *profileImage;
@property (nonatomic, assign) float profileRating;

@property (nonatomic, assign) BOOL hasProfilePicture;
@property (nonatomic, assign) BOOL isReadMoreExplanded;

@property (nonatomic, retain) NSNumber *profileReviewID;
@property (nonatomic, assign) float rating;
@property (nonatomic, retain) NSString *timeDifference;
@property (nonatomic, retain) NSString *comment;

-(ReviewComment *)initWithDictionary:(NSDictionary *)dictionary;

@end
