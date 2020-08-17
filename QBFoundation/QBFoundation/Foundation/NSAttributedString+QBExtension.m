//
//  NSAttributedString+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSAttributedString+QBExtension.h"
#import "NSString+QBExtension.h"
#import "NSArray+QBExtension.h"

@implementation NSAttributedString (QBExtension)

+ (nullable NSAttributedString *)qbStringWithString:(NSString * _Nullable)string {
    if ([NSString qbIsEmpty:string]) {
        return nil;
    }
    return [[NSAttributedString alloc] initWithString:string];
}

+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markString:(NSString *)markString markFont:(UIFont *)markFont {
    return [NSAttributedString qbAttributedStringWithString:string markString:markString markFont:markFont markFontColor:nil];
}

+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markString:(NSString *)markString markFontColor:(UIColor *)markFontColor {
    return [NSAttributedString qbAttributedStringWithString:string markString:markString markFont:nil markFontColor:markFontColor];
}

+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markString:(NSString *)markString markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor {
    if ([NSString qbIsEmpty:string]) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    if ([NSString qbIsEmpty:markString]) {
        return [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
        
    NSArray<NSValue *> *ranges = [NSString qbRangesOfSubstring:[markString lowercaseString] inString:[string lowercaseString]];
    [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.rangeValue;
        if (range.location != NSNotFound) {
            if (markFont) {
                [attributedString qbAddFont:markFont range:range];
            }
            if (markFontColor) {
                [attributedString qbAddFontColor:markFontColor range:range];
            }
        }
    }];
    
    return attributedString;
}

+ (NSAttributedString *)qbHightLightAttributedString:(NSAttributedString *)string markString:(NSString *)markString markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor {
    if ([NSString qbIsEmpty:string.string] || [NSString qbIsEmpty:markString]) {
        return string;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
        
    NSArray<NSValue *> *ranges = [NSString qbRangesOfSubstring:markString inString:string.string];
    [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.rangeValue;
        if (range.location != NSNotFound) {
            if (markFont) {
                [attributedString qbAddFont:markFont range:range];
            }
            if (markFontColor) {
                [attributedString qbAddFontColor:markFontColor range:range];
            }
        }
    }];
    
    return attributedString;
}

+ (NSAttributedString *)qbAttributedStringWithString:(NSString *)string markStringArray:(NSArray<NSString *> *)markStringArray markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor {
    if ([NSString qbIsEmpty:string]) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    if ([NSArray qbIsEmpty:markStringArray]) {
        return [[NSMutableAttributedString alloc] initWithString:string];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    for (NSString *markString in markStringArray) {
        NSArray<NSValue *> *ranges = [NSString qbRangesOfSubstring:markString inString:string];
        [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = obj.rangeValue;
            if (range.location != NSNotFound) {
                if (markFont) {
                    [attributedString qbAddFont:markFont range:range];
                }
                if (markFontColor) {
                    [attributedString qbAddFontColor:markFontColor range:range];
                }
            }
        }];
    }
    
    return attributedString;
}

+ (NSAttributedString *)qbHightLightAttributedString:(NSAttributedString *)string markStringArray:(NSArray<NSString *> *)markStringArray markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor {
    if ([NSString qbIsEmpty:string.string] || [NSArray qbIsEmpty:markStringArray]) {
        return string;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    
    for (NSString *markString in markStringArray) {
        NSArray<NSValue *> *ranges = [NSString qbRangesOfSubstring:markString inString:string.string];
        [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = obj.rangeValue;
            if (range.location != NSNotFound) {
                if (markFont) {
                    [attributedString qbAddFont:markFont range:range];
                }
                if (markFontColor) {
                    [attributedString qbAddFontColor:markFontColor range:range];
                }
            }
        }];
    }
    
    return attributedString;
}

+ (NSAttributedString *)qbHightLightAttributedString:(NSAttributedString *)string markWordArray:(NSArray<NSString *> *)markWordArray markFont:(UIFont * _Nullable)markFont markFontColor:(UIColor * _Nullable)markFontColor {
    if ([NSString qbIsEmpty:string.string] || [NSArray qbIsEmpty:markWordArray]) {
        return string;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:string];
    
    for (NSString *markWord in markWordArray) {
        NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
        [string.string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            if ([substring isEqualToString:markWord]) {
                [ranges addObject:[NSValue valueWithRange:substringRange]];
            }
        }];
        
        [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = obj.rangeValue;
            if (range.location != NSNotFound) {
                if (markFont) {
                    [attributedString qbAddFont:markFont range:range];
                }
                if (markFontColor) {
                    [attributedString qbAddFontColor:markFontColor range:range];
                }
            }
        }];
    }
    
    return attributedString;
}

