//
//  UIColor+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (QBExtension)

/// 获取颜色
/// @param startHex 开始十六进制颜色
/// @param endHex 结束十六进制颜色
/// @param startAlpha 开始透明度
/// @param endAlpha 结束透明度
/// @param rate 比例
+ (UIColor *)qbCalcLinearGradientColorWithStartHexColor:(NSString *)startHex
                                            endHexColor:(NSString *)endHex
                                             startAlpha:(CGFloat)startAlpha
                                               endAlpha:(CGFloat)endAlpha
                                                   rate:(CGFloat)rate;

/// 获取颜色
/// @param startColor 开始颜色
/// @param endColor 结束颜色
/// @param startAlpha 开始透明度
/// @param endAlpha 结束透明度
/// @param rate  比例
+ (UIColor *)qbCalcLinearGradientColorWithStartColor:(UIColor *)startColor
                                            endColor:(UIColor *)endColor
                                          startAlpha:(CGFloat)startAlpha
                                            endAlpha:(CGFloat)endAlpha
                                                rate:(CGFloat)rate;

+ (UIColor *)qbColorWithHexValue:(NSUInteger)hex;
+ (UIColor *)qbColorWithHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;
+ (UIColor *)qbColorWithShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha;
    

/// 随机颜色
+ (UIColor *)qbRandomColor;

/// hex颜色
/// @param hex 颜色字符串
/// @param defaultHex 默认的颜色字符串
/// @param alpha 透明度
+ (UIColor *)qbColorWithHexString:(NSString *)hex defaultHexString:(NSString *)defaultHex alpha:(CGFloat)alpha;

/// hex颜色
/// @param hex 颜色字符串
/// @param alpha 透明度
+ (UIColor *)qbColorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;

/// hex颜色
/// @param hex 颜色字符串
/// @param defaultHex 默认的颜色字符串
+ (UIColor *)qbColorWithHexString:(NSString *)hex defaultHexString:(NSString *)defaultHex;

/// hex颜色
/// @param hex 颜色字符串
+ (UIColor *)qbColorWithHexString:(NSString *)hex;

@end

NS_ASSUME_NONNULL_END
