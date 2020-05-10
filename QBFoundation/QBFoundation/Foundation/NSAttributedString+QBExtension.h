//
//  NSAttributedString+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (QBExtension)

+ (nullable NSAttributedString *)qbStringWithString:(NSString * _Nullable)string;

/**
 在一段文本中高亮指定文本
 
 @param string 初始文本
 @param markString 高亮文本
 @param markFont 高亮文本指定字体
 @return NSAttributedString
 */
+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markString:(NSString *)markString markFont:(UIFont *)markFont;

/**
 在一段文本中高亮指定文本
 
 @param string 初始文本
 @param markString 高亮文本
 @param markFontColor 高亮文本指定字体颜色
 @return NSAttributedString
 */
+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markString:(NSString *)markString markFontColor:(UIColor *)markFontColor;

/**
 在一段文本中高亮指定文本
 
 @param string 初始文本
 @param markString 高亮文本
 @param markFont 高亮文本指定字体
 @param markFontColor 高亮文本指定字体颜色
 @return NSAttributedString
 */
+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markString:(NSString *)markString markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor;

/**
 在一段富文本中高亮指定文本(以字符为匹配单位)
 
 @param string 初始文本
 @param markString 高亮文本
 @param markFont 高亮文本指定字体
 @param markFontColor 高亮文本指定字体颜色
 @return NSAttributedString
 */
+ (NSAttributedString *)qbHightLightAttributedString:(NSAttributedString *)string markString:(NSString *)markString markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor;

/**
在一段文本中高亮指定多段文本(以字符为匹配单位)

@param string 初始文本
@param markStringArray 高亮文本数组
@param markFont 高亮文本指定字体
@param markFontColor 高亮文本指定字体颜色
@return NSAttributedString
*/
+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markStringArray:(NSArray<NSString *> *)markStringArray markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor;

/**
在一段富文本中高亮指定多段文本(以字符为匹配单位)

@param string 初始文本
@param markStringArray 高亮文本数组
@param markFont 高亮文本指定字体
@param markFontColor 高亮文本指定字体颜色
@return NSAttributedString
*/
+ (NSAttributedString *)qbHightLightAttributedString:(NSAttributedString *)string markStringArray:(NSArray<NSString *> *)markStringArray markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor;

/**
在一段富文本中高亮指定多段文字(以word为匹配单位)

@param string 初始文本
@param markWordArray 高亮word数组
@param markFont 高亮文本指定字体
@param markFontColor 高亮文本指定字体颜色
@return NSAttributedString
*/
+ (NSAttributedString *)qbHightLightAttributedString:(NSAttributedString *)string markWordArray:(NSArray<NSString *> *)markWordArray markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor;

#pragma mark - init
/**
 初始化
 
 @param string 文本
 @param fontColor 字体颜色
 @return instancetype
 */
- (instancetype)initWithString:(NSString *)string fontColor:(UIColor *)fontColor;

/**
 初始化
 
 @param string 文本
 @param font 字体
 @param fontColor 字体颜色
 @return instancetype
 */
- (instancetype)initWithString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)fontColor;

/**
 初始化
 
 @param string 文本
 @param font 字体
 @param fontColor 字体颜色
 @param shadow 阴影
 @return instancetype
 */
- (instancetype)initWithString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)fontColor shadow:(NSShadow *)shadow;

/**
 初始化
 
 @param string 文本
 @param font 字体
 @param lineHeight 每行的行高
 @param lineSpacing 行间距
 @return instancetype
 */
- (instancetype)initWithString:(NSString *)string font:(UIFont *)font lineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing;

/**
 初始化
 
 @param string 文本
 @param font 字体
 @param fontColor 字体颜色
 @param lineHeight 每行的行高
 @param lineSpacing 行间距
 @return instancetype
 */
- (instancetype)initWithString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)fontColor lineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing;

/**
 初始化
 
 @param string 文本
 @param font 字体
 @param lineHeight 每行的行高
 @return instancetype
 */
- (instancetype)initWithString:(NSString *)string font:(UIFont *)font lineHeight:(CGFloat)lineHeight;

@end


@interface NSMutableAttributedString (QBExtension)

/**
 设置字体属性
 
 @param font 字体
 */
- (void)qbAddFont:(UIFont *)font;

/**
 设置字体属性
 
 @param font 字体
 @param range 范围
 */
- (void)qbAddFont:(UIFont *)font range:(NSRange)range;

/**
 设置字体颜色，取值为 UIColor对象，默认值为黑色
 
 @param color 字体颜色
 */
- (void)qbAddFontColor:(UIColor *)color;

/**
 设置字体颜色，取值为 UIColor对象，默认值为黑色
 
 @param color 字体颜色
 @param range 范围
 */
- (void)qbAddFontColor:(UIColor *)color range:(NSRange)range;

/**
 设置字体属性与字体颜色
 
 @param font 字体
 @param fontColor 字体颜色
 */
- (void)qbAddFont:(UIFont *)font fontColor:(UIColor *)fontColor;

/**
 设置字体属性与字体颜色
 
 @param font 字体
 @param fontColor 字体颜色
 @param range 范围
 */
- (void)qbAddFont:(UIFont *)font fontColor:(UIColor *)fontColor range:(NSRange)range;

- (void)qbAddParagraphStyle:(NSParagraphStyle *)paragraphStyle;
- (void)qbAddParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range;
/**
 设置字体所在区域背景颜色
 
 @param color 颜色
 */
- (void)qbAddBackgroundColor:(UIColor *)color;

/**
 设置字体所在区域背景颜色
 
 @param color 颜色
 @param range 范围
 */
