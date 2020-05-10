//
//  NSString+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/8.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSString+QBExtension.h"
#import "NSObject+QBExtension.h"
#import "NSNumber+QBExtension.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreText/CoreText.h>

@implementation NSString (QBExtension)

#pragma mark - NSString -> Number

- (double)qbDoubleValue {
    if (self && [self respondsToSelector:@selector(doubleValue)]) {
        return [self doubleValue];
    }
    return 0.0f;
}

- (float)qbFloatValue {
    if (self && [self respondsToSelector:@selector(floatValue)]) {
        return [self floatValue];
    }
    return 0.0f;
}

- (int)qbIntValue {
    if (self && [self respondsToSelector:@selector(intValue)]) {
        return [self intValue];
    }
    return 0;
}

- (NSInteger)qbIntegerValue NS_AVAILABLE(10_5, 2_0) {
    if (self && [self respondsToSelector:@selector(integerValue)]) {
        return [self integerValue];
    }
    return 0;
}

- (unsigned)_customDigitValue:(unichar)c {
    if ((c > 47) && (c < 58)){
        return (c - 48);
    }
    
    return 10;
}

- (unsigned long long)qbUnsignedLongLongValue {
    unsigned n = (unsigned)[self length];
    unsigned long long v,a;
    unsigned small_a, j;
    
    v = 0;
    for (j = 0; j < n; j++) {
        unichar c = [self characterAtIndex:j];
        small_a = [self _customDigitValue:c];
        if (small_a == 10)
            continue;
        a = (unsigned long long)small_a;
        v = (10 * v) + a;
    }
    
    return v;
}

- (long long)qbLongLongValue NS_AVAILABLE(10_5, 2_0) {
    if (self && [self respondsToSelector:@selector(longLongValue)]) {
        return [self longLongValue];
    } else {
        NSScanner *scanner = [NSScanner scannerWithString:self];
        long long valueToGet;
        if ([scanner scanLongLong:&valueToGet] == YES) {
            return valueToGet;
        }
    }
    return 0L;
}

- (long)qbLongValue {
    return (long)[self qbLongLongValue];
}

- (BOOL)qbBoolValue NS_AVAILABLE(10_5, 2_0) {
    if (self && [self respondsToSelector:@selector(boolValue)]) {
        return [self boolValue];
    }
    return false;
}

- (unichar)qbCharacterAtIndex:(NSUInteger)index {
    if (self && [self respondsToSelector:@selector(characterAtIndex:)]) {
        if (self.length > index) {
            return [self characterAtIndex:index];
        }
    }
    return 0;
}

- (BOOL)qbIsInteger {
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)qbIsFloat {
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (NSString *)qbReverseString {
    NSMutableString *reverseString = [[NSMutableString alloc] initWithCapacity:self.length];
    NSInteger charIndex = [self length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[self substringWithRange:subStrRange]];
    }
    return reverseString;
}

- (NSString *)qbUppercaseFirstString {
    if (self.length < 1) {
        return self;
    }
    return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)qbLowercaseFirstString {
    if (self.length < 1) {
        return self;
    }
    return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)qbFirstCharacter {
    if (self && self.length) {
        return [self substringToIndex:1];
    } else {
        return self;
    }
}

- (NSString *)qbLastCharacter {
    if (self && self.length) {
        return [self substringWithRange:NSMakeRange(self.length - 1, 1)];
    } else {
        return self;
    }
}

#pragma mark - Char
+ (NSString *)qbSearchInString:(NSString *)string charStart:(char)charStart charEnd:(char)charEnd {
    int start = 0, end = 0;
    
    for (int i = 0; i < [string length]; i++) {
        if ([string characterAtIndex:i] == charStart && start == 0) {
            start = i+1;
            i += 1;
            continue;
        }
        if ([string characterAtIndex:i] == charEnd) {
            end = i;
            break;
        }
    }
    
    end -= start;
    
    if (end < 0) {
        end = 0;
    }
    
    return [[string substringFromIndex:start] substringToIndex:end];
}

- (NSString *)qbSearchCharStart:(char)charStart charEnd:(char)charEnd {
    return [NSString qbSearchInString:self charStart:charStart charEnd:charEnd];
}

