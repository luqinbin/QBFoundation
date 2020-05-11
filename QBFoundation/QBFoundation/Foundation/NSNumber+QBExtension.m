//
//  NSNumber+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSNumber+QBExtension.h"
#import "NSString+QBExtension.h"

@implementation NSNumber (QBExtension)

- (char)qbCharValue {
    if (self && [self respondsToSelector:@selector(charValue)]) {
        return [self charValue];
    }
    return 0;
}

- (unsigned char)qbUnsignedCharValue {
    if (self && [self respondsToSelector:@selector(unsignedCharValue)]) {
        return [self unsignedCharValue];
    }
    return 0;
}

- (short)qbShortValue {
    if (self && [self respondsToSelector:@selector(shortValue)]) {
        return [self shortValue];
    }
    return 0;
}

- (unsigned short)qbUnsignedShortValue {
    if (self && [self respondsToSelector:@selector(unsignedShortValue)]) {
        return [self unsignedShortValue];
    }
    return 0;
}

- (int)qbIntValue {
    if (self && [self respondsToSelector:@selector(intValue)]) {
        return [self intValue];
    }
    return 0;
}

- (unsigned int)qbUnsignedIntValue {
    if (self && [self respondsToSelector:@selector(unsignedIntValue)]) {
        return [self unsignedIntValue];
    }
    return 0;
}

- (long)qbLongValue {
    if (self && [self respondsToSelector:@selector(longValue)]) {
        return [self longValue];
    }
    return 0;
}

- (unsigned long)qbUnsignedLongValue {
    if (self && [self respondsToSelector:@selector(unsignedLongValue)]) {
        return [self unsignedLongValue];
    }
    return 0;
}

- (long long)qbLongLongValue {
    if (self && [self respondsToSelector:@selector(longLongValue)]) {
        return [self longLongValue];
    }
    return 0;
}

- (unsigned long long)qbUnsignedLongLongValue {
    if (self && [self respondsToSelector:@selector(unsignedLongLongValue)]) {
        return [self unsignedLongLongValue];
    }
    return 0;
}

- (float)qbFloatValue {
    if (self && [self respondsToSelector:@selector(floatValue)]) {
        return [self floatValue];
    }
    return 0.0f;
}

- (double)qbDoubleValue {
    if (self && [self respondsToSelector:@selector(doubleValue)]) {
        return [self doubleValue];
    }
    return 0.0f;
}

- (BOOL)qbBoolValue {
    if (self && [self respondsToSelector:@selector(boolValue)]) {
        return [self boolValue];
    }
    return false;
}

- (NSInteger)qbIntegerValue NS_AVAILABLE(10_5, 2_0) {
    if (self && [self respondsToSelector:@selector(integerValue)]) {
        return [self integerValue];
    }
    return 0;
}

- (NSUInteger)qbUnsignedIntegerValue NS_AVAILABLE(10_5, 2_0) {
    if (self && [self respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [self unsignedIntegerValue];
    }
    return 0;
}

- (NSDecimalNumber *)qbConvertToDecimalNumber {
    if ([self isMemberOfClass:[NSDecimalNumber class]]) {
        return (NSDecimalNumber *)self;
    }
    return [NSDecimalNumber decimalNumberWithDecimal:[self decimalValue]];
}

#pragma mark - CGFloat
- (CGFloat)qbCGFloatValue {
#if (CGFLOAT_IS_DOUBLE == 1)
    CGFloat result = [self doubleValue];
#else
    CGFloat result = [self floatValue];
#endif
    return result;
}

- (instancetype)initWithqbCGFloat:(CGFloat)value {
#if (CGFLOAT_IS_DOUBLE == 1)
    self = [self initWithDouble:value];
#else
    self = [self initWithFloat:value];
#endif
    return self;
}

+ (NSNumber *)qbNumberWithCGFloat:(CGFloat)value {
    NSNumber *number = [[self alloc] initWithqbCGFloat:value];
    return number;
}

#pragma mark - Random
+ (int)qbRandomInt:(int)maxInt {
    int r = arc4random() % maxInt;
    
    return r;
}

+ (BOOL)qbRandomBool {
    return [NSNumber qbRandomInt:2] != 0 ? YES : NO;
}

+ (CGFloat)qbRandoqbGFloat {
    return (float) arc4random() / UINT_MAX;
}

+ (CGFloat)qbRandoqbGFloatBetweenMin:(CGFloat)minValue andMax:(CGFloat)maxValue {
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (maxValue - minValue)) + minValue;
}

#pragma mark - Comparison
- (BOOL)qbIsSame:(NSNumber *)otherNumber {
    return ([self compare:otherNumber] == NSOrderedSame);
}

- (BOOL)qbIsGreaterThan:(NSNumber *)otherNumber {
    return ([self compare:otherNumber] == NSOrderedDescending);
}

- (BOOL)qbIsLessThan:(NSNumber *)otherNumber {
    return ([self compare:otherNumber] == NSOrderedAscending);
}

- (BOOL)qbIsEven {
    return (![self qbIsOdd]);
}

- (BOOL)qbIsOdd {
    if ([self qbIsFraction]) {
        return YES;
    }
    if ([self qbIsSame:@0]) {
        return NO;
    }
    return [[self qbDivideBy:@2] qbIsFraction];
}

#pragma mark - Fraction
- (instancetype)qbIntegralPart {
    if ([self isMemberOfClass:[NSNumber class]])
        return [NSNumber numberWithInteger:[self integerValue]];
    
    return [[NSDecimalNumber numberWithInteger:[self integerValue]] qbConvertToDecimalNumber];
}