#pragma mark - init
- (instancetype)initWithString:(NSString *)string fontColor:(UIColor *)fontColor {
    return [self initWithString:string attributes:@{NSForegroundColorAttributeName: fontColor}];
}

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)fontColor {
    return [self initWithString:string attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: fontColor}];
}

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)fontColor shadow:(NSShadow *)shadow {
    return [self initWithString:string attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: fontColor, NSShadowAttributeName: shadow}];
}

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font lineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.lineSpacing = lineSpacing;
    CGFloat newLineSpacing = lineSpacing - (font.lineHeight - font.pointSize);
    if (newLineSpacing < 0) {
        newLineSpacing = 0;
    }
    [paragraphStyle setLineSpacing:newLineSpacing];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (lineHeight - font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    return [self initWithString:string attributes:attributes];
}

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font fontColor:(UIColor *)fontColor lineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = lineHeight;
    paragraphStyle.minimumLineHeight = lineHeight;
    paragraphStyle.lineSpacing = lineSpacing;
    CGFloat newLineSpacing = lineSpacing - (font.lineHeight - font.pointSize);
    if (newLineSpacing < 0) {
        newLineSpacing = 0;
    }
    [paragraphStyle setLineSpacing:newLineSpacing];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (lineHeight - font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    [attributes setObject:fontColor forKey:NSForegroundColorAttributeName];
    return [self initWithString:string attributes:attributes];
}

- (instancetype)initWithString:(NSString *)string font:(UIFont *)font lineHeight:(CGFloat)lineHeight {
    return [self initWithString:string font:font lineHeight:lineHeight lineSpacing:0];
}

@end

@implementation NSMutableAttributedString (QBExtension)

- (void)qbAddFont:(UIFont *)font {
    [self qbAddFont:font range:NSMakeRange(0, self.length)];
}

- (void)qbAddFont:(UIFont *)font range:(NSRange)range {
    [self addAttributes:@{NSFontAttributeName: font} range:range];
}

- (void)qbAddFontColor:(UIColor *)color {
    [self qbAddFontColor:color range:NSMakeRange(0, self.length)];
}

- (void)qbAddFontColor:(UIColor *)color range:(NSRange)range {
    [self addAttributes:@{NSForegroundColorAttributeName: color} range:range];
}

- (void)qbAddFont:(UIFont *)font fontColor:(UIColor *)fontColor {
    [self qbAddFont:font fontColor:fontColor range:NSMakeRange(0, self.length)];
}

- (void)qbAddFont:(UIFont *)font fontColor:(UIColor *)fontColor range:(NSRange)range {
    [self addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: fontColor} range:range];
}

- (void)qbAddParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self qbAddParagraphStyle:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)qbAddParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    [self addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:range];
}

- (void)qbAddBackgroundColor:(UIColor *)color {
    [self qbAddBackgroundColor:color range:NSMakeRange(0, self.length)];
}

- (void)qbAddBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self addAttributes:@{NSBackgroundColorAttributeName: color} range:range];
}

- (void)qbAddLigature:(NSInteger)ligature {
    [self qbAddLigature:ligature range:NSMakeRange(0, self.length)];
}

- (void)qbAddLigature:(NSInteger)ligature range:(NSRange)range {
    [self addAttributes:@{NSLigatureAttributeName: @(ligature)} range:range];
}

- (void)qbAddKern:(CGFloat)kern {
    [self qbAddKern:kern range:NSMakeRange(0, self.length)];
}

- (void)qbAddKern:(CGFloat)kern range:(NSRange)range {
    [self addAttributes:@{NSKernAttributeName: @(kern)} range:range];
}

- (void)qbAddStrikethroughStyle:(NSInteger)strikethroughStyle {
    [self qbAddStrikethroughStyle:strikethroughStyle range:NSMakeRange(0, self.length)];
}

- (void)qbAddStrikethroughStyle:(NSInteger)strikethroughStyle range:(NSRange)range {
    [self addAttributes:@{NSStrikethroughStyleAttributeName: @(strikethroughStyle)} range:range];
}

- (void)qbAddUnderlineStyle:(NSUnderlineStyle)style {
    [self qbAddUnderlineStyle:style range:NSMakeRange(0, self.length)];
}

- (void)qbAddUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range {
    [self addAttributes:@{NSUnderlineStyleAttributeName: @(style)} range:range];
}

