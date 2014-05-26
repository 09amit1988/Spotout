//
//  FSConverter.h
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import <Foundation/Foundation.h>
#import "FSVenue.h"

@interface FSConverter : NSObject

- (NSArray *)convertToObjects:(NSArray *)venues;
- (FSVenue *)convertObjectToVenue:(NSDictionary*)dictData currentLocation:(CLLocation*)currentLocation;
- (FSVenue *)convertGoogleSearchObjectToVenue:(NSDictionary*)dictData;

@end
