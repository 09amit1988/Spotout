//
//  RootViewDelegate.h
//  Lifester
//

#import "RootView.h"

/*
 * Delegate for handling events in subclasses.
 */
@protocol RootViewDelegate <NSObject>

@optional

/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)AlertDialogDidComplete:(UIView *)view;


/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)AlertDialogDidNotComplete:(UIView *)view;

/**
 * Called when dialog failed to load due to an error.
 */
- (void)AlertDialog:(RootView *)view didFailWithError:(NSError *)error;

@end
