//
//  FacebookUser.m
//  Lifester
//

#import "FacebookUser.h"

@implementation FacebookUser

@synthesize ID;
@synthesize firstname;
@synthesize lastname;
@synthesize username;
@synthesize name;
@synthesize gender;
@synthesize link;
@synthesize picture;
@synthesize isSelected;

-(FacebookUser *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.ID = [dictionary objectForKey:@"id"];
        self.firstname = [dictionary objectForKey:@"first_name"];
        self.lastname = [dictionary objectForKey:@"last_name"];
        self.username = [dictionary objectForKey:@"username"];
        self.name = [dictionary objectForKey:@"name"];
        self.gender = [dictionary objectForKey:@"gender"];
        self.link = [dictionary objectForKey:@"link"];
        self.picture = [[[dictionary objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];

        self.isSelected = NO;
    }
    return self;
}

@end
