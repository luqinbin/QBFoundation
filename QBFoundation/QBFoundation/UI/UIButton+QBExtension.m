//
//  UIButton+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIButton+QBExtension.h"
#import "QBUtilities.h"
#import "QBDefine.h"
#import "QBRuntime.h"

static char * const qbEventIntervalKey = "eventIntervalKey";
static char * const qbEventUnavailableKey = "eventUnavailableKey";

@implementation UIButton (QBExtension)

@dynamic qbEventInterval;
@dynamic qbEventUnavailable;

+ (void)load {
    QBOverrideImplementation([UIButton class], @selector(sendAction:to:forEvent:), ^id _Nonnull(__unsafe_unretained Class  _Nonnull originClass, SEL  _Nonnull originCMD, IMP  _Nonnull (^ _Nonnull originalIMPProvider)(void)) {
        return ^(UIButton *selfObject, SEL action, id target, UIEvent *event) {
            if (selfObject.qbEventUnavailable == NO) {
                selfObject.qbEventUnavailable = YES;
               
                // call super
                void (*originSelectorIMP)(id, SEL, id, UIEvent*);
                originSelectorIMP = (void (*)(id, SEL, id, UIEvent*))originalIMPProvider();
                originSelectorIMP(selfObject, action, target, event);

                typeof(selfObject) __weak weakSelf = selfObject;
                QBDispatch_async_on_main_queue_delay(^{
                    typeof(weakSelf) __strong selfObject = weakSelf;
                    selfObject.qbEventUnavailable = NO;
                }, selfObject.qbEventInterval);
            }
        };
    });
}

#pragma mark - EventInterval

- (NSTimeInterval)qbEventInterval {
    return [objc_getAssociatedObject(self, qbEventIntervalKey) doubleValue];
}

- (void)setQbEventInterval:(NSTimeInterval)qbEventInterval {
    objc_setAssociatedObject(self, qbEventIntervalKey, @(qbEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)qbEventUnavailable {
    return [objc_getAssociatedObject(self, qbEventUnavailableKey) boolValue];
}

- (void)setQbEventUnavailable:(BOOL)qbEventUnavailable {
    objc_setAssociatedObject(self, qbEventUnavailableKey, @(qbEventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - TouchArea

- (UIEdgeInsets)qbTouchAreaInsets {
    return [objc_getAssociatedObject(self, @selector(qbTouchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setQbTouchAreaInsets:(UIEdgeInsets)qbTouchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:qbTouchAreaInsets];
    objc_setAssociatedObject(self, @selector(qbTouchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setQbTouchAreaEdge:(CGFloat)edge {
    [self setQbTouchAreaInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets touchAreaInsets = self.qbTouchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

@end