- (void)qbAddBackgroundColor:(UIColor *)color range:(NSRange)range;
/**
 设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 
 @param ligature ligature
 */
- (void)qbAddLigature:(NSInteger)ligature;

/**
 设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 
 @param ligature ligature
 @param range 范围
 */
- (void)qbAddLigature:(NSInteger)ligature range:(NSRange)range;

/**
 设定字符间距
 
 @param kern 间距大小
 */
- (void)qbAddKern:(CGFloat)kern;

/**
 设定字符间距
 
 @param kern 间距大小
 @param range 范围
 */
- (void)qbAddKern:(CGFloat)kern range:(NSRange)range;

/**
 设置删除线，取值为 NSNumber 对象（整数）
 
 @param strikethroughStyle 删除线的宽度
 */
- (void)qbAddStrikethroughStyle:(NSInteger)strikethroughStyle;

/**
 设置删除线，取值为 NSNumber 对象（整数）
 
 @param strikethroughStyle 删除线的宽度
 @param range 范围
 */
- (void)qbAddStrikethroughStyle:(NSInteger)strikethroughStyle range:(NSRange)range;

/**
 设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 
 @param style NSUnderlineStyle
 */
- (void)qbAddUnderlineStyle:(NSUnderlineStyle)style;
/**
 设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 
 @param style NSUnderlineStyle
 @param range 范围
 */
- (void)qbAddUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range;
/**
 填充部分颜色，不是字体颜色，取值为 UIColor 对象
 
 @param color 颜色
 */
- (void)qbAddStrokeColor:(UIColor *)color;

/**
 填充部分颜色，不是字体颜色，取值为 UIColor 对象
 
 @param color 颜色
 @param range 范围
 */
- (void)qbAddStrokeColor:(UIColor *)color range:(NSRange)range;

/**
 设置笔画宽度(粗细)，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 
 @param width 宽度
 */
- (void)qbAddStrokeWidth:(CGFloat)width;

/**
 设置笔画宽度(粗细)，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 
 @param width 宽度
 @param range 范围
 */
- (void)qbAddStrokeWidth:(CGFloat)width range:(NSRange)range;

/**
 设置阴影属性，取值为 NSShadow 对象
 
 @param shadow shadow
 */
- (void)qbAddShadow:(NSShadow *)shadow;

/**
 设置阴影属性，取值为 NSShadow 对象
 
 @param shadow shadow
 @param range 范围
 */
- (void)qbAddShadow:(NSShadow *)shadow range:(NSRange)range;

/**
 设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
 
 @param textEffect textEffect
 */
- (void)qbAddTextEffect:(NSString *)textEffect;

/**
 设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
 
 @param textEffect textEffect
 @param range 范围
 */
- (void)qbAddTextEffect:(NSString *)textEffect range:(NSRange)range;

/**
 插入NSTextAttachment
 
 @param textAttachment textAttachment
 @param index 索引
 */
- (void)qbInsertAttachment:(NSTextAttachment *)textAttachment atIndex:(NSInteger)index  NS_AVAILABLE_IOS(7_0);

/**
 插入图片
 
 @param image 图片
 @param imageBounds 图片大小
 @param index 索引
 */
- (void)qbInsertImageAttachment:(UIImage *)image bounds:(CGRect)imageBounds atIndex:(NSInteger)index;

/**
 设置链接属性，点击后调用浏览器打开指定URL地址
 
 @param linkURL 地址
 */

- (void)qbAddLink:(NSURL *)linkURL;
/**
 设置链接属性，点击后调用浏览器打开指定URL地址
 
 @param linkURL 地址
 @param range 范围
 */
- (void)qbAddLink:(NSURL *)linkURL range:(NSRange)range;

/**
 设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 
 @param offset 偏移值
 */
- (void)qbAddBaselineOffset:(CGFloat)offset;

/**
 设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 
 @param offset 偏移值
 @param range 范围
 */
- (void)qbAddBaselineOffset:(CGFloat)offset range:(NSRange)range;

/**
 设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 
 @param color 颜色
 */
- (void)qbAddUnderlineColor:(UIColor *)color;

/**
 设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 
 @param color 颜色
 @param range 范围
 */
- (void)qbAddUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 
 @param color 颜色
 */
- (void)qbAddStrikethroughColor:(UIColor *)color;

/**
 设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 
 @param color 颜色
 @param range 范围
 */
- (void)qbAddStrikethroughColor:(UIColor *)color range:(NSRange)range;

/**
 设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 
 @param obliqueness 倾斜度
 */
- (void)qbAddObliqueness:(CGFloat)obliqueness;

/**
 设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 
 @param obliqueness 倾斜度
 @param range 范围
 */
- (void)qbAddObliqueness:(CGFloat)obliqueness range:(NSRange)range;

/**
 设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 
 @param expansion 拉伸度
 */
- (void)qbAddExpansion:(CGFloat)expansion;

/**
 设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 
 @param expansion 拉伸度
 @param range 范围
 */
- (void)qbAddExpansion:(CGFloat)expansion range:(NSRange)range;

/**
 设置文字书写方向，从左向右书写或者从右向左书写
 
 @param direction direction
 */
- (void)qbAddWritingDirection:(NSInteger)direction;

/**
 设置文字书写方向，从左向右书写或者从右向左书写
 
 @param direction direction
 @param range 范围
 */
- (void)qbAddWritingDirection:(NSInteger)direction range:(NSRange)range;

/**
 设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 
 @param glyphForm glyphForm
 */
- (void)qbAddVerticalGlyphForm:(NSInteger)glyphForm;

/**
 设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 
 @param glyphForm glyphForm
 @param range 范围
 */
- (void)qbAddVerticalGlyphForm:(NSInteger)glyphForm range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
