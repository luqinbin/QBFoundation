//
//  UILabel+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (QBExtension)

@property (nonatomic) UIEdgeInsets qbContentInsets;

#pragma mark - init
+ (UILabel *)qbLabelWithHexTextColor:(NSString *)hexTextColor font:(UIFont *)font;

+ (UILabel *)qbLabelWithHexTextColor:(NSString *)hexTextColor fontSize:(CGFloat)fontSize;

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font;

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor
                             font:(UIFont *)font
                    numberOfLines:(NSInteger)numberOfLines
                    textAlignment:(NSTextAlignment)textAlignment
                    lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor
                             font:(UIFont *)font
                    numberOfLines:(NSInteger)numberOfLines
                    textAlignment:(NSTextAlignment)textAlignment
                    lineBreakMode:(NSLineBreakMode)lineBreakMode
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor * _Nullable)borderColor
                     cornerRadius:(CGFloat)cornerRadius
                  backgroundColor:(UIColor * _Nullable)backgroundColor;

#pragma mark - paragraph

// 改变行间距、段落间距
- (void)qbChangeLineSpace:(float)lineSpacespace paragraphSpacing:(float)paragraphSpacing;

// 改变字间距
- (void)qbChangeWordSpace:(float)space;

@end

NS_ASSUME_NONNULL_END
