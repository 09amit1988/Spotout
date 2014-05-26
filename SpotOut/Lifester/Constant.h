//
//  Constant.h
//  Lifester
//
//  Created by Nikunj on 10/14/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//


#define IS_WIDESCREEN ( ( double )[ [ UIScreen mainScreen ] bounds ].size.height == ( double )568 )
#define IS_IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_5 ( IS_WIDESCREEN )

#define iOS_VERSION [[UIDevice currentDevice] systemVersion]
#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define MB_AUTORELEASE(exp) [exp autorelease]
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
 

#define kSCNavBarImageTag       6183746
#define appname                 @"SpotOut"
#define push_mode               @"P"
#define TRANSITIONDURATION      0.3

#define GOOGLEAPI               @"AIzaSyCVlvrtioWrGTYmdtIRxFtP7cAHcFLBH_w"  // CLIENT KEY

//#define SERVER_URL @"http://lifester-app.com/apps/"
#define SERVER_URL              @"http://sparsh-technologies.co.in/megha/lifester/"
#define DEFAULTPROFILEIMAGE     @"http://sparsh-technologies.co.in/megha/lifester/photos/users/male.png"

#define HELVETICANEUELIGHT                @"HelveticaNeue-Light"
#define HELVETICANEUEREGULAR              @"HelveticaNeue"
#define HELVETICANEUEMEDIUM               @"HelveticaNeue-Medium"
#define HELVETICANEUEBOLD                 @"HelveticaNeue-Bold"

// http://lifester.india-web-design.com/raws/ws_extras.php
//  @"http://lifester-app.com/apps/"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define BACKGROUND_COLOR        [UIColor colorWithRed:32.0/255.0f green:81.0/255.0f blue:112.0/255.0f alpha:1.0]
#define WHITE_BACKGROUND_COLOR    [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
//#define NAVI_BARTINTCOLOR       [UIColor colorWithRed:(25/255.0) green:(75/255.0) blue:(111/255.0) alpha:1.0]
//#define NAVI_BARTINTCOLOR       [UIColor colorWithRed:(71/255.0) green:(119/255.0) blue:(149/255.0) alpha:1.0]
#define NAVI_BARTINTCOLOR       [UIColor colorWithRed:(107/255.0) green:(145/255.0) blue:(170/255.0) alpha:1.0]
#define VIEW_COLOR              [UIColor colorWithRed:240/255.0f green:239/255.0f blue:244/255.0f alpha:1]

#define SELECTED_COLOR       [UIColor colorWithRed:(65.0/255.0) green:(64.0/255.0) blue:(66.0/255.0) alpha:1.0]
#define NORMAL_COLOR         [UIColor colorWithRed:(193.0/255.0) green:(193.0/255.0) blue:(193.0/255.0) alpha:1.0]


enum FeedType {
	PLACE_TYPE = 1,
	EVENT_TYPE,
    OFFER_TYPE,
    TEXT_TYPE,
    PICTURE_TYPE,
    ACTIVITY_TYPE
};