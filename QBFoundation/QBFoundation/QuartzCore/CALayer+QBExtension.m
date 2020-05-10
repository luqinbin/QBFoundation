//
//  CALayer+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "CALayer+QBExtension.h"
#import "NSObject+QBExtension.h"
#import "QBUtilities.h"

@implementation CALayer (QBExtension)

- (CAShapeLayer *)qbMaskLayer {
    return [self qbGetAssociativeObjectWithKey:@selector(qbMaskLayer)];
}

- (void)setQbMaskLayer:(CAShapeLayer *)qbMaskLayer {
    [self qbSetAssociatedRetainNonatomicObject:qbMaskLayer forKey:@selector(qbMaskLayer)];
}

- (CAShapeLayer *)qbBorderLayer {
    return [self qbGetAssociativeObjectWithKey:@selector(qbBorderLayer)];
}

- (void)setQbBorderLayer:(CAShapeLayer *)qbBorderLayer {
    [self qbSetAssociatedRetainNonatomicObject:qbBorderLayer forKey:@selector(qbBorderLayer)];
}

- (void)qbAddCornerRadiusWithCornerRadius:(CGFloat)cornerRadius type:(QBCornerRadiusType)type {
    CGSize cornerRadii;
    UIRectCorner rectCorner;
    switch (type) {
        case QBCornerRadiusTypeAll: {
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
            rectCorner = UIRectCornerAllCorners;
        }
            break;
            
        case QBCornerRadiusTypeTop: {
            rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
        case QBCornerRadiusTypeBottom: {
            rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
        case QBCornerRadiusTypeLeft: {
            rectCorner = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
        case QBCornerRadiusTypeRight: {
            rectCorner = UIRectCornerTopRight | UIRectCornerBottomRight;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
        case QBCornerRadiusTypeTopRight: {
            rectCorner = UIRectCornerTopRight;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
        case QBCornerRadiusTypeTopLeft: {
            rectCorner = UIRectCornerTopLeft;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
        case QBCornerRadiusTypeBottomLeft: {
            rectCorner = UIRectCornerBottomLeft;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
        case QBCornerRadiusTypeBottomRight: {
            rectCorner = UIRectCornerBottomRight;
            cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
        }
            break;
            
                
        default: {
            cornerRadii = CGSizeMake(0, 0);
            rectCorner = UIRectCornerAllCorners;
        }
            break;
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:cornerRadii];
    if (!self.qbMaskLayer) {
        self.qbMaskLayer = [[CAShapeLayer alloc] init];
        self.mask = self.qbMaskLayer;
    }
    
    if (self.qbBorderLayer && self.qbBorderLayer.path) {
        UIBezierPath *borderBezierPath = [UIBezierPath bezierPathWithCGPath:self.qbBorderLayer.path];
        [maskPath appendPath:borderBezierPath];
    }
    self.qbMaskLayer.fillColor = self.backgroundColor;
    self.qbMaskLayer.frame = self.bounds;
    self.qbMaskLayer.path = maskPath.CGPath;
}

- (void)qbAddBorderWithColor:(UIColor *)borderColor lineWidth:(CGFloat)lineWidth {
    if (!borderColor) {
        borderColor = [UIColor clearColor];
    }
    
    if (!self.qbBorderLayer) {
        self.qbBorderLayer = [[CAShapeLayer alloc] init];
        [self insertSublayer:self.qbBorderLayer atIndex:0];
    }
    
    self.qbBorderLayer.frame = self.bounds;
    self.qbBorderLayer.lineWidth = lineWidth;
    self.qbBorderLayer.strokeColor = borderColor ? borderColor.CGColor : self.backgroundColor;
    
    self.qbBorderLayer.fillColor = self.backgroundColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    if (self.qbMaskLayer && self.qbMaskLayer.path) {
        UIBezierPath *cornerRadiusBezierPath = [UIBezierPath bezierPathWithCGPath:self.qbMaskLayer.path];
        [bezierPath appendPath:cornerRadiusBezierPath];
    }
    self.qbBorderLayer.path = bezierPath.CGPath;
}

#pragma mark - DottedLine
- (void)qbSetDottedlineBorderWithColor:(UIColor *)lineColor width:(CGFloat)lineWidth length:(CGFloat)lineLength space:(CGFloat)lineSpace cap:(NSString *)lineCap {
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = lineColor.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    border.lineWidth = lineWidth;
    border.lineCap = lineCap;
    border.lineDashPattern = @[@(lineLength), @(lineSpace)];//设置线长和线间距
    [self qbSetAssociatedRetainObject:border forKey:@selector(qbSetDottedlineBorderWithColor:width:length:space:cap:)];
    [self addSublayer:border];
}

- (void)qbRemoveDottedlineBorder {
    CAShapeLayer *border = [self qbGetAssociativeObjectWithKey:@selector(qbSetDottedlineBorderWithColor:width:length:space:cap:)];
    if (border) {
        [border removeFromSuperlayer];
    }
}

- (void)qbDrawDashLineAtPathSide:(QBBorderPath)pathSide width:(CGFloat)lineWidth length:(CGFloat)lineLength space:(CGFloat)lineSpace lineColor:(UIColor *)lineColor join:(NSString *)lineJoin {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    // 设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0)];
    
    switch (pathSide) {
        case QBBorderPathLeft:
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
            break;
        case QBBorderPathBottom:
            CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(self.frame) - QBFitLayout(1));
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - QBFitLayout(1));
            break;
        case QBBorderPathRight:
            CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame)- QBFitLayout(1), 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame)- QBFitLayout(1), CGRectGetHeight(self.frame));
            break;
        case QBBorderPathTop:
            CGPathMoveToPoint(path, NULL, 0, 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
            break;
        case QBBorderPathCenterV:
            CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0, 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame));
            break;
        case QBBorderPathCenterH:
            CGPathMoveToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0, 0);
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame));
            break;
        default:
            break;
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    // 设置虚线颜色
    [shapeLayer setStrokeColor:lineColor.CGColor];
    // 设置虚线宽度
    [shapeLayer setLineWidth:lineWidth];
    [shapeLayer setLineJoin:lineJoin];
    // 设置线长和线间距
    shapeLayer.lineDashPattern = @[@(lineLength), @(lineSpace)];
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [self qbSetAssociatedRetainObject:shapeLayer forKey:@selector(qbDrawDashLineAtPathSide:width:length:space:lineColor:join:)];
    // 添加绘制好的虚线
    [self addSublayer:shapeLayer];
}

