//
//  UIView+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIView+QBExtension.h"
#import "NSObject+QBExtension.h"
#import <objc/runtime.h>

@implementation UILabel (QBGradient)
+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end

@implementation UIView (QBExtension)

#pragma mark - Responder
- (id)qbResponderTargetWithProtocol:(Protocol*_Nonnull)action_protocol {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if (class_conformsToProtocol([nextResponder class], action_protocol)) {
            return nextResponder;
        }
    }
    return nil;
}

#pragma mark - GestureRecognizer
- (void)qbAddTapGestureRecognizer:(void (^)(UITapGestureRecognizer *tapGestureRecognizer))callback {
    if (!self.userInteractionEnabled) {
        self.userInteractionEnabled = !self.userInteractionEnabled;
    }
    UITapGestureRecognizer *curGesture = [self qbGetAssociativeObjectWithKey:_cmd];
    if (!curGesture) {
        curGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_qb_handleTapGes:)];
        [self addGestureRecognizer:curGesture];
        [self qbSetAssociatedRetainObject:curGesture forKey:_cmd];
    }
    [self qbSetAssociatedCopyObject:callback forKey:@selector(_qb_handleTapGes:)];
}

- (void)_qb_handleTapGes:(UITapGestureRecognizer *)tapGestureRecognizer {
    void (^gesBlock)(UITapGestureRecognizer *cTapGes) = [self qbGetAssociativeObjectWithKey:_cmd];
    if (gesBlock) {
        gesBlock(tapGestureRecognizer);
    }
}

- (void)qbAddLongPressRecognizer:(void (^)(UILongPressGestureRecognizer *longPressGestureRecognizer))callback {
    if (!self.userInteractionEnabled) {
        self.userInteractionEnabled = !self.userInteractionEnabled;
    }
    UILongPressGestureRecognizer *curGesture = [self qbGetAssociativeObjectWithKey:_cmd];
    if (!curGesture) {
        curGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_qb_handleLongPressGes:)];
        [self addGestureRecognizer:curGesture];
        [self qbSetAssociatedRetainObject:curGesture forKey:_cmd];
    }
    [self qbSetAssociatedCopyObject:callback forKey:@selector(_qb_handleLongPressGes:)];
}

- (void)_qb_handleLongPressGes:(UILongPressGestureRecognizer *)longPressGes {
    void (^gesBlock)(UILongPressGestureRecognizer *cLongPressGes) = [self qbGetAssociativeObjectWithKey:_cmd];
    if (gesBlock) {
        gesBlock(longPressGes);
    }
}

#pragma mark - Frame
- (CGFloat)qbX {
    return self.frame.origin.x;
}

- (void)setQbX:(CGFloat)qbX {
    CGRect currentRect = self.frame;
    if (currentRect.origin.x != qbX) {
        currentRect.origin.x = qbX;
        self.frame = currentRect;
    }
}

- (CGFloat)qbY {
    return self.frame.origin.y;
}

- (void)setQbY:(CGFloat)qbY {
    CGRect currentRect = self.frame;
    if (currentRect.origin.y != qbY) {
        currentRect.origin.y = qbY;
        self.frame = currentRect;
    }
}

- (CGFloat)qbWidth {
    return self.frame.size.width;
}

- (void)setQbWidth:(CGFloat)qbWidth {
    CGRect currentRect = self.frame;
    if (currentRect.size.width != qbWidth) {
        currentRect.size.width = qbWidth;
        self.frame = currentRect;
    }
}

- (CGFloat)qbHeight {
    return self.frame.size.height;
}

- (void)setQbHeight:(CGFloat)qbHeight {
    CGRect currentRect = self.frame;
    if (currentRect.size.height != qbHeight) {
        currentRect.size.height = qbHeight;
        self.frame = currentRect;
    }
}

- (CGPoint)qbOrigin {
    return self.frame.origin;
}

- (void)setQbOrigin:(CGPoint)qbOrigin {
    CGRect currentRect = self.frame;
    if (!CGPointEqualToPoint(currentRect.origin, qbOrigin)) {
        currentRect.origin = qbOrigin;
        self.frame = currentRect;
    }
}

- (CGSize)qbSize {
    return self.frame.size;
}

- (void)setQbSize:(CGSize)qbSize {
    CGRect currentRect = self.frame;
    if (!CGSizeEqualToSize(currentRect.size, qbSize)) {
        currentRect.size = qbSize;
        self.frame = currentRect;
    }
}

