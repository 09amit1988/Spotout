//
//  AlertHandler.m
//  iTransitBuddy
//
//  Created by Blue Technology Solutions LLC 09/09/2008.
//  Copyright 2010 Blue Technology Solutions LLC. All rights reserved.
//

#import "AlertHandler.h"
#import "TJSpinner.h"

@implementation AlertHandler
UIAlertView *av; 
UIActivityIndicatorView *actInd;


+(void)showAlertForProcess {
	
	if(av!=nil && [av retainCount]>0){
		[av release]; av=nil; 
	} 
	if(actInd!=nil && [actInd retainCount]>0){
		[actInd removeFromSuperview];
		[actInd release]; actInd=nil; 
	}
	av=[[UIAlertView alloc] initWithTitle:@"Loading" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil]; 
	actInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]; 
	[actInd setFrame:CGRectMake(120, 50, 37, 37)]; [actInd startAnimating]; [av addSubview:actInd]; 
	[av show];
}

+(void)showAlertForProcess:(NSString *)string {
    if(av!=nil && [av retainCount]>0){
		[av release]; av=nil;
	}
	if(actInd!=nil && [actInd retainCount]>0){
		[actInd removeFromSuperview];
		[actInd release]; actInd=nil;
	}
	av=[[UIAlertView alloc] initWithTitle:string message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	actInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[actInd setFrame:CGRectMake(120, 50, 37, 37)];
	[actInd startAnimating];
	[av addSubview:actInd];
	[av show];
}

+(void)hideAlert {
	
	[av dismissWithClickedButtonIndex:0 animated:YES]; 
	if(av!=nil && [av retainCount]>0){ [av release]; av=nil; 
	} 
	if(actInd!=nil && [actInd retainCount]>0){ 
		[actInd removeFromSuperview];[actInd release]; actInd=nil; 
	} 
}

@end