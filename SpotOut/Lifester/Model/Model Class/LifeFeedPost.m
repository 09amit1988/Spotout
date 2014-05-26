//
//  LifeFeedPost.m
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import "LifeFeedPost.h"
#import "NSString+Extensions.h"

@implementation LifeFeedPost

@synthesize userID;
@synthesize username;
@synthesize profileName;
@synthesize profileImagePath;
@synthesize hasProfilePicture;
@synthesize isSharePicture;
@synthesize isAlreadyRated;
@synthesize profileRating;

@synthesize feedType;
@synthesize eventName;
@synthesize pictureTitle;
@synthesize eventStartTime;
@synthesize eventEndTime;
@synthesize arrTickets;
@synthesize price;

@synthesize placeReviewID;
@synthesize locationName;
@synthesize address;
@synthesize city;
@synthesize state;
@synthesize country;
@synthesize categoryType;
@synthesize foursquareVenueID;
@synthesize latitude;
@synthesize longitude;
@synthesize description;
@synthesize link;
@synthesize highlight;
@synthesize rating;
@synthesize averageRating;
@synthesize arrPictures;
@synthesize arrTags;
@synthesize postTime;
@synthesize timeDifference;
@synthesize isSelectedBookmark;
@synthesize isLike;
@synthesize isReadMoreExplanded;
@synthesize isReadMoreTicketExpanded;