- (CGFloat)qbCenterX {
    return CGRectGetMidX(self.frame);
}

- (void)setQbCenterX:(CGFloat)qbCenterX {
    CGPoint currentPoint = self.center;
    if (currentPoint.x != qbCenterX) {
        currentPoint.x = qbCenterX;
        self.center = currentPoint;
    }
}

- (CGFloat)qbCenterY {
    return CGRectGetMidY(self.frame);
}

- (void)setQbCenterY:(CGFloat)qbCenterY {
    CGPoint currentPoint = self.center;
    if (currentPoint.y != qbCenterY) {
        currentPoint.y = qbCenterY;
        self.center = currentPoint;
    }
}


#pragma mark - Subviews
- (void)qbRemoveAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - ViewController
- (nullable UIViewController *)qbViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - GradientColor
+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)qbSetGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    NSMutableArray *colorsM = [NSMutableArray arrayWithCapacity:2];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.qbGradientColors = [colorsM copy];
    self.qbGradientLocations = locations;
    self.qbGradientStartPoint = startPoint;
    self.qbGradientEndPoint = endPoint;
}

#pragma mark Getter&Setter
- (NSArray *)qbGradientColors {
    return [self qbGetAssociativeObjectWithKey:_cmd];
}

- (void)setQbGradientColors:(NSArray *)qbGradientColors {
    [self qbSetAssociatedCopyObject:qbGradientColors forKey:@selector(qbGradientColors)];
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.qbGradientColors];
    }
}

- (NSArray<NSNumber *> *)qbGradientLocations {
    return [self qbGetAssociativeObjectWithKey:_cmd];
}

- (void)setQbGradientLocations:(NSArray<NSNumber *> *)qbGradientLocations {
    [self qbSetAssociatedCopyObject:qbGradientLocations forKey:@selector(qbGradientLocations)];
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.qbGradientLocations];
    }
}

- (CGPoint)qbGradientStartPoint {
    return [[self qbGetAssociativeObjectWithKey:_cmd] CGPointValue];
}

- (void)setQbGradientStartPoint:(CGPoint)qbGradientStartPoint {
    [self qbSetAssociatedRetainObject:[NSValue valueWithCGPoint:qbGradientStartPoint] forKey:@selector(qbGradientStartPoint)];
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.qbGradientStartPoint];
    }
}

- (CGPoint)qbGradientEndPoint {
    return [[self qbGetAssociativeObjectWithKey:_cmd] CGPointValue];
}

- (void)setQbGradientEndPoint:(CGPoint)qbGradientEndPoint {
    [self qbSetAssociatedRetainObject:[NSValue valueWithCGPoint:qbGradientEndPoint] forKey:@selector(qbGradientEndPoint)];
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.qbGradientEndPoint];
    }
}

#pragma mark - CG
- (CGFloat)qbVisibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) {
            return 0;
        }
        return self.alpha;
    }
    if (!self.window) {
        return 0;
    }
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}

- (CGPoint)qbConvertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) {
        return [self convertPoint:point toView:view];
    }
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)qbConvertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) {
        return [self convertPoint:point fromView:view];
    }
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)qbConvertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) {
        return [self convertRect:rect toView:view];
    }
    if (from == to) {
        return [self convertRect:rect toView:view];
    }
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)qbConvertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) {
        return [self convertRect:rect fromView:view];
    }
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}


#pragma mark - ScreenShot
- (UIImage *)qbSnapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)qbSnapshotImageAfterScreenUpdates:(BOOL)afterUpdates
{
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self qbSnapshotImage];
    }
    if ([self.layer respondsToSelector:@selector(setShouldRasterize:)]) {
        UIGraphicsBeginImageContextWithOptions( self.bounds.size, self.opaque, self.contentScaleFactor);
    } else {
        UIGraphicsBeginImageContext( self.bounds.size );
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (void)qbSavePNG:(NSString *)filePath {
    [UIImagePNGRepresentation(self.qbSnapshotImage) writeToFile:filePath atomically:NO];
}

- (void)qbSaveJPEG:(NSString *)filePath quality:(CGFloat)compressionQuality {
    [UIImageJPEGRepresentation(self.qbSnapshotImage, compressionQuality) writeToFile:filePath atomically:NO];
}




@end