- (void)qbRemoveDottedline {
    CAShapeLayer *shapeLayer = [self qbGetAssociativeObjectWithKey:@selector(qbDrawDashLineAtPathSide:width:length:space:lineColor:join:)];
    if (shapeLayer) {
        [shapeLayer removeFromSuperlayer];
    }
}

#pragma mark - ShadowPath
-(void)qbSetShadowPathWithColor:(UIColor *)color shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(QBShadowPath)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth {
    self.masksToBounds = NO;
    self.shadowColor = color.CGColor;
    self.shadowOpacity = shadowOpacity;
    self.shadowRadius = shadowRadius;
    self.shadowOffset = CGSizeZero;
    CGRect shadowRect;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;

    switch (shadowPathSide) {
        case QBShadowPathTop:
            shadowRect = CGRectMake(x, y - shadowPathWidth / 2, w, shadowPathWidth);
            break;
        case QBShadowPathBottom:
            shadowRect = CGRectMake(x, h - shadowPathWidth / 2, w, shadowPathWidth);
            break;
        case QBShadowPathLeft:
            shadowRect = CGRectMake(x - shadowPathWidth / 2, y, shadowPathWidth, h);
            break;
        case QBShadowPathRight:
            shadowRect = CGRectMake(w - shadowPathWidth / 2, y, shadowPathWidth, h);
            break;
        case QBShadowPathNoTop:
            shadowRect = CGRectMake(x - shadowPathWidth / 2, y + 1, w + shadowPathWidth, h + shadowPathWidth / 2);
            break;
        default:
            shadowRect = CGRectMake(x - shadowPathWidth / 2, y - shadowPathWidth / 2, w + shadowPathWidth, h + shadowPathWidth);
            break;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    self.shadowPath = path.CGPath;
}

#pragma mark - Snapshot

- (UIImage *)qbSnapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSData *)qbSnapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}


- (void)qbSetLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowRadius = radius;
    self.shadowOpacity = 1;
    self.shouldRasterize = YES;
    self.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)qbRemoveAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
}

- (void)qbAddFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    if (duration <= 0)
        return;
    
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut: {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        }
            break;
        case UIViewAnimationCurveEaseIn: {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        }
            break;
        case UIViewAnimationCurveEaseOut: {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        }
            break;
        case UIViewAnimationCurveLinear: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        }
            break;
        default: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        }
            break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:@"qbfoundation.fade"];
}

- (void)qbRemovePreviousFadeAnimation {
    [self removeAnimationForKey:@"qbfoundation.fade"];
}

@end