- (NSInteger)qbIndexOfCharacter:(char)character {
    for (NSUInteger i = 0; i < [self length]; i++) {
        if ([self characterAtIndex:i] == character) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSString *)qbSubstringFromCharacter:(char)character {
    NSInteger index = [self qbIndexOfCharacter:character];
    if (index != NSNotFound) {
        return [self substringFromIndex:index];
    } else {
        return @"";
    }
}

- (NSString *)qbSubstringToCharacter:(char)character {
    NSInteger index = [self qbIndexOfCharacter:character];
    if (index != NSNotFound) {
        return [self substringToIndex:index];
    } else {
        return @"";
    }
}

#pragma mark - Substring

- (NSString *)qbSubstringFromIndex:(NSUInteger)from length:(NSUInteger)length {
    return [self substringWithRange:NSMakeRange(from, length)];
}

- (NSString *)qbSubstringFromIndex:(NSUInteger)from toIndex:(NSUInteger)toIndex {
    return [self substringWithRange:NSMakeRange(from, toIndex - from)];
}

#pragma mark - Random
+ (nullable NSString *)qbGenerateRandomString {
    return [self qbGenerateRandomStringWithLength:10];
}

+ (nullable NSString *)qbGenerateRandomStringWithLength:(NSInteger)number {
    NSInteger NUMBER_OF_CHARS = number;
    char data[NUMBER_OF_CHARS];
    for (int x = 0; x < NUMBER_OF_CHARS; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

#pragma mark - Init
+ (NSString *)qbStringWithPointer:(void *)pointer {
    return [NSString stringWithFormat:@"%p",pointer];
}

+ (NSString *)qbStringWithCGFloat:(CGFloat)cgFloat {
    return [[NSNumber qbNumberWithCGFloat:cgFloat] stringValue];
    return nil;
}

+ (NSString *)qbStringWithUnsignedInteger:(NSUInteger)unsignedInteger {
    return [@(unsignedInteger) stringValue];
}

+ (NSString *)qbStringWithInteger:(NSInteger)integer {
    return [@(integer) stringValue];
}

+ (NSString *)qbStringWithObject:(id)object {
    return [object description];
}

+ (NSString *)qbStringWithLongLong:(long long)longLong {
    return [@(longLong) stringValue];
}

+ (NSString *)qbStringWithUnsignedLongLong:(unsigned long long)unsignedLongLong {
    return [@(unsignedLongLong) stringValue];
}

+ (NSString *)qbStringWithLong:(long)longv {
    return [@(longv) stringValue];
}

+ (NSString *)qbStringWithUnsignedLong:(unsigned long)unsignedLong {
    return [@(unsignedLong) stringValue];
}

+ (NSString *)qbStringWithInt:(int)intv {
    return [@(intv) stringValue];
}

+ (NSString *)qbStringWithUnsignedInt:(unsigned int)unsignedInt {
    return [@(unsignedInt) stringValue];
}

+ (NSString *)qbStringWithShort:(short)shortv {
    return [@(shortv) stringValue];
}

+ (NSString *)qbStringWithUnsignedShort:(unsigned short)unsignedShort {
    return [@(unsignedShort) stringValue];
}

+ (NSString *)qbStringWithChar:(char)charv {
    return [@(charv) stringValue];
}

+ (NSString *)qbStringWithUnsignedChar:(unsigned char)unsignedChar {
    return [@(unsignedChar) stringValue];
}

+ (NSString *)qbStringWithBOOL:(BOOL)aBOOL {
    return [@(aBOOL) stringValue];
}

+ (NSString *)qbStringWithFloat:(float)aFloat {
    return [@(aFloat) stringValue];
}

+ (NSString *)qbStringWithDouble:(double)aDouble {
    return [@(aDouble) stringValue];
}

+ (NSString *)qbStringWithInt16:(int16_t)int16 {
    return [@(int16) stringValue];
}

+ (NSString *)qbStringWithInt32:(int32_t)int32 {
    return [@(int32) stringValue];
}

+ (NSString *)qbStringWithInt64:(int64_t)int64 {
    return [@(int64) stringValue];
}

#pragma mark - URL
- (NSString *)qbURLEncode {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

- (NSString *)qbURLDecode {
    return [self stringByRemovingPercentEncoding];
}

+ (NSDictionary *)qbURLParameters:(NSString *)string
{
    NSRange range = [string rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return @{};
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSString *parametersString = [string substringFromIndex:range.location + 1];
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValue in urlComponents) {
            NSArray *pairComponents = [keyValue componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            if (!key || !value) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                [params setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return @{};
        }
        
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        if (!key || !value) {
            return @{};
        }
        
        [params setValue:value forKey:key];
    }
    return params;
}

#pragma mark - UUID
+ (NSString *)qbRandomUUID {
    return  [[NSUUID UUID] UUIDString];
}

#pragma mark - Replace
- (NSString *)qbStringByReplacingWithRegex:(NSString *)regexString withString:(NSString *)replacement {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}

#pragma mark - Append
+ (NSString *)qbAppedString:(NSString * _Nonnull)aString, ... NS_REQUIRES_NIL_TERMINATION {
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:5];
    va_list args;
    
    // Traverse the strings
    va_start(args, aString);
    for (NSString *arg = aString; arg != nil; arg = va_arg(args, NSString*)) {
        [newString appendString:arg];
    }
    va_end(args);
    
    return [newString copy];
}

#pragma mark - Trims
- (NSString *)qbStringByStrippingHTML {
    return [self stringByReplacingOccurrencesOfString:@"<[^>]+>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

- (NSString *)qbStringByRemovingScriptsAndStrippingHTML {
    NSMutableString *mString = [self mutableCopy];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<script[^>]*>[\\w\\W]*</script>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:mString options:NSMatchingReportProgress range:NSMakeRange(0, [mString length])];
    for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
        [mString replaceCharactersInRange:match.range withString:@""];
    }
    return [mString qbStringByStrippingHTML];
}

- (NSString *)qbTrimmingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)qbTrimmingWhitespaceAndNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)qbTrimmingNewlines {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (NSString *)qbStringByRemovingPrefix:(NSString *)prefix {
    if ([self hasPrefix:prefix]) {
        return [self substringFromIndex:[prefix length]];
    }
    return self;
}

- (NSString *)qbStringByRemovingSuffix:(NSString *)suffix {
    if ([self hasSuffix:suffix]) {
        return [self substringToIndex:[self length] - [suffix length]];
    }
    return self;
}

#pragma mark - Pinyin
- (NSString *)qbPinyinUppercase:(BOOL)uppercase {
    NSMutableString *pinyin = [NSMutableString stringWithString:[self qbPinyinWithPhoneticSymbolUppercase:NO]];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    return uppercase?[pinyin uppercaseString]:pinyin;
}

- (NSString *)qbPinyinCapitalized {
    return [[self qbPinyinUppercase:NO] capitalizedString];
}

- (NSString *)qbPinyinWithPhoneticSymbolUppercase:(BOOL)uppercase {
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    return uppercase ? [pinyin uppercaseString] : pinyin;
}

- (NSString *)qbPinyinPhoneticSymbolCapitalized {
    return [[self qbPinyinWithPhoneticSymbolUppercase:NO] capitalizedString];
}

- (NSString *)qbPinyinWithoutBlankUppercase:(BOOL)uppercase {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    for (NSString *str in [self qbPinyinArrayUppercase:NO]) {
        [string appendString:str];
    }
    return uppercase?[string uppercaseString]:string;
}

- (NSString *)qbPinyinWithoutBlankCapitalized {
    NSMutableString *string = [NSMutableString stringWithString:@""];
    for (NSString *subString in [self qbPinyinArrayUppercase:NO]) {
        [string appendString:[subString capitalizedString]];
    }
    return string;
}

- (NSArray *)qbPinyinArrayUppercase:(BOOL)uppercase {
    NSArray *array = [[self qbPinyinUppercase:uppercase] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return array;
}

- (NSArray *)qbPinyinArrayCapitalized {
    NSArray *array = [[self qbPinyinCapitalized] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return array;
}

- (NSString *)qbPinyinInitialsStringUppercase:(BOOL)uppercase {
    NSMutableString *pinyin = [NSMutableString stringWithString:@""];
    for (NSString *str in [self qbPinyinArrayUppercase:NO]) {
        if ([str length] > 0) {
            NSString *subString = [str substringToIndex:1];
            [pinyin appendString: (uppercase ? [subString uppercaseString] : subString)];
        }
    }
    return pinyin;
}

- (NSArray *)qbPinyinInitialsArrayUppercase:(BOOL)uppercase {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in [self qbPinyinArrayUppercase:NO]) {
        if ([str length] > 0) {
            NSString *subString = [str substringToIndex:1];
            [array addObject: (uppercase ? [subString uppercaseString] : subString)];
        }
    }
    return array;
}

#pragma mark - Contains
+ (BOOL)qbIsEmpty:(NSString * _Nullable)string {
    NSString *newString = [NSObject qbObjectToString:string];
    if (!newString) {
        return YES;
    }
    if ([newString isEqual:[NSNull null]] || [newString isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (BOOL)qbIsContainChinese {
    if ([NSString qbIsEmpty:self]) {
        return NO;
    }
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)qbIsContainBlank {
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)qbContainsCharacterSet:(NSCharacterSet *)set {
    NSRange rang = [self rangeOfCharacterFromSet:set];
    if (rang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (BOOL)qbContainsString:(NSString *)string {
    NSRange rang = [self rangeOfString:string];
    if (rang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (int)qbContainsWordsCount {
    NSInteger n = self.length;
    int i;
    int l = 0, a = 0, b = 0;
    unichar c;
    for (i = 0; i < n; i++) {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    return l + (int)ceilf((float)(a + b) / 2.0);
}

- (nullable NSString *)qbContainsFirstWord {
    __block NSString *firstWord;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        firstWord = substring;
        *stop = YES;
    }];
    
    return firstWord;
}

- (NSArray *)qbContainsAllWords {
    NSMutableArray *words = [NSMutableArray array];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [words addObject:substring];
    }];
    return words;
}

- (NSSet *)qbContainsUniqueWords {
    return [NSSet setWithArray:[self qbContainsAllWords]];
}

- (NSInteger)qbContainsNumberOfWords {
    __block int count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        count++;
    }];
    return count;
}

#pragma mark - Convert
- (NSString *)qbConvertUnicodeToString {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    //NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (NSMutableAttributedString *)qbConvertHTMLToAttributedString:(NSString *)htmlString {
    NSString *content = @"";
    if (![NSString qbIsEmpty:htmlString]) {
        content = htmlString;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attributedString;
}

#pragma mark - MIME
- (NSString *)qbMIMEType {
    return [[self class] qbMIMETypeForExtension:[self pathExtension]];
}

+ (NSString *)qbMIMETypeForExtension:(NSString *)extension {
    return [[self qbMIMEDictionary] valueForKey:[extension lowercaseString]];
}

+ (NSDictionary *)qbMIMEDictionary {
    NSDictionary * MIMEDict;
    // Lazy loads the MIME type dictionary.
    if (!MIMEDict) {
        
        // ???: Should I have these return an array of MIME types? The first element would be the preferred MIME type.
        
        // ???: Should I have a couple methods that return the MIME media type name and the MIME subtype name?
        
        // Values from http://www.w3schools.com/media/media_mimeref.asp
        // There are probably values missed, but this is a good start.
        // A few more have been added that weren't included on the original list.
        MIMEDict = @{             @"":        @"application/octet-stream",
                                  @"323":     @"text/h323",
                                  @"acx":     @"application/internet-property-stream",
                                  @"ai":      @"application/postscript",
                                  @"aif":     @"audio/x-aiff",
                                  @"aifc":    @"audio/x-aiff",
                                  @"aiff":    @"audio/x-aiff",
                                  @"asf":     @"video/x-ms-asf",
                                  @"asr":     @"video/x-ms-asf",
                                  @"asx":     @"video/x-ms-asf",
                                  @"au":      @"audio/basic",
                                  @"avi":     @"video/x-msvideo",
                                  @"axs":     @"application/olescript",
                                  @"bas":     @"text/plain",
                                  @"bcpio":   @"application/x-bcpio",
                                  @"bin":     @"application/octet-stream",
                                  @"bmp":     @"image/bmp",
                                  @"c":       @"text/plain",
                                  @"cat":     @"application/vnd.ms-pkiseccat",
                                  @"cdf":     @"application/x-cdf",
                                  @"cer":     @"application/x-x509-ca-cert",
                                  @"class":   @"application/octet-stream",
                                  @"clp":     @"application/x-msclip",
                                  @"cmx":     @"image/x-cmx",
                                  @"cod":     @"image/cis-cod",
                                  @"cpio":    @"application/x-cpio",
                                  @"crd":     @"application/x-mscardfile",
                                  @"crl":     @"application/pkix-crl",
                                  @"crt":     @"application/x-x509-ca-cert",
                                  @"csh":     @"application/x-csh",
                                  @"css":     @"text/css",
                                  @"dcr":     @"application/x-director",
                                  @"der":     @"application/x-x509-ca-cert",
                                  @"dir":     @"application/x-director",
                                  @"dll":     @"application/x-msdownload",
                                  @"dms":     @"application/octet-stream",
                                  @"doc":     @"application/msword",
                                  @"docx":    @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                                  @"dot":     @"application/msword",
                                  @"dvi":     @"application/x-dvi",
                                  @"dxr":     @"application/x-director",
                                  @"eps":     @"application/postscript",
                                  @"etx":     @"text/x-setext",
                                  @"evy":     @"application/envoy",
                                  @"exe":     @"application/octet-stream",
                                  @"fif":     @"application/fractals",
                                  @"flr":     @"x-world/x-vrml",
                                  @"gif":     @"image/gif",
                                  @"gtar":    @"application/x-gtar",
                                  @"gz":      @"application/x-gzip",
                                  @"h":       @"text/plain",
                                  @"hdf":     @"application/x-hdf",
                                  @"hlp":     @"application/winhlp",
                                  @"hqx":     @"application/mac-binhex40",
                                  @"hta":     @"application/hta",
                                  @"htc":     @"text/x-component",
                                  @"htm":     @"text/html",
                                  @"html":    @"text/html",
                                  @"htt":     @"text/webviewhtml",
                                  @"ico":     @"image/x-icon",
                                  @"ief":     @"image/ief",
                                  @"iii":     @"application/x-iphone",
                                  @"ins":     @"application/x-internet-signup",
                                  @"isp":     @"application/x-internet-signup",
                                  @"jfif":    @"image/pipeg",
                                  @"jpe":     @"image/jpeg",
                                  @"jpeg":    @"image/jpeg",
                                  @"jpg":     @"image/jpeg",
                                  @"js":      @"application/x-javascript",
                                  @"json":    @"application/json",   // According to RFC 4627  // Also application/x-javascript text/javascript text/x-javascript text/x-json
                                  @"latex":   @"application/x-latex",
                                  @"lha":     @"application/octet-stream",
                                  @"lsf":     @"video/x-la-asf",
                                  @"lsx":     @"video/x-la-asf",
                                  @"lzh":     @"application/octet-stream",
                                  @"m":       @"text/plain",
                                  @"m13":     @"application/x-msmediaview",
                                  @"m14":     @"application/x-msmediaview",
                                  @"m3u":     @"audio/x-mpegurl",
                                  @"man":     @"application/x-troff-man",
                                  @"mdb":     @"application/x-msaccess",
                                  @"me":      @"application/x-troff-me",
                                  @"mht":     @"message/rfc822",
                                  @"mhtml":   @"message/rfc822",
                                  @"mid":     @"audio/mid",
                                  @"mny":     @"application/x-msmoney",
                                  @"mov":     @"video/quicktime",
                                  @"movie":   @"video/x-sgi-movie",
                                  @"mp2":     @"video/mpeg",
                                  @"mp3":     @"audio/mpeg",
                                  @"mpa":     @"video/mpeg",
                                  @"mpe":     @"video/mpeg",
                                  @"mpeg":    @"video/mpeg",
                                  @"mpg":     @"video/mpeg",
                                  @"mpp":     @"application/vnd.ms-project",
                                  @"mpv2":    @"video/mpeg",
                                  @"ms":      @"application/x-troff-ms",
                                  @"mvb":     @"    application/x-msmediaview",
                                  @"nws":     @"message/rfc822",
                                  @"oda":     @"application/oda",
                                  @"p10":     @"application/pkcs10",
                                  @"p12":     @"application/x-pkcs12",
                                  @"p7b":     @"application/x-pkcs7-certificates",
                                  @"p7c":     @"application/x-pkcs7-mime",
                                  @"p7m":     @"application/x-pkcs7-mime",
                                  @"p7r":     @"application/x-pkcs7-certreqresp",
                                  @"p7s":     @"    application/x-pkcs7-signature",
                                  @"pbm":     @"image/x-portable-bitmap",
                                  @"pdf":     @"application/pdf",
                                  @"pfx":     @"application/x-pkcs12",
                                  @"pgm":     @"image/x-portable-graymap",
                                  @"pko":     @"application/ynd.ms-pkipko",
                                  @"pma":     @"application/x-perfmon",
                                  @"pmc":     @"application/x-perfmon",
                                  @"pml":     @"application/x-perfmon",
                                  @"pmr":     @"application/x-perfmon",
                                  @"pmw":     @"application/x-perfmon",
                                  @"png":     @"image/png",
                                  @"pnm":     @"image/x-portable-anymap",
                                  @"pot":     @"application/vnd.ms-powerpoint",
                                  @"vppm":    @"image/x-portable-pixmap",
                                  @"pps":     @"application/vnd.ms-powerpoint",
                                  @"ppt":     @"application/vnd.ms-powerpoint",
                                  @"pptx":    @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                                  @"prf":     @"application/pics-rules",
                                  @"ps":      @"application/postscript",
                                  @"pub":     @"application/x-mspublisher",
                                  @"qt":      @"video/quicktime",
                                  @"ra":      @"audio/x-pn-realaudio",
                                  @"ram":     @"audio/x-pn-realaudio",
                                  @"ras":     @"image/x-cmu-raster",
                                  @"rgb":     @"image/x-rgb",
                                  @"rmi":     @"audio/mid",
                                  @"roff":    @"application/x-troff",
                                  @"rtf":     @"application/rtf",
                                  @"rtx":     @"text/richtext",
                                  @"scd":     @"application/x-msschedule",
                                  @"sct":     @"text/scriptlet",
                                  @"setpay":  @"application/set-payment-initiation",
                                  @"setreg":  @"application/set-registration-initiation",
                                  @"sh":      @"application/x-sh",
                                  @"shar":    @"application/x-shar",
                                  @"sit":     @"application/x-stuffit",
                                  @"snd":     @"audio/basic",
                                  @"spc":     @"application/x-pkcs7-certificates",
                                  @"spl":     @"application/futuresplash",
                                  @"src":     @"application/x-wais-source",
                                  @"sst":     @"application/vnd.ms-pkicertstore",
                                  @"stl":     @"application/vnd.ms-pkistl",
                                  @"stm":     @"text/html",
                                  @"svg":     @"image/svg+xml",
                                  @"sv4cpio": @"application/x-sv4cpio",
                                  @"sv4crc":  @"application/x-sv4crc",
                                  @"swf":     @"application/x-shockwave-flash",
                                  @"t":       @"application/x-troff",
                                  @"tar":     @"application/x-tar",
                                  @"tcl":     @"application/x-tcl",
                                  @"tex":     @"application/x-tex",
                                  @"texi":    @"application/x-texinfo",
                                  @"texinfo": @"application/x-texinfo",
                                  @"tgz":     @"application/x-compressed",
                                  @"tif":     @"image/tiff",
                                  @"tiff":    @"image/tiff",
                                  @"tr":      @"application/x-troff",
                                  @"trm":     @"application/x-msterminal",
                                  @"tsv":     @"text/tab-separated-values",
                                  @"txt":     @"text/plain",
                                  @"uls":     @"text/iuls",
                                  @"ustar":   @"application/x-ustar",
                                  @"vcf":     @"text/x-vcard",
                                  @"vrml":    @"x-world/x-vrml",
                                  @"wav":     @"audio/x-wav",
                                  @"wcm":     @"application/vnd.ms-works",
                                  @"wdb":     @"application/vnd.ms-works",
                                  @"wks":     @"application/vnd.ms-works",
                                  @"wmf":     @"application/x-msmetafile",
                                  @"wps":     @"application/vnd.ms-works",
                                  @"wri":     @"application/x-mswrite",
                                  @"wrl":     @"x-world/x-vrml",
                                  @"wrz":     @"x-world/x-vrml",
                                  @"xaf":     @"x-world/x-vrml",
                                  @"xbm":     @"image/x-xbitmap",
                                  @"xla":     @"application/vnd.ms-excel",
                                  @"xlc":     @"application/vnd.ms-excel",
                                  @"xlm":     @"application/vnd.ms-excel",
                                  @"xls":     @"application/vnd.ms-excel",
                                  @"xlsx":    @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                  @"xlt":     @"application/vnd.ms-excel",
                                  @"xlw":     @"application/vnd.ms-excel",
                                  @"xml":     @"text/xml",   // According to RFC 3023   // Also application/xml
                                  @"xof":     @"x-world/x-vrml",
                                  @"xpm":     @"image/x-xpixmap",
                                  @"xwd":     @"image/x-xwindowdump",
                                  @"z":      @"application/x-compress",
                                  @"zip":     @"application/zip"};
    }
    
    return MIMEDict;
}

#pragma mark - NormalRegEx
- (BOOL)qbIsOnlyLetters {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)qbIsOnlyLowercaseLetters {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet lowercaseLetterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)qbIsOnlyUppercaseLetters {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet uppercaseLetterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)qbIsOnlyCapitalizedLetters {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet capitalizedLetterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)qbIsOnlyNumbersAndLetters {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)qb_isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)qbIsOnlyDecimalDigit {
    NSCharacterSet *letterCharacterset = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

- (BOOL)qbIsPositiceInteger {
    NSString *regex = @"^[\\d]+$";
    return [self qb_isValidateByRegex:regex];
}
    
- (BOOL)qbIsOnlyChinese {
    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
    return [self qb_isValidateByRegex:chineseRegex];
}

- (BOOL)qbIsChineseOrLettersOrNumbers {
    NSString *regex = @"^[A-Za-z0-9\\u4e00-\u9fa5]+?$";
    return [self qb_isValidateByRegex:regex];
}

+ (BOOL)qbIsLettersBegin:(NSString *)string {
    if ([NSString qbIsEmpty:string]) {
        return NO;
    }

    NSString *firstString = [string substringToIndex:1];
    return [firstString qbIsOnlyLetters];
}

+ (BOOL)qbIsChineseBegin:(NSString *)string {
    if ([NSString qbIsEmpty:string]) {
        return NO;
    }
    
    NSString *firstString = [string substringToIndex:1];
    return [firstString qbIsOnlyChinese];
}

- (BOOL)qbIsPassword {
    NSString *pwdRegex = @"^[A-Za-z0-9]*$";
    return [self qb_isValidateByRegex:pwdRegex];
}

- (BOOL)qbIsEmailAddress {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self qb_isValidateByRegex:emailRegex];
}

- (BOOL)qbSimpleVerifyIdentityCardNum {
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self qb_isValidateByRegex:regex2];
}

+ (BOOL)qbIsBankCardNo:(NSString *)string {
    if ([NSString qbIsEmpty:string]) {
        return NO;
    }
    int oddSum = 0;//奇数求和
    int evenSum = 0;//偶数求和
    int allSum = 0;
    int cardNoLength = (int)[string length];
    int lastNum = [[string substringFromIndex:cardNoLength - 1] intValue];
    
    string = [string substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1; i >= 1; i--) {
        NSString *tmpString = [string substringWithRange:NSMakeRange( i-1, 1)];
        int tmpValue = [tmpString intValue];
        if (cardNoLength % 2 == 1) {
            if((i % 2) == 0) {
                tmpValue *= 2;
                if(tmpValue >= 10) {
                    tmpValue -= 9;
                }
                evenSum += tmpValue;
            } else {
                oddSum += tmpValue;
            }
        } else {
            if((i % 2) == 1) {
                tmpValue *= 2;
                if(tmpValue >= 10) {
                    tmpValue -= 9;
                }
                evenSum += tmpValue;
            } else {
                oddSum += tmpValue;
            }
        }
    }
    
    allSum = oddSum + evenSum;
    allSum += lastNum;
    
    if ((allSum % 10) == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)qbIsIPAddress {
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    BOOL rc = [self qb_isValidateByRegex:regex];
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}

- (BOOL)qbIsMacAddress {
    NSString *macAddRegex = @"([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}";
    return [self qb_isValidateByRegex:macAddRegex];
}

- (BOOL)qbIsValidURL {
    NSString *regex = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self qb_isValidateByRegex:regex];
}

- (BOOL)qbIsValidPostalCode {
    NSString *postalRegex = @"^[0-8]\\d{5}(?!\\d)$";
    return [self qb_isValidateByRegex:postalRegex];
}

- (BOOL)qbIsValidTaxNo {
    NSString *taxNoRegex = @"[0-9]\\d{13}([0-9]|X)$";
    return [self qb_isValidateByRegex:taxNoRegex];
}

- (BOOL)qbIsMobileNumber {
    if ([NSString qbIsEmpty:self]) {
        return NO;
    }
    NSString *regex = @"^(1[3|4|5|7|8][0-9])\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)qbIsValidWithMinLenth:(NSInteger)minLenth
                     maxLenth:(NSInteger)maxLenth
               containChinese:(BOOL)containChinese
          firstCannotBeDigtal:(BOOL)firstCannotBeDigtal {
    //  [\u4e00-\u9fa5A-Za-z0-9_]{4,20}
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *regex = [NSString stringWithFormat:@"%@[%@A-Za-z0-9_]{%d,%d}", first, hanzi, (int)(minLenth-1), (int)(maxLenth-1)];
    return [self qb_isValidateByRegex:regex];
}

- (BOOL)qbIsValidWithMinLenth:(NSInteger)minLenth
                     maxLenth:(NSInteger)maxLenth
               containChinese:(BOOL)containChinese
                containDigtal:(BOOL)containDigtal
                containLetter:(BOOL)containLetter
        containOtherCharacter:(NSString *)containOtherCharacter
          firstCannotBeDigtal:(BOOL)firstCannotBeDigtal {
    NSString *hanzi = containChinese ? @"\u4e00-\u9fa5" : @"";
    NSString *first = firstCannotBeDigtal ? @"^[a-zA-Z_]" : @"";
    NSString *lengthRegex = [NSString stringWithFormat:@"(?=^.{%@,%@}$)", @(minLenth), @(maxLenth)];
    NSString *digtalRegex = containDigtal ? @"(?=(.*\\d.*){1})" : @"";
    NSString *letterRegex = containLetter ? @"(?=(.*[a-zA-Z].*){1})" : @"";
    NSString *characterRegex = [NSString stringWithFormat:@"(?:%@[%@A-Za-z0-9%@]+)", first, hanzi, containOtherCharacter ? containOtherCharacter : @""];
    NSString *regex = [NSString stringWithFormat:@"%@%@%@%@", lengthRegex, digtalRegex, letterRegex, characterRegex];
    return [self qb_isValidateByRegex:regex];
}

- (BOOL)qbIsValidChineseCharWithMinLength:(NSUInteger)minLenth maxLength:(NSUInteger)maxLenth {
    if ([NSString qbIsEmpty:self] || self.length == 0 || [self qbTrimmingWhitespace].length == 0) {
        return NO;
    }
    NSString *invoiceRegex = [NSString stringWithFormat:@"[\\u4e00-\\u9fa5]{%ld,%ld}", (unsigned long)minLenth, (unsigned long)maxLenth];
    return [self qb_isValidateByRegex:invoiceRegex];
}

#pragma mark - CGSize
+ (CGSize)qbSizeWithString:(NSString *)string font:(UIFont *)font {
    return [NSString qbSizeWithString:string font:font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

+ (CGSize)qbSizeWithString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    return [NSString qbSizeWithString:string font:font maxSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lines:1];
}

+ (CGSize)qbSizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize {
    return [NSString qbSizeWithString:string font:font maxSize:maxSize lines:1];
}

+ (CGSize)qbSizeWithString:(NSString *)string font:(UIFont *)font lines:(NSInteger)lines {
    return [NSString qbSizeWithString:string font:font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lines:lines];
}

+ (CGSize)qbSizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize lines:(NSInteger)lines {
    return [NSString qbSizeWithString:string font:font maxSize:maxSize lines:lines lineSpacing:0];
}
    
+ (CGSize)qbSizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize lines:(NSInteger)lines lineSpacing:(CGFloat)lineSpacing {
    if ([NSString qbIsEmpty:string]) {
        return CGSizeZero;
    }
    if (CGSizeEqualToSize(CGSizeZero, maxSize)) {
        maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    if (lines == 1) {
        NSDictionary *attrs = @{NSFontAttributeName : font};
        CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        if (size.width == 0) {
            size = CGSizeZero;
        }
        return CGSizeMake(ceil(MIN(size.width, maxSize.width)), ceil(size.height));
    } else {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        CGFloat newLineSpacing = lineSpacing - (font.lineHeight - font.pointSize);
        if (newLineSpacing < 0) {
            newLineSpacing = 0;
        }
        [style setLineSpacing:newLineSpacing];
        
        NSDictionary *attrs = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : style};
        CGSize oneSize = [string sizeWithAttributes:attrs];
        CGSize size = [string boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attrs context:nil].size;
        NSInteger actualLines = (NSInteger)(size.height / oneSize.height);
        if (actualLines >= lines) {
            size = CGSizeMake(ceil(maxSize.width), ceil(lines * oneSize.height));
        } else {
            size = CGSizeMake(ceil(maxSize.width), ceil(actualLines * oneSize.height));
        }
        return size;
    }
    return CGSizeZero;
}

+ (CGFloat)qbWidthWithString:(NSString *)string font:(UIFont *)font maxHeight:(CGFloat)maxHeight {
    return [NSString qbSizeWithString:string font:font maxSize:CGSizeMake(CGFLOAT_MAX, maxHeight) lines:1].width;
}

+ (NSUInteger)qbCalcLinesOfString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth lineSpacing:(CGFloat)lineSpacing {
    if ([NSString qbIsEmpty:string]) {
        return 0;
    }
    if (maxWidth <= 0) {
        return 0;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    NSDictionary *attrs = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : style};
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attrs context:nil].size;
    NSInteger lines = (NSInteger)(size.height / (font.lineHeight + lineSpacing));
    return lines;
}

+ (CGFloat)qbCalcHeightWithString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [string boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
    return  ceilf(size.height);
}

#pragma mark - Range

/// 获取子字符串在元字符串中出现的所有位置
+ (NSArray<NSValue *> *)qbRangesOfSubstring:(NSString *)substring inString:(NSString *)str {
    NSMutableArray *results = [NSMutableArray array];
    NSRange substringRange = NSMakeRange(0, [str length]);
    NSRange range;

    while ((range = [str rangeOfString:substring options:0 range:substringRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        substringRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
    }
    
    return results;
}

#pragma mark - Memory
- (void)qbClearMemory {
    const char *string = (char *)CFStringGetCStringPtr((CFStringRef)self,CFStringGetSystemEncoding());
    memset(&string, 0, sizeof(self));
}

@end

@implementation NSMutableString (QBExtension)

- (void)qbReplaceString:(NSString *)searchString withString:(NSString *)newString {
    NSRange range = [self rangeOfString:searchString];
    if (range.location != NSNotFound) {
        [self replaceCharactersInRange:range withString:newString];
    }
}

@end
