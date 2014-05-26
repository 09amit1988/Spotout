//
//  AlertHandler.h
//  iTransitBuddy
//
//  Created by Blue Technology Solutions LLC 09/09/2008.
//  Copyright 2010 Blue Technology Solutions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJSpinner.h"

@interface AlertHandler : NSObject {
    
	//TJSpinner *spinner;
}

+(void)showAlertForProcess;
+(void)showAlertForProcess:(NSString *)string;
+(void)hideAlert; 

@end
