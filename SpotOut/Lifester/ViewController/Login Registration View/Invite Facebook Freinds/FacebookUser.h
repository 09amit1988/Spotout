//
//  FacebookUser.h
//  Lifester
//

#import <Foundation/Foundation.h>

@interface FacebookUser : NSObject
{
    NSNumber *ID;
    NSString *firstname;
    NSString *lastname;
    NSString *username;
    NSString *name;
    NSString *gender;
    NSString *link;
    NSString *picture;
}
@property (nonatomic, retain) NSNumber *ID;
@property (nonatomic, retain) NSString *firstname;
@property (nonatomic, retain) NSString *lastname;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, assign) BOOL isSelected;

-(FacebookUser *)initWithDictionary:(NSDictionary *)dictionary;

@end
