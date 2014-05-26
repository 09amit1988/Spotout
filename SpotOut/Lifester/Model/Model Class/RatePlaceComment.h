//
//  RatePlaceComment.h
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatePlaceComment : NSObject

{
    NSInteger userID;
    NSString *username;
    NSString *profileName;
    NSString *profileImagePath;
    BOOL hasProfilePicture;
    
    float rating;
    NSString *comment;
    NSNumber *placeReviewID;
    NSInteger commentUserID;
    NSString *timeDifference;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *profileName;
@property (nonatomic, retain) NSString *profileImagePath;
@property (nonatomic, assign) BOOL hasProfilePicture;

@property (nonatomic, retain) NSNumber *placeReviewID;
@property (nonatomic, assign) NSInteger commentUserID;
@property (nonatomic, assign) float rating;
@property (nonatomic, retain) NSString *timeDifference;
@property (nonatomic, retain) NSString *comment;

-(RatePlaceComment *)initWithDictionary:(NSDictionary *)dictionary;

@end
