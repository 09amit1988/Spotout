//
//  AddLocationPlaceRating.h
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"


@class ASIFormDataRequest;
@class ASIHTTPRequest;

@protocol AddLocationPlaceRatingDelegate <NSObject>


@optional
-(void)requestFinishedWithSuccess:(ASIHTTPRequest *)request;
-(void)requestFinishedWithFailed:(ASIHTTPRequest *)request;

@end



@interface AddLocationPlaceRating : NSObject

@property (nonatomic, assign) id <AddLocationPlaceRatingDelegate> _delegate;
-(void)callAddLocationPlaceRatingWebService:(NSMutableDictionary*)dictParam;

@end
