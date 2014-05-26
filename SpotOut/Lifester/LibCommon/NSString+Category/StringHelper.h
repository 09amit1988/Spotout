//
//  StringHelper.h
//  Coffee Learning
//

#import <UIKit/UIKit.h>

@interface NSString (StringHelper)

- (CGFloat)RAD_textHeightForSystemFontOfSize:(CGFloat)size;
- (CGFloat)RAD_textWidthForSystemFontOfSize:(CGFloat)size;

- (CGFloat)RAD_textWidthForFontName:(NSString*)fontName FontOfSize:(CGFloat)size MaxHeight:(CGFloat)maxHeight;
- (CGFloat)RAD_textHeightForFontName:(NSString*)fontName FontOfSize:(CGFloat)size MaxWidth:(CGFloat)maxWidth;
- (CGFloat)RAD_textHeightForReviewSystomFontOfSize:(CGFloat)size;
- (CGFloat)RAD_textWidthForBoldSystemFontOfSize:(CGFloat)size;

- (CGRect)RAD_frameForCellLabelWithSystemFontOfSize:(CGFloat)size;
- (UILabel *)RAD_newSizedCellLabelWithSystemFontOfSize:(CGFloat)size;
- (void)RAD_resizeLabel:(UILabel *)aLabel WithSystemFontOfSize:(CGFloat)size;

@end

