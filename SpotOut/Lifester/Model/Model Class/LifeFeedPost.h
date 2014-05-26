//
//  LifeFeedPost.h
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifeFeedPost : NSObject

{
    NSInteger userID;
    NSString *username;
    NSString *profileName;
    NSString *profileImagePath;
    float profileRating;
    BOOL hasProfilePicture;
    NSInteger feedType;
    
    NSString *eventName;
    NSString *pictureTitle;
    NSString *eventStartTime;
    NSString *eventEndTime;
    NSMutableArray *arrTickets;
    NSString *price;
    
    BOOL isAlreadyRated;
    BOOL isSelectedBookmark;
    BOOL isReadMoreExplanded;
    BOOL isReadMoreTicketExpanded;
    BOOL isSharePicture;
    
    NSNumber *placeReviewID;
    NSString *locationName;
    NSString *address;
    NSString *city;
    NSString *state;
    NSString *country;
    NSString *categoryType;
    double latitude;
    double longitude;
    NSString *foursquareVenueID;
    NSString *description;
    NSString *link;
    float rating;
    float averageRating;
    NSString *highlight;
    NSString *postTime;
    NSString *timeDifference;
    
    NSMutableArray *arrPictures;
    NSMutableArray *arrTags;
    
    BOOL isLike;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *profileName;
@property (nonatomic, retain) NSString *profileImagePath;
@property (nonatomic, assign) NSInteger feedType;
@property (nonatomic, assign) float profileRating;

@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *pictureTitle;
@property (nonatomic, retain) NSString *eventStartTime;
@property (nonatomic, retain) NSString *eventEndTime;
@property (nonatomic, retain) NSMutableArray *arrTickets;
@property (nonatomic, retain) NSString *price;

@property (nonatomic, assign) BOOL hasProfilePicture;
@property (nonatomic, assign) BOOL isAlreadyRated;
@property (nonatomic, assign) BOOL isSelectedBookmark;
@property (nonatomic, assign) BOOL isReadMoreExplanded;
@property (nonatomic, assign) BOOL isReadMoreTicketExpanded;
@property (nonatomic, assign) BOOL isSharePicture;

@property (nonatomic, assign) BOOL isLike;

@property (nonatomic, retain) NSNumber *placeReviewID;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *categoryType;
@property (nonatomic, retain) NSString *foursquareVenueID;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *highlight;
@property (nonatomic, assign) float rating;
@property (nonatomic, assign) float averageRating;
@property (nonatomic, retain) NSString *postTime;
@property (nonatomic, retain) NSString *timeDifference;
@property (nonatomic, retain) NSMutableArray *arrPictures;
@property (nonatomic, retain) NSMutableArray *arrTags;

-(LifeFeedPost *)initWithDictionary:(NSDictionary *)dictionary;

@end
