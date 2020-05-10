//
//  NSNumber+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (QBExtension)

- (char)qbCharValue;

- (unsigned char)qbUnsignedCharValue;

- (short)qbShortValue;

- (unsigned short)qbUnsignedShortValue;

- (int)qbIntValue;

- (unsigned int)qbUnsignedIntValue;

- (long)qbLongValue;

- (unsigned long)qbUnsignedLongValue;

- (long long)qbLongLongValue;

- (unsigned long long)qbUnsignedLongLongValue;

- (float)qbFloatValue;

- (double)qbDoubleValue;

- (BOOL)qbBoolValue;

- (NSInteger)qbIntegerValue NS_AVAILABLE(10_5, 2_0);

- (NSUInteger)qbUnsignedIntegerValue NS_AVAILABLE(10_5, 2_0);

- (NSDecimalNumber *)qbConvertToDecimalNumber;

#pragma mark - CGFloat
- (CGFloat)qbCGFloatValue;

- (instancetype)initWithqbCGFloat:(CGFloat)value;

+ (NSNumber *)qbNumberWithCGFloat:(CGFloat)value;

#pragma mark - Random
+ (int)srRandomInt:(int)maxInt;

+ (BOOL)qbRandomBool;

+ (CGFloat)qbRandoqbGFloat;

+ (CGFloat)qbRandoqbGFloatBetweenMin:(CGFloat)minValue andMax:(CGFloat)maxValue;

#pragma mark - Comparison
- (BOOL)qbIsSame:(NSNumber *)otherNumber;

- (BOOL)qbIsGreaterThan:(NSNumber *)otherNumber;

- (BOOL)qbIsLessThan:(NSNumber *)otherNumber;

// 是否是偶数
- (BOOL)qbIsEven;

// 是否是奇数
- (BOOL)qbIsOdd;

#pragma mark - Fraction
- (instancetype)qbIntegralPart;

- (instancetype)qbFractionalPart;

- (BOOL)qbIsInteger;

- (BOOL)qbIsFraction;

#pragma mark - Manipulation
- (instancetype)qbAdd:(NSNumber *)otherNumber;

- (instancetype)qbSubtract:(NSNumber *)otherNumber;

- (instancetype)qbMultiplyBy:(NSNumber *)otherNumber;

- (instancetype)qbDivideBy:(NSNumber *)otherNumber;

- (instancetype)qbRaiseToPower:(NSInteger)power;

#pragma mark - Negative
/**
 是否为正数

 @return BOOL
 */
- (BOOL)qbIsPositive;

/**
 是否为负数

 @return BOOL
 */
- (BOOL)qbIsNegative;

#pragma mark - DateValue
/**
 转化为日期

 @return NSDate
 */
- (NSDate *)qbDateValue;

#pragma mark - Hex
/**
 用十六进制字符串创建一个number对象

 @param hexString 十六进制字符串
 @return NSNumber
 */
+ (NSNumber *)qbNumberWithHex:(NSString *)hexString;

/**
 返回十六进制字符串

 @return NSString
 */
- (NSString *)qbHexString;

#pragma mark - RomanNumerals
/**
 以罗马数字的形式展示

 @return NSString
 */
- (NSString *)qbRomanNumeral;

#pragma mark - Round
/**
 digit以小数的形式展示

 @param digit digit
 @return NSString
 */
- (NSString *)qbToDisplayNumberWithDigit:(NSInteger)digit;

/**
 digit以百分比的形式展示

 @param digit digit
 @return NSString
 */
- (NSString *)qbToDisplayPercentageWithDigit:(NSInteger)digit;

/**
 四舍五入

 @param digit 限制最大位数
 @return NSNumber
 */
- (NSNumber *)qbDoRoundWithDigit:(NSUInteger)digit;

/**
 取上整

 @param digit 限制最大位数
 @return NSNumber
 */
- (NSNumber *)qbDoCeilWithDigit:(NSUInteger)digit;

/**
 取下整

 @param digit 限制最大位数
 @return NSNumber
 */
- (NSNumber *)qbDoFloorWithDigit:(NSUInteger)digit;

#pragma mark - String
/**
 NSString转换为NSNumber
 有效格式: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string string
 @return NSNumber
 */
+ (NSNumber *)qbNumberWithString:(NSString *)string;


@end

NS_ASSUME_NONNULL_END
