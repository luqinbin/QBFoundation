//
//  UIColor+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIColor+QBExtension.h"
#import "NSString+QBExtension.h"

@implementation UIColor (QBExtension)

+ (UIColor *)qbCalcLinearGradientColorWithStartHexColor:(NSString *)startHex
                                            endHexColor:(NSString *)endHex
                                             startAlpha:(CGFloat)startAlpha
                                               endAlpha:(CGFloat)endAlpha
                                                   rate:(CGFloat)rate {
    return [self qbCalcLinearGradientColorWithStartColor:[UIColor qbColorWithHexString:startHex] endColor:[UIColor qbColorWithHexString:endHex] startAlpha:startAlpha endAlpha:endAlpha rate:rate];
}

+ (UIColor *)qbCalcLinearGradientColorWithStartColor:(UIColor *)startColor
                                            endColor:(UIColor *)endColor
                                          startAlpha:(CGFloat)startAlpha
                                            endAlpha:(CGFloat)endAlpha
                                                rate:(CGFloat)rate {
    if (!startColor || !endColor) {
        return [UIColor blackColor];
    }
    
    if (rate > 1) {
        rate = 1.0;
    }
    if (rate < 0) {
        rate = 0.0;
    }
    const CGFloat* startColors = CGColorGetComponents(startColor.CGColor);
    const CGFloat* endColors = CGColorGetComponents(endColor.CGColor);

    CGFloat startColorR = startColors[0];
    CGFloat startColorG = startColors[1];
    CGFloat startColorB = startColors[2];
    
    CGFloat endColorR = endColors[0];
    CGFloat endColorG = endColors[1];
    CGFloat endColorB = endColors[2];
    
    CGFloat currentColorR = (endColorR - startColorR) * rate + startColorR;
    CGFloat currentColorG = (endColorG - startColorG) * rate + startColorG;
    CGFloat currentColorB = (endColorB - startColorB) * rate + startColorB;
    CGFloat currentAlpha = (endAlpha - startAlpha) + startAlpha;
    
    UIColor *currrentColor = [UIColor colorWithRed:currentColorR green:currentColorG blue:currentColorB alpha:currentAlpha];
    return currrentColor;
}

+ (UIColor *)qbColorWithHexValue:(NSUInteger)hex {
    NSUInteger a = ((hex >> 24) & 0x000000FF);
    float fa = ((0 == a) ? 1.0f : (a * 1.0f) / 255.0f);
    
    return [UIColor qbColorWithHexValue:hex alpha:fa];
}
    
+ (UIColor *)qbColorWithHexValue:(NSUInteger)hex alpha:(CGFloat)alpha {
    NSUInteger r = ((hex >> 16) & 0x000000FF);
    NSUInteger g = ((hex >> 8) & 0x000000FF);
    NSUInteger b = ((hex >> 0) & 0x000000FF);
    
    float fr = (r * 1.0f) / 255.0f;
    float fg = (g * 1.0f) / 255.0f;
    float fb = (b * 1.0f) / 255.0f;
    
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}
    
+ (UIColor *)qbColorWithShortHexValue:(NSUInteger)hex alpha:(CGFloat)alpha {
    NSUInteger r = ((hex >> 8) & 0x0000000F);
    NSUInteger g = ((hex >> 4) & 0x0000000F);
    NSUInteger b = ((hex >> 0) & 0x0000000F);
    
    float fr = (r * 1.0f) / 15.0f;
    float fg = (g * 1.0f) / 15.0f;
    float fb = (b * 1.0f) / 15.0f;
    
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
}
    
+ (UIColor *)qbRandomColor {
    NSInteger redValue = arc4random() % 255;
    NSInteger greenValue = arc4random() % 255;
    NSInteger blueValue = arc4random() % 255;
    return [UIColor colorWithRed:(redValue / 255.f) green:(greenValue / 255.f) blue:(blueValue / 255.f) alpha:1.0f];
}

