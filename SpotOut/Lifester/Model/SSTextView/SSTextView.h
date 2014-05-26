//
//  SSTextView.h
//  SSToolkit
//


/**
 UITextView subclass that adds placeholder support like UITextField has.
 */
@interface SSTextView : UITextView

/**
 The string that is displayed when there is no other text in the text view.
 
 The default value is `nil`.
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 The color of the placeholder.
 
 The default is `[UIColor lightGrayColor]`.
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

@end
