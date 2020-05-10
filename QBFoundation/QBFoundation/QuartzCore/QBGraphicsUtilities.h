//
//  QBGraphicsUtilities.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 添加圆角
/// @param context 上下文
/// @param rect 矩形
/// @param ovalWidth 椭圆形的宽度
/// @param ovalHeight 椭圆形的高度
CG_INLINE void QBAddRoundedRectToPath(CGContextRef context, CGRect rect, CGFloat ovalWidth, CGFloat ovalHeight) {
    CGContextBeginPath(context);
    
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
    
    CGContextClosePath(context);
}

/// 绘制渐变色
/// @param context 上下文
/// @param path 路径
/// @param colors 颜色数组
CG_INLINE void QBDrawGradientColor(CGContextRef context, CGPathRef path, NSArray<UIColor *> *colors) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colors.count < 1) {
        colors = @[[UIColor blackColor]];
    }
    
    NSInteger totalCount = colors.count;
    CGFloat loactions[totalCount];
    NSMutableArray *newcolors = [NSMutableArray array];
    
    for (NSInteger i = 0; i < colors.count; i++) {
        loactions[i] = 1.0/totalCount*(i+1);
        UIColor *color = [colors objectAtIndex:i];
        [newcolors addObject:(__bridge id)color.CGColor];
    }
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) newcolors, loactions);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


NS_ASSUME_NONNULL_END
