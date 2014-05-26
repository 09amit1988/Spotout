//
//  AddLocationPlaceRating.m
//  Lifester
//
//  Created by Nikunj on 6/25/13.
//  Copyright (c) 2013 Nikunj. All rights reserved.
//

#import "AddLocationPlaceRating.h"
#import "ASIFormDataRequest.h"

@implementation AddLocationPlaceRating

@synthesize _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)callAddLocationPlaceRatingWebService:(NSMutableDictionary*)dictParam
{
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"add_place_rating" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
    [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"PassKey"] forKey:@"pass_key"];
    [request setPostValue:[dictParam objectForKey:@"places_review_id"] forKey:@"places_review_id"];
    [request setPostValue:[dictParam objectForKey:@"rating"] forKey:@"rating"];
    [request setPostValue:[dictParam objectForKey:@"tips_comment"] forKey:@"tips_comment"];
    [request setPostValue:[dictParam objectForKey:@"comment_user_id"] forKey:@"comment_user_id"];
    
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([_delegate respondsToSelector:@selector(requestFinishedWithSuccess:)])
        [_delegate requestFinishedWithSuccess:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if([_delegate respondsToSelector:@selector(requestFinishedWithFailed:)])
        [_delegate requestFinishedWithFailed:request];
}

@end