+ (UIColor *)qbColorWithHexString:(NSString *)hex defaultHexString:(NSString *)defaultHex alpha:(CGFloat)alpha {
    if ([NSString qbIsEmpty:hex]) {
        if ([NSString qbIsEmpty:defaultHex]) {
            return [UIColor clearColor];
        }
        return [UIColor qbColorWithHexString:defaultHex];
    }
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
        if (cString.length == 3) {
            NSUInteger hexRGB = strtol(cString.UTF8String , nil, 16);
            return [UIColor qbColorWithShortHexValue:hexRGB alpha:alpha];
        } else if (cString.length == 4) {
            // Separate into a, r, g, b substrings
            // a
            NSRange range = NSMakeRange(0, 1);
            NSString *aString = [cString substringWithRange:range];
            // r
            range.location = 1;
            NSString *rString = [cString substringWithRange:range];
            // g
            range.location = 2;
            NSString *gString = [cString substringWithRange:range];
            // b
            range.location = 3;
            NSString *bString = [cString substringWithRange:range];
            
            // Scan values
            unsigned int a, r, g, b;
            [[NSScanner scannerWithString:aString] scanHexInt:&a];
            [[NSScanner scannerWithString:rString] scanHexInt:&r];
            [[NSScanner scannerWithString:gString] scanHexInt:&g];
            [[NSScanner scannerWithString:bString] scanHexInt:&b];
            return [UIColor colorWithRed:((float)r / 255.f)
                                   green:((float)g / 255.f)
                                    blue:((float)b / 255.f)
                                   alpha:a];
        } else if (cString.length == 6) {
            NSUInteger hexRGB = strtol(cString.UTF8String , nil, 16);
            return [UIColor qbColorWithHexValue:hexRGB alpha:alpha];
        } else if (cString.length == 8) {
            // Separate into a, r, g, b substrings
            // a
            NSRange range = NSMakeRange(0, 2);
            NSString *aString = [cString substringWithRange:range];
            // r
            range.location = 2;
            NSString *rString = [cString substringWithRange:range];
            // g
            range.location = 4;
            NSString *gString = [cString substringWithRange:range];
            // b
            range.location = 6;
            NSString *bString = [cString substringWithRange:range];
            
            // Scan values
            unsigned int a, r, g, b;
            [[NSScanner scannerWithString:aString] scanHexInt:&a];
            [[NSScanner scannerWithString:rString] scanHexInt:&r];
            [[NSScanner scannerWithString:gString] scanHexInt:&g];
            [[NSScanner scannerWithString:bString] scanHexInt:&b];
            return [UIColor colorWithRed:((float)r / 255.f)
                                   green:((float)g / 255.f)
                                    blue:((float)b / 255.f)
                                   alpha:a];
        }
    } else if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
        if (cString.length == 8) {
            NSUInteger hexRGB = strtol(cString.UTF8String , nil, 16);
            return [UIColor qbColorWithHexValue:hexRGB];
        } else if (cString.length == 6) {
            NSUInteger hexRGB = strtol(cString.UTF8String , nil, 16);
            return [UIColor qbColorWithHexValue:hexRGB alpha:alpha];
        } else {
            if ([NSString qbIsEmpty:defaultHex]) {
                return [UIColor clearColor];
            }
            return [UIColor qbColorWithHexString:defaultHex];
        }
    }
    if ([NSString qbIsEmpty:defaultHex]) {
        return [UIColor clearColor];
    }
    return [UIColor qbColorWithHexString:defaultHex];
}

+ (UIColor *)qbColorWithHexString:(NSString *)hex alpha:(CGFloat)alpha {
    return [UIColor qbColorWithHexString:hex defaultHexString:@"" alpha:alpha];
}

+ (UIColor *)qbColorWithHexString:(NSString *)hex defaultHexString:(NSString *)defaultHex {
    return [UIColor qbColorWithHexString:hex defaultHexString:defaultHex alpha:1.0 ];
}

+ (UIColor *)qbColorWithHexString:(NSString *)hex {
    return [UIColor qbColorWithHexString:hex alpha:1.0];
}

@end
