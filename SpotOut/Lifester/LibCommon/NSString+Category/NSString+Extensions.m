//
//  NSString+Extensions.m
//  Media App
//

#import "NSString+Extensions.h"


@implementation NSString (Extensions)

#pragma mark - Cache Directory Path Methods

- (NSString *)cacheDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];

	return cacheDirectory;
}

- (NSString *)pathInCacheDirectory {
	NSString *documentsDirectory = [self cacheDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInCacheDirectory:(NSString *)directory {
	NSString *cacheDirectory = [self cacheDirectoryPath];
	NSString *dirPath = [cacheDirectory stringByAppendingString:directory];
	NSString *path = [dirPath stringByAppendingString:self];
	
	NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	return path;
}

#pragma mark - Doc Directory Path Methods

- (NSString *)documentsDirectoryPath {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return documentsDirectory;
}

- (NSString *)pathInDocumentDirectory {
    NSString *documentsDirectory = [self documentsDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInDocumentDirectory:(NSString *)directory {
    NSString *documentsDirectory = [self documentsDirectoryPath];
	NSString *dirPath = [documentsDirectory stringByAppendingPathComponent:directory];
	NSString *path = [dirPath stringByAppendingPathComponent:self];
    
	return path;
}

#pragma mark - String Editing Methods

- (BOOL)checkNullText
{
    if (self == (id)[NSNull null] || self.length == 0 ) {
        return YES;
    }
    return NO;
}

- (NSString *)textTrimmed {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removeWhiteSpace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*)stringByNormalizingCharacterInSet:(NSCharacterSet*)characterSet withString:(NSString*)replacement {
	NSMutableString* result = [NSMutableString string];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	while (![scanner isAtEnd]) {
		if ([scanner scanCharactersFromSet:characterSet intoString:NULL]) {
			[result appendString:replacement];
		}
		NSString* stringPart = nil;
		if ([scanner scanUpToCharactersFromSet:characterSet intoString:&stringPart]) {
			[result appendString:stringPart];
		}
	}
			
	return [result copy];
}

- (NSString *)bindSQLCharacters {
	NSString *bindString = self;
	bindString = [bindString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	
	return bindString;
}

- (NSString *)trimSpaces {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]];
}

#pragma mark - String Validation Methods

+ (BOOL) validateEmail: (NSString *) candidate {
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:candidate];
    
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

// Range must be in {a,b}. Where a is mimimum length and b is max length
+ (BOOL)validateForNumericAndCharacets:(NSString*)candidate WithLengthRange:(NSString*)strRange{
	BOOL valid = NO;
	
    NSCharacterSet *alphaNums = [NSCharacterSet alphanumericCharacterSet];
	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:candidate];
	BOOL isAlphaNumeric = [alphaNums isSupersetOfSet:inStringSet];
	
    if(isAlphaNumeric){
		NSString *emailRegex = [NSString stringWithFormat:@"[%@]%@",candidate, strRange]; 
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		valid =[emailTest evaluateWithObject:candidate];
	}
	
    return valid;
}

+ (BOOL)isNumericValue:(NSString *)string {
    BOOL valid = NO;
    
    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet *alphaNums = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:trimmed];
    
    if ([trimmed length] > 0 ) {
        valid = [alphaNums isSupersetOfSet:inStringSet];
    }
    
    return valid;
}

+ (BOOL) validateUrl: (NSString *) url {
//    NSString *theURL = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSString *theURL = @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", theURL]; 
    
    return [urlTest evaluateWithObject:url];
}

+ (BOOL)textIsValidPasswordFormat:(NSString *)text {
    
    //NSString *stricterFilterString = @"(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{8,10})$";
   // NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    if (text.length < 6) {
        return NO;
    }
    else {
        //return [passwordTest evaluateWithObject:text];
        return YES;
    }
}

#pragma mark - Date Format Conversion Method

- (NSString *)formattedDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self];
    
    [dateFormatter setDateFormat:@"dd MMM, yyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    return formattedDate;
}

- (NSString *)urlEncode
{
    return (NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                (CFStringRef) self,
                                                                NULL,
                                                                (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                kCFStringEncodingUTF8);
}

@end