- (LifeFeedPost *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.userID = [dictionary objectForKey:@"user_id"];
        self.placeReviewID = [dictionary objectForKey:@"place_review_id"];
        self.username = [dictionary objectForKey:@"username"];
        self.profileName = [dictionary objectForKey:@"profilename"];
        self.postTime = [dictionary objectForKey:@"post_time"];
        self.timeDifference = [dictionary objectForKey:@"time_difference"];
        
        if ([[dictionary objectForKey:@"avg_rating_profile"] class] == [NSNull class]) {
            self.profileRating = 0;
        } else {
            self.profileRating = [[dictionary objectForKey:@"avg_rating_profile"] floatValue];
        }
        
        if ([[dictionary objectForKey:@"type"] class] == [NSNull class]) {
            self.feedType = 0;
        } else {
            self.feedType = [[dictionary objectForKey:@"type"] integerValue];
        }
        
        self.isSelectedBookmark = NO;
        self.isLike = NO;
        self.isReadMoreExplanded = NO;
        self.isReadMoreTicketExpanded = NO;
        
        /////////////////////////////////// Profile related value /////////////////////////////////
        if (![[dictionary objectForKey:@"profile_picture_id"] checkNullText]) {
            self.profileImagePath = [dictionary objectForKey:@"profile_picture_id"];
        } else {
            self.profileImagePath = @"";
        }
        self.hasProfilePicture = [[dictionary objectForKey:@"has_profiole_picture"] boolValue];
        
        
        /////////////////////////////////// Event Post Value /////////////////////////////////
        if ([[dictionary objectForKey:@"event_name"] class] == [NSNull class]) {
            self.eventName = @"";
        } else {
            self.eventName = [dictionary objectForKey:@"event_name"];
        }
        
        if ([[dictionary objectForKey:@"picture_title"] class] == [NSNull class]) {
            self.pictureTitle = @"";
        } else {
            self.pictureTitle = [dictionary objectForKey:@"picture_title"];
        }
        
        if ([[dictionary objectForKey:@"event_start"] class] == [NSNull class]) {
            self.eventStartTime = @"";
        } else {
            self.eventStartTime = [dictionary objectForKey:@"event_start"];
        }
        
        if ([[dictionary objectForKey:@"event_end"] class] == [NSNull class]) {
            self.eventEndTime = @"";
        } else {
            if ([[dictionary objectForKey:@"event_end"] isEqualToString:@"0000-00-00 00:00:00"]) {
                self.eventEndTime = @"";
            } else {
                self.eventEndTime = [dictionary objectForKey:@"event_end"];
            }
        }
        
        if ([[dictionary objectForKey:@"price"] class] == [NSNull class]) {
            self.price = @"";
        } else {
            self.price = [dictionary objectForKey:@"price"];
        }
        //////////////////////////////////////////////////////////////////////////////
        
        ////////////////////////////////// Place Post Value /////////////////////////////////
        if ([dictionary objectForKey:@"rating_status"]) {
            if ([[dictionary objectForKey:@"rating_status"] isEqualToString:@"Rated Already"]) {
                self.isAlreadyRated = YES;
            } else {
                self.isAlreadyRated = NO;
            }
        } else {
            self.isAlreadyRated = NO;
        }
        
        if (![[dictionary objectForKey:@"Description_places"] checkNullText]) {
            self.description = [dictionary objectForKey:@"Description_places"];
        } else {
            self.description = @"";
        }
        
        if (![[dictionary objectForKey:@"link"] checkNullText]) {
            self.link = [dictionary objectForKey:@"link"];
        } else {
            self.link = @"";
        }
        
        if ([[dictionary objectForKey:@"highlight"] class] == [NSNull class]) {
            self.highlight = @"";
        } else {
            self.highlight = [dictionary objectForKey:@"highlight"];
        }
        
        if ([dictionary objectForKey:@"avg_rating"]) {
            self.averageRating = [[dictionary objectForKey:@"avg_rating"] floatValue];
        } else {
            self.averageRating = 0.0;
        }
        
        if ([[dictionary objectForKey:@"picture"] class] == [NSNull class]) {
        } else {
            id picture = [dictionary objectForKey:@"picture"];
            if ([picture isKindOfClass:[NSMutableArray class]]) {
                self.arrPictures = [dictionary objectForKey:@"picture"];
            }
        }
        //////////////////////////////////////////////////////////////////////////////
        
        //////////////////// Common Value  /////////////////////////////////
        self.isSharePicture = [[dictionary objectForKey:@"share_picture"] boolValue];
        if (self.arrTags == nil) {
            self.arrTags = [[NSMutableArray alloc] init];
        }
        if ([dictionary objectForKey:@"category"]) {
            for (NSDictionary *dict in [dictionary objectForKey:@"category"]) {
                [self.arrTags addObject:dict];
            }
        }
        //////////////////////////////////////////////////////////////////////////////
        
        //////////////////// Location Related Value  /////////////////////////////////
        if ([[dictionary objectForKey:@"location_name"] class] == [NSNull class]) {
            self.locationName = @"";
        } else {
            self.locationName = [dictionary objectForKey:@"location_name"];
        }
        
        if ([[dictionary objectForKey:@"address"] class] == [NSNull class]) {
            self.address = @"";
        } else {
            self.address = [dictionary objectForKey:@"address"];
        }
        
        if ([[dictionary objectForKey:@"city"] class] == [NSNull class]) {
            self.city = @"";
        } else {
            self.city = [dictionary objectForKey:@"city"];
        }
        
        if ([[dictionary objectForKey:@"state"] class] == [NSNull class]) {
            self.state = @"";
        } else {
            self.state = [dictionary objectForKey:@"state"];
        }
        
        if ([[dictionary objectForKey:@"country"] class] == [NSNull class]) {
            self.country = @"";
        } else {
            self.country = [dictionary objectForKey:@"country"];
        }
        
        if ([[dictionary objectForKey:@"lattitude"] class] == [NSNull class]) {
            self.latitude = 0;
        } else {
            self.latitude = [[dictionary objectForKey:@"lattitude"] doubleValue];
        }

        if ([[dictionary objectForKey:@"Longitude"] class] == [NSNull class]) {
            self.longitude = 0;
        } else {
            self.longitude = [[dictionary objectForKey:@"Longitude"] doubleValue];
        }

        if ([[dictionary objectForKey:@"FoursqaureVenueID"] class] == [NSNull class]) {
            self.foursquareVenueID = @"";
        } else {
            self.foursquareVenueID = [dictionary objectForKey:@"FoursqaureVenueID"];
        }
        
        if ([[dictionary objectForKey:@"LocationCategoryType"] class] == [NSNull class]) {
            self.categoryType = @"";
        } else {
            self.categoryType = [dictionary objectForKey:@"LocationCategoryType"];
        }
        
        if ([[dictionary objectForKey:@"rating"] class] == [NSNull class]) {
            self.rating = 0.0;
        } else {
            self.rating = [[dictionary objectForKey:@"rating"] floatValue];
        }
        //////////////////////////////////////////////////////////////////////////////
        
        ////////////////////////////////// Ticket Value /////////////////////////////////
        if (self.arrTickets == nil) {
            self.arrTickets = [[NSMutableArray alloc] init];
        }
        
        
        //NSLog(@"Images ==== %@", self.arrPictures);
        if ([[dictionary objectForKey:@"tickets"] class] != [NSNull class]) {
            if ([[dictionary objectForKey:@"tickets"] count] > 0) {
                NSString *code = [[[[dictionary objectForKey:@"tickets"] objectForKey:@"currency_code"] objectAtIndex:0] textTrimmed];
                NSString *name = [[[[dictionary objectForKey:@"tickets"] objectForKey:@"ticket_name"] objectAtIndex:0] textTrimmed];
                NSString *price1 = [[[[dictionary objectForKey:@"tickets"] objectForKey:@"ticket_price"] objectAtIndex:0] textTrimmed];
                
                code = [code stringByReplacingOccurrencesOfString:@"(" withString:@""];
                code = [code stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                name = [name stringByReplacingOccurrencesOfString:@"(" withString:@""];
                name = [name stringByReplacingOccurrencesOfString:@")" withString:@""];
                name = [name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                price1 = [price1 stringByReplacingOccurrencesOfString:@"(" withString:@""];
                price1 = [price1 stringByReplacingOccurrencesOfString:@")" withString:@""];
                price1 = [price1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                NSArray *code1 = [code componentsSeparatedByString:@","];
                NSArray *name1 = [name componentsSeparatedByString:@","];
                NSArray *price2 = [price1 componentsSeparatedByString:@","];
                
                for (int i = 0; i < [name1 count]; i++) {
                    NSString *strCode = [[code1 objectAtIndex:i] textTrimmed];
                    NSString *strName = [[name1 objectAtIndex:i] textTrimmed];
                    NSString *strPrice = [[price2 objectAtIndex:i] textTrimmed];
                    
                    NSDictionary *dictTicket = [NSDictionary dictionaryWithObjectsAndKeys:
                                                strName, @"ticketName",
                                                strPrice, @"price",
                                                strCode, @"currency", nil];
                    [self.arrTickets addObject:dictTicket];
                }
            }
        }
        //////////////////////////////////////////////////////////////////////////////
    }
    return self;
}

@end
