//
//  NSString+Extensions.h
//  Media App
//

#import <Foundation/Foundation.h>


@interface NSString (Extensions)

// Doc Directory Path Methods
- (NSString *)cacheDirectoryPath;
- (NSString *)pathInCacheDirectory;
- (NSString *)pathInCacheDirectory:(NSString *)directory;

// Doc Directory Path Methods
- (NSString *)documentsDirectoryPath;
- (NSString *)pathInDocumentDirectory;
- (NSString *)pathInDocumentDirectory:(NSString *)directory;

- (BOOL)checkNullText;

// String Editing Methods
- (NSString *)removeWhiteSpace;
- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet*)characterSet withString:(NSString*)replacement;
- (NSString *)bindSQLCharacters;
- (NSString *)trimSpaces;
- (NSString *)textTrimmed;

// String Validation Methods
+ (BOOL)validateEmail: (NSString *) candidate;
+ (BOOL)validateForNumericAndCharacets:(NSString*)candidate WithLengthRange:(NSString*)strRange;
+ (BOOL)isNumericValue:(NSString *)string;
+ (BOOL)validateUrl:(NSString *)url;
+ (BOOL)textIsValidPasswordFormat:(NSString *)text;
// Date Format Conversion Method
- (NSString *)formattedDate;

- (NSString *)urlEncode;

@end
