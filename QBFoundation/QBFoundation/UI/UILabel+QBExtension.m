//
//  UILabel+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UILabel+QBExtension.h"
#import "NSObject+QBExtension.h"
#import "UIColor+QBExtension.h"
#import "QBRuntime.h"

//获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

//获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

@implementation UILabel (QBExtension)

@dynamic qbContentInsets;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QBOverrideImplementation([UILabel class], @selector(drawTextInRect:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^(UILabel *selfObject, CGRect rect) {
                UIEdgeInsets insets = selfObject.qbContentInsets;
                
                // call super
                void (*originSelectorIMP)(id, CGRect);
                originSelectorIMP = (void (*)(id, CGRect))originalIMPProvider();
                originSelectorIMP(selfObject, UIEdgeInsetsInsetRect(rect, insets));
            };
        });
        
        QBOverrideImplementation([UILabel class], @selector(sizeThatFits:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
            return ^CGSize (UILabel *selfObject, CGSize size) {
                UIEdgeInsets insets = selfObject.qbContentInsets;
                
                // call super
                CGSize (*originSelectorIMP)(id, CGSize);
                originSelectorIMP = (CGSize (*)(id, CGSize))originalIMPProvider();
                size =originSelectorIMP(selfObject, CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(insets), size.height - UIEdgeInsetsGetVerticalValue(insets)));
                
                size.width += UIEdgeInsetsGetHorizontalValue(insets);
                size.height += UIEdgeInsetsGetVerticalValue(insets);
                
                return size;
            };
        });
    });
}

- (void)setqbContentInsets:(UIEdgeInsets)qbContentInsets {
    [self qbSetAssociatedRetainObject:[NSValue valueWithUIEdgeInsets:qbContentInsets] forKey:@selector(qbContentInsets)];
}

- (UIEdgeInsets)qbContentInsets {
    return [[self qbGetAssociativeObjectWithKey:_cmd] UIEdgeInsetsValue];
}

#pragma mark - init
+ (UILabel *)qbLabelWithHexTextColor:(NSString *)hexTextColor font:(UIFont *)font {
    return [UILabel qbLabelWithTextColor:[UIColor qbColorWithHexString:hexTextColor] font:font];
}

+ (UILabel *)qbLabelWithHexTextColor:(NSString *)hexTextColor fontSize:(CGFloat)fontSize {
    return [UILabel qbLabelWithTextColor:[UIColor qbColorWithHexString:hexTextColor] fontSize:fontSize];
}

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font {
    return [UILabel qbLabelWithTextColor:textColor font:font numberOfLines:1 textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByCharWrapping];
}

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    return [UILabel qbLabelWithTextColor:textColor font:[UIFont systemFontOfSize:fontSize]];
}

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    return [UILabel qbLabelWithTextColor:textColor font:font numberOfLines:1 textAlignment:textAlignment lineBreakMode:NSLineBreakByCharWrapping];
}

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = numberOfLines;
    label.textAlignment = textAlignment;
    label.lineBreakMode = lineBreakMode;
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    return label;
}

+ (UILabel *)qbLabelWithTextColor:(UIColor *)textColor font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode borderWidth:(CGFloat)borderWidth borderColor:(UIColor * _Nullable)borderColor cornerRadius:(CGFloat)cornerRadius backgroundColor:(UIColor * _Nullable)backgroundColor {
    UILabel *label = [UILabel qbLabelWithTextColor:textColor font:font numberOfLines:numberOfLines textAlignment:textAlignment lineBreakMode:NSLineBreakByCharWrapping];
    label.layer.borderWidth = borderWidth;
    if (borderColor) {
        label.layer.borderColor = borderColor.CGColor;
    }
    label.layer.cornerRadius = cornerRadius;
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    label.clipsToBounds = YES;
    return label;
}

#pragma mark - paragraph

- (void)qbChangeLineSpace:(float)lineSpacespace paragraphSpacing:(float)paragraphSpacing {
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacespace];
    [paragraphStyle setParagraphSpacing:paragraphSpacing];
    [paragraphStyle setAlignment:self.textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

- (void)qbChangeWordSpace:(float)space {

    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];

}

@end