- (instancetype)qbFractionalPart {
    NSDecimalNumber *integerPart = [[self qbIntegralPart] qbConvertToDecimalNumber];
    return [[self qbConvertToDecimalNumber] decimalNumberBySubtracting:integerPart];
}

- (BOOL)qbIsInteger {
    return ([[self qbFractionalPart] isEqualToNumber:@0]);
}

- (BOOL)qbIsFraction {
    return (![self qbIsInteger]);
}

#pragma mark - Manipulation
- (instancetype)qbAdd:(NSNumber *)otherNumber {
    return [[self qbConvertToDecimalNumber] decimalNumberByAdding:[otherNumber qbConvertToDecimalNumber]];
}

- (instancetype)qbSubtract:(NSNumber *)otherNumber {
    return [[self qbConvertToDecimalNumber] decimalNumberBySubtracting:[otherNumber qbConvertToDecimalNumber]];
}

- (instancetype)qbMultiplyBy:(NSNumber *)otherNumber {
    return [[self qbConvertToDecimalNumber] decimalNumberByMultiplyingBy:[otherNumber qbConvertToDecimalNumber]];
}

- (instancetype)qbDivideBy:(NSNumber *)otherNumber {
    return [[self qbConvertToDecimalNumber] decimalNumberByDividingBy:[otherNumber qbConvertToDecimalNumber]];
}

- (instancetype)qbRaiseToPower:(NSInteger)power {
    if (power < 0) {
        return [self _raiseToNegativePower:power];
    }
    return [[self qbConvertToDecimalNumber] decimalNumberByRaisingToPower:power];
}

- (instancetype)_raiseToNegativePower:(NSInteger)power {
    /*
     source:
     http://stackoverflow.com/questions/3596060/raise-an-nsdecimalnumber-to-a-negative-power
     
     a^(-b) == 1 / (a^b)
     */
    
    power = power * (-1);
    
    id result = [self qbRaiseToPower:power];
    return [[NSDecimalNumber one] qbDivideBy:result];
}

#pragma mark - Negative
- (BOOL)qbIsPositive {
    return (![self qbIsNegative]);
}

- (BOOL)qbIsNegative {
    return ([self doubleValue] < 0);
}

#pragma mark - DateValue
- (NSDate *)qbDateValue {
    return [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
}

#pragma mark - Hex
// Implementation from René Puls
// http://lists.apple.com/archives/Cocoa-dev/2005/Jan/msg01253.html
+ (NSNumber *)qbNumberWithHex:(NSString *)hexString {
    unsigned int tempInt;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if (![scanner scanHexInt:&tempInt]) {
        return @(0);
    }
    return [NSNumber numberWithInt:tempInt];
}

// Implementation from René Puls
// http://lists.apple.com/archives/Cocoa-dev/2005/Jan/msg01253.html
- (NSString *)qbHexString {
    return [NSString stringWithFormat:@"0x%x", [self intValue]];
}

#pragma mark - RomanNumerals
//https://github.com/pzearfoss/NSNumber-RomanNumerals
- (NSString *)qbRomanNumeral {
    NSInteger n = [self integerValue];
    
    NSArray *numerals = @[@"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I"];
    
    NSUInteger valueCount = 13;
    NSUInteger values[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
    
    NSMutableString *numeralString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < valueCount; i++) {
        while (n >= values[i]) {
            n -= values[i];
            [numeralString appendString:[numerals objectAtIndex:i]];
        }
    }
    return numeralString;
}

#pragma mark - Round
- (NSString *)qbToDisplayNumberWithDigit:(NSInteger)digit {
    NSString *result = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:digit];
    result = [formatter stringFromNumber:self];
    if (!result) {
        return @"";
    }
    return result;
}

- (NSString *)qbToDisplayPercentageWithDigit:(NSInteger)digit {
    NSString *result = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:digit];
    result = [formatter stringFromNumber:self];
    if (!result) {
        return @"";
    }
    return result;
}

- (NSNumber *)qbDoRoundWithDigit:(NSUInteger)digit {
    NSNumber *result = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:digit];
    [formatter setMinimumFractionDigits:digit];
    result = [NSNumber numberWithDouble:[[formatter stringFromNumber:self] doubleValue]];
    return result;
}

- (NSNumber *)qbDoCeilWithDigit:(NSUInteger)digit {
    NSNumber *result = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundCeiling];
    [formatter setMaximumFractionDigits:digit];
    result = [NSNumber numberWithDouble:[[formatter stringFromNumber:self] doubleValue]];

    return result;
}

- (NSNumber *)qbDoFloorWithDigit:(NSUInteger)digit {
    NSNumber *result = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundFloor];
    [formatter setMaximumFractionDigits:digit];
    result = [NSNumber numberWithDouble:[[formatter stringFromNumber:self] doubleValue]];
    return result;
}

#pragma mark - String
+ (NSNumber *)qbNumberWithString:(NSString *)string {
    NSString *str = [[string qbTrimmingWhitespace] lowercaseString];
    if ([NSString qbIsEmpty:str]) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    NSNumber *num = dic[str];
    if (num != nil) {
        if (num == (id)[NSNull null]) {
            return nil;
        }
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) {
        sign = 1;
    } else if ([str hasPrefix:@"-0x"]) {
        sign = -1;
    }
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc) {
            return [NSNumber numberWithLong:((long)num * sign)];
        } else {
            return nil;
        }
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end
