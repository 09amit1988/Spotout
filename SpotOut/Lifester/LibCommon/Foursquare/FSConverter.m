//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"

@implementation FSConverter

- (NSArray *)convertToObjects:(NSArray *)venues {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];
        
        NSString *address = @"";
        if (v[@"location"][@"crossStreet"]) {
            address = [address stringByAppendingFormat:@"%@, ", v[@"location"][@"crossStreet"]];
        }
        if (v[@"location"][@"address"]) {
            address = [address stringByAppendingFormat:@"%@", v[@"location"][@"address"]];
        }
        
        if (v[@"location"][@"city"]) {
            //address = [address stringByAppendingFormat:@"%@", v[@"location"][@"city"]];
            ann.location.city = v[@"location"][@"city"];
        }
        if (v[@"location"][@"state"]) {
            ann.location.state = v[@"location"][@"state"];
        }
        if (v[@"location"][@"country"]) {
            ann.location.country = v[@"location"][@"country"];
        }
        
        ann.location.address = address;
        ann.location.distance = v[@"location"][@"distance"];
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                      [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:ann];
    }
    return objects;
}

- (FSVenue *)convertObjectToVenue:(NSDictionary*)dictData currentLocation:(CLLocation*)currentLocation
{
    FSVenue *ann = [[FSVenue alloc]init];
    ann.name = dictData[@"name"];
    ann.venueId = dictData[@"id"];
    
    NSString *address = @"";
    if (dictData[@"location"][@"crossStreet"]) {
        address = [address stringByAppendingFormat:@"%@, ", dictData[@"location"][@"crossStreet"]];
    }
    if (dictData[@"location"][@"address"]) {
        address = [address stringByAppendingFormat:@"%@", dictData[@"location"][@"address"]];
    }
    
    if (dictData[@"location"][@"city"]) {
        ann.location.city = dictData[@"location"][@"city"];
    }
    if (dictData[@"location"][@"state"]) {
        ann.location.state = dictData[@"location"][@"state"];
    }
    if (dictData[@"location"][@"country"]) {
        ann.location.country = dictData[@"location"][@"country"];
    }
    
    ann.location.address = address;
//    ann.location.distance = dictData[@"location"][@"distance"];
    
    NSArray *arrCategories = dictData[@"categories"];
    if ([arrCategories count] > 0) {
        NSDictionary *dictCategory = [arrCategories objectAtIndex:0];
        ann.categoryType = [dictCategory objectForKey:@"shortName"];
    }
    
    [ann.location setCoordinate:CLLocationCoordinate2DMake([dictData[@"location"][@"lat"] doubleValue],
                                                           [dictData[@"location"][@"lng"] doubleValue])];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[dictData[@"location"][@"lat"] doubleValue] longitude:[dictData[@"location"][@"lng"] doubleValue]];
    ann.location.distance = [NSNumber numberWithFloat:[currentLocation distanceFromLocation:loc]];
    //NSLog(@"Distance === %@", ann.location.distance);
    
    if (dictData[@"rating"]) {
        float rating = [dictData[@"rating"] floatValue];
        ann.rating = [NSString stringWithFormat:@"%.2f", rating/2];
    } else {
        ann.rating = @"0";
    }
    
    NSArray *arrPhotoGroup = dictData[@"photos"][@"groups"];
    if ([arrPhotoGroup count] > 0) {
        NSArray *photos = [[arrPhotoGroup objectAtIndex:0] objectForKey:@"items"];
        if ([photos count] > 0) {
            NSDictionary *dictPicture = [photos objectAtIndex:0];
            NSString *image = [dictPicture objectForKey:@"prefix"];
            image = [image stringByAppendingFormat:@"100x100"];
            image = [image stringByAppendingString:[dictPicture objectForKey:@"suffix"]];
            ann.locationImage = image;
        }
        
        if (ann.arrPhotos == nil) {
            ann.arrPhotos = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *dictPhoto in photos) {
            NSString *image = [dictPhoto objectForKey:@"prefix"];
            NSString *width = [dictPhoto objectForKey:@"width"];
            NSString *height = [dictPhoto objectForKey:@"height"];
            
            image = [image stringByAppendingFormat:@"%@x%@", width, height];
            image = [image stringByAppendingString:[dictPhoto objectForKey:@"suffix"]];
            [ann.arrPhotos addObject:image];
        }
        
        //NSLog(@"Photos URL ==== %@", ann.arrPhotos);
    }
    
//    NSArray *arrTimeframe = dictData[@"popular"][@"timeframes"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"includesToday = 1"];
//    NSArray *arrToday = [arrTimeframe filteredArrayUsingPredicate:predicate];
//    
//    if ([arrToday count] > 0) {
//        NSDictionary *dictTimeFrame = [arrToday objectAtIndex:0];
//        NSArray *arrOpen = [dictTimeFrame objectForKey:@"open"];
//        if ([arrOpen count] > 1) {
//            ann.workingTime = [[arrOpen objectAtIndex:0] objectForKey:@"renderedTime"];
//        }
//    }
    
    
    return ann;
}


- (FSVenue *)convertGoogleSearchObjectToVenue:(NSDictionary*)dictData
{
    FSVenue *ann = [[FSVenue alloc]init];
    NSArray *array = [[dictData objectForKey:@"description"] componentsSeparatedByString:@", "];
    if ([array count] > 0) {
        ann.name = [array objectAtIndex:0];
    }
    
    NSString *address = @"";
    for (int i = 1; i < [array count]; i++) {
        if (i == [array count]-1) {
            address = [address stringByAppendingFormat:@"%@", [array objectAtIndex:i]];
            ann.location.country = [array objectAtIndex:i];
        } else {
            address = [address stringByAppendingFormat:@"%@, ", [array objectAtIndex:i]];
            ann.location.state = [array objectAtIndex:i];
        }
    }
    ann.location.address = address;
    ann.location.city = ann.name;
    ann.venueId = [dictData objectForKey:@"id"];
    
    return ann;
}




@end