- (void)qbAddStrokeColor:(UIColor *)color {
    [self qbAddStrokeColor:color range:NSMakeRange(0, self.length)];
}

- (void)qbAddStrokeColor:(UIColor *)color range:(NSRange)range {
    [self addAttributes:@{NSStrokeColorAttributeName: color} range:range];
}

- (void)qbAddStrokeWidth:(CGFloat)width {
    [self qbAddStrokeWidth:width range:NSMakeRange(0, self.length)];
}

- (void)qbAddStrokeWidth:(CGFloat)width range:(NSRange)range {
    [self addAttributes:@{NSStrokeWidthAttributeName: @(width)} range:range];
}

- (void)qbAddShadow:(NSShadow *)shadow {
    [self qbAddShadow:shadow range:NSMakeRange(0, self.length)];
}

- (void)qbAddShadow:(NSShadow *)shadow range:(NSRange)range {
    [self addAttributes:@{NSShadowAttributeName: shadow} range:range];
}

- (void)qbAddTextEffect:(NSString *)textEffect {
    [self qbAddTextEffect:textEffect range:NSMakeRange(0, self.length)];
}

- (void)qbAddTextEffect:(NSString *)textEffect range:(NSRange)range {
    [self addAttributes:@{NSTextEffectAttributeName: textEffect} range:range];
}

- (void)qbInsertAttachment:(NSTextAttachment *)textAttachment atIndex:(NSInteger)index  NS_AVAILABLE_IOS(7_0) {
    [self insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment] atIndex:index];
}

- (void)qbInsertImageAttachment:(UIImage *)image bounds:(CGRect)imageBounds atIndex:(NSInteger)index {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = imageBounds;
    [self qbInsertAttachment:attachment atIndex:index];
}

- (void)qbAddLink:(NSURL *)linkURL {
    [self qbAddLink:linkURL range:NSMakeRange(0, self.length)];
}

- (void)qbAddLink:(NSURL *)linkURL range:(NSRange)range {
    [self addAttributes:@{NSLinkAttributeName: linkURL} range:range];
}

- (void)qbAddBaselineOffset:(CGFloat)offset {
    [self qbAddBaselineOffset:offset range:NSMakeRange(0, self.length)];
}

- (void)qbAddBaselineOffset:(CGFloat)offset range:(NSRange)range {
    [self addAttributes:@{NSBaselineOffsetAttributeName: @(offset)} range:range];
}

- (void)qbAddUnderlineColor:(UIColor *)color {
    [self qbAddUnderlineColor:color range:NSMakeRange(0, self.length)];
}

- (void)qbAddUnderlineColor:(UIColor *)color range:(NSRange)range {
    [self addAttributes:@{NSUnderlineColorAttributeName: color} range:range];
}

- (void)qbAddStrikethroughColor:(UIColor *)color {
    [self qbAddStrikethroughColor:color range:NSMakeRange(0, self.length)];
}

- (void)qbAddStrikethroughColor:(UIColor *)color range:(NSRange)range {
    [self addAttributes:@{NSStrikethroughColorAttributeName: color} range:range];
}

- (void)qbAddObliqueness:(CGFloat)obliqueness {
    [self qbAddObliqueness:obliqueness range:NSMakeRange(0, self.length)];
}

- (void)qbAddObliqueness:(CGFloat)obliqueness range:(NSRange)range {
    [self addAttributes:@{NSObliquenessAttributeName: @(obliqueness)} range:range];
}

- (void)qbAddExpansion:(CGFloat)expansion {
    [self qbAddExpansion:expansion range:NSMakeRange(0, self.length)];
}

- (void)qbAddExpansion:(CGFloat)expansion range:(NSRange)range {
    [self addAttributes:@{NSExpansionAttributeName: @(expansion)} range:range];
}

- (void)qbAddWritingDirection:(NSInteger)direction {
    [self qbAddWritingDirection:direction range:NSMakeRange(0, self.length)];
}

- (void)qbAddWritingDirection:(NSInteger)direction range:(NSRange)range {
    [self addAttributes:@{NSWritingDirectionAttributeName: @(direction)} range:range];
}

- (void)qbAddVerticalGlyphForm:(NSInteger)glyphForm {
    [self qbAddVerticalGlyphForm:glyphForm range:NSMakeRange(0, self.length)];
}

- (void)qbAddVerticalGlyphForm:(NSInteger)glyphForm range:(NSRange)range {
    [self addAttributes:@{NSVerticalGlyphFormAttributeName: @(glyphForm)} range:range];
}


@end
