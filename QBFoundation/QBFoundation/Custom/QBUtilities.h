//
//  QBUtilities.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取粘贴板的内容
FOUNDATION_EXPORT NSString *_Nullable QBClipboardContent(void);

#pragma mark - keyedArchiver/keyedUnarchiver
/// 封装归档keyedArchiver操作 
FOUNDATION_EXPORT BOOL QBObjArchive(_Nonnull id objToBeArchived, NSString *key, NSString *filePath);
/// 封装反归档keyedUnarchiver操作 
FOUNDATION_EXPORT id QBObjUnArchive(NSString * _Nonnull key, NSString *filePath);

#pragma mark - AppDelegate
/// 简化 [[UIApplication sharedApplication] delegate]
FOUNDATION_EXPORT id<UIApplicationDelegate> QBApplicationDelegate(void);

#pragma mark - NSUserDefaults
/// 简化 [NSUserDefaults standardUserDefaults]
FOUNDATION_EXPORT NSUserDefaults *QBUserDefaults(void);

#pragma mark - UIImage
/**
 图片，简化UIImage.named
 
 @param name 图片名字
 @return UIImage
 */
FOUNDATION_EXPORT UIImage *_Nullable QBImage(NSString *name);

#pragma mark - UIColor
/**
 颜色，简化[UIColor wmColorWithHexString:]
 
 @param hexStr hex颜色
 @return UIColor
 */
FOUNDATION_EXPORT UIColor *_Nullable QBColorHex(NSString *hexStr);

/**
 颜色，简化[UIColor wmColorWithHexString: alpha:]
 
 @param hexStr hex颜色
 @param alpha 透明度
 @return UIColor
 */
FOUNDATION_EXPORT UIColor *_Nullable QBAlphaColorHex(NSString *hexStr, CGFloat alpha);

#pragma mark - UIFont//字体
/**
 返回System字体
 
 @param fontSize 字体大小
 @return UIFont
 */
FOUNDATION_EXPORT UIFont *_Nullable QBSystemFont(CGFloat fontSize);

/**
 返回BoldSystem字体
 
 @param fontSize 字体大小
 @return UIFont
 */
UIFont *_Nullable QBBoldSystemFont(CGFloat fontSize);

/**
 返回“Helvetica-Bold”类型字体
 
 @param fontSize 字体大小
 @return UIFont
 */
FOUNDATION_EXPORT UIFont *_Nullable QBFontForHelveticaBold(CGFloat fontSize);

/**
 返回“Helvetica”类型字体
 
 @param fontSize 字体大小
 @return UIFont
 */
FOUNDATION_EXPORT UIFont *_Nullable QBFontForHelvetica(CGFloat fontSize);

#pragma mark - GCD
CG_INLINE void QBDispatch_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        if (block) {
            block();
        }
    } else {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

CG_INLINE void QBDispatch_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        if (block) {
            block();
        }
    } else {
        if (block) {
            dispatch_sync(dispatch_get_main_queue(), block);
        }
    }
}

CG_INLINE void QBDispatch_async_on_global_queue(void (^block)(void)) {
    if (block) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    }
}

CG_INLINE void QBDispatch_async_on_main_queue_delay(void (^block)(void), int64_t seconds) {
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }
}

CG_INLINE void QBDispatch_async_on_global_queue_delay(void (^block)(void), int64_t seconds) {
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    }
}

#pragma mark - NSNotification 通知
/**
 注册通知
 
 @param observer 观察者
 @param selector 选择器
 @param name 名字
 */
FOUNDATION_EXPORT void QBRegisterNotification(id observer, SEL selector,  NSNotificationName _Nullable name);

/**
 移除某个通知
 
 @param observer 观察者
 @param name 名字
 */
FOUNDATION_EXPORT void QBRemoveNotification(id observer, NSNotificationName _Nullable name);

/**
 移除所有通知
 
 @param observer 观察者
 */
FOUNDATION_EXPORT void QBRemoveAllNotification(id observer);

/**
 发送通知
 
 @param name 名字
 */
FOUNDATION_EXPORT void QBPostNotification(NSNotificationName name);

/**
 发送通知
 
 @param name 名字
 @param anObject id类型对象
 */
FOUNDATION_EXPORT void QBPostNotificationForObject(NSNotificationName name, _Nullable id anObject);

/**
 发送通知
 
 @param name 名字
 @param userInfo 信息
 */
FOUNDATION_EXPORT void QBPostNotificationForUserInfo(NSNotificationName name, NSDictionary *_Nullable userInfo);

/**
 发送通知
 
 @param name 名字
 @param anObject id类型对象
 @param userInfo 信息
 */
FOUNDATION_EXPORT void QBPostNotificationWithObjectAndUserInfo(NSNotificationName name, _Nullable id anObject, NSDictionary *_Nullable userInfo);


#pragma mark - degrees/radians
/// 角度转弧度
/// @param degrees 角度
CG_INLINE CGFloat QBDegreesConvertToRadians (CGFloat degrees) {
    return (degrees / 180.0) * M_PI;
}

/// 弧度转角度
/// @param radians 弧度
CG_INLINE CGFloat QBRadiansConvertToDegrees (CGFloat radians) {
    return (radians / M_PI) * 180.0;
}

#pragma mark - FitLayout
/// 返回当前屏幕的宽度与iphone X 的屏幕比例
CG_INLINE CGFloat QBScale(void) {
    CGSize size = [UIScreen mainScreen].bounds.size;
    // 所有视图宽度的比较基准
    CGFloat viewDatum = 375.0f;
    return (MIN(size.width, size.height)) / viewDatum;
}

/// 返回当前屏幕的高度与iphone X 的屏幕比例
CG_INLINE CGFloat QBScaleForHeight(void) {
    CGSize size = [UIScreen mainScreen].bounds.size;
    // 所有视图高度的比较基准
    CGFloat viewDatum = 812.0f;
    return (MAX(size.width, size.height)) / viewDatum;
}

/// 默认比例。如果当前值比例大于1.0f，就是使用1.f。如果当前值比例小于1.f，就是使用当前值。
CG_INLINE CGFloat QBDefaultScale(void) {
    return fminf(QBScale(), 1.f);
}

/// 视图布局适配 QBDefaultScale() * value
/// @param value value
CG_INLINE CGFloat QBMinFitLayout(CGFloat value) {
    return value * QBDefaultScale();
}

/// 视图布局适配 QBScale() * width
/// @param width width
CG_INLINE CGFloat QBFitLayout(CGFloat width) {
    return width * QBScale();
}

/// 视图布局适配 QBScaleForHeight() * height
/// @param height height
CG_INLINE CGFloat QBFitLayoutForHeight(CGFloat height) {
    return height * QBScaleForHeight();
}

#pragma mark - CGFloat
/**
 四舍五入求值
 
 @param v v
 @return CGFloat
 */
CG_INLINE CGFloat QBCGFloatRound(CGFloat v) {
#if CGFLOAT_IS_DOUBLE
    return round(v);
#else
    return roundf(v);
#endif
}

/**
 上取整，求不小于给定实数的最小整数
 
 @param v v
 @return CGFloat
 */
CG_INLINE CGFloat QBCGFloatCeil(CGFloat v) {
#if CGFLOAT_IS_DOUBLE
    return ceil(v);
#else
    return ceilf(v);
#endif
}

/**
 下取整，求不大于给定实数的最大整数
 
 @param v v
 @return CGFloat
 */
CG_INLINE CGFloat QBCGFloatFloor(CGFloat v) {
#if CGFLOAT_IS_DOUBLE
    return floor(v);
#else
    return floorf(v);
#endif
}

#pragma mark - CGPoint
/**
 两点相加 x+x y+y
 
 @param p1 p1
 @param p2 p2
 @return CGPoint
 */
CG_INLINE CGPoint QBCGPointAdd(CGPoint p1, CGPoint p2) {
    return (CGPoint){p1.x + p2.x, p1.y + p2.y};
}

/**
 两点相减
 
 @param p1 p1
 @param p2 p2
 @return CGPoint
 */
CG_INLINE CGPoint QBCGPointSubtract(CGPoint p1, CGPoint p2) {
    return (CGPoint){p1.x - p2.x, p1.y - p2.y};
}

/**
 点x与y分别乘以factor，获取一个新的CGPoint
 
 @param p1 p1
 @param factor factor
 @return CGPoint
 */
CG_INLINE CGPoint QBCGPointMultiply(CGPoint p1, CGFloat factor) {
    return (CGPoint){p1.x * factor, p1.y * factor};
}

/**
 点x与y分别除以factor，获取一个新的CGPoint
 
 @param p1 p1
 @param factor factor
 @return CGPoint
 */
CG_INLINE CGPoint QBCGPointDivide(CGPoint p1, CGFloat factor) {
    return (CGPoint){p1.x / factor, p1.y / factor};
}

/**
 点乘
 
 @param p1 p1
 @param p2 p2
 @return CGFloat
 */
CG_INLINE CGFloat QBCGPointDotMultiply(CGPoint p1, CGPoint p2) {
    return (p1.x * p2.x) + (p1.y * p2.y);
}

/**
 点x、y分别加上size的width、height，获取一个新的CGPoint
 
 @param p p
 @param s s
 @return CGPoint
 */
CG_INLINE CGPoint QBCGPointAddSize(CGPoint p, CGSize s) {
    return CGPointMake(p.x + s.width, p.y + s.height);
}

/**
 两点的距离
 
 @param p1 p1
 @param p2 p2
 @return CGFloat
 */
CG_INLINE CGFloat QBCGPointGetDistanceToPoint(CGPoint p1, CGPoint p2) {
#if CGFLOAT_IS_DOUBLE
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
#else
    return sqrtf((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
#endif
}

/**
 point到rect的距离
 
 @param p p
 @param r r
 @return CGFloat
 */
CG_INLINE CGFloat QBCGPointGetDistanceToRect(CGPoint p, CGRect r) {
    r = CGRectStandardize(r);
    if (CGRectContainsPoint(r, p)) {
        return 0.f;
    }
    CGFloat distV, distH;
    if (CGRectGetMinY(r) <= p.y && p.y <= CGRectGetMaxY(r)) {
        distV = 0;
    } else {
        distV = p.y < CGRectGetMinY(r) ? CGRectGetMinY(r) - p.y : p.y - CGRectGetMaxY(r);
    }
    if (CGRectGetMinX(r) <= p.x && p.x <= CGRectGetMaxX(r)) {
        distH = 0;
    } else {
        distH = p.x < CGRectGetMinX(r) ? CGRectGetMinX(r) - p.x : p.x - CGRectGetMaxX(r);
    }
    return MAX(distV, distH);
}

#pragma mark - CGSize
/**
 获取size的一半
 
 @param size size
 @return CGSize
 */
CG_INLINE CGSize QBCGSizeHalf(CGSize size) {
    return CGSizeMake(size.width / 2.0, size.height / 2.0);
}

/**
 获取横纵比(宽高比)
 
 @param size size
 @return CGFloat
 */
CG_INLINE CGFloat QBCGSizeAspectRatio(CGSize size) {
    return size.width / size.height;
}

/**
 获取size宽度
 
 @param size size
 @return CGFloat
 */
CG_INLINE CGFloat QBCGSizeGetWidth(CGSize size) {
    return size.width;
}

/**
 获取size高度
 
 @param size size
 @return CGFloat
 */
CG_INLINE CGFloat QBCGSizeGetHeight(CGSize size) {
    return size.height;
}

#pragma mark - CGRect
/**
 使rect的x、y、width、height的值进行下取整，获取新的rect
 
 @param rect rect
 @return CGRect
 */
CG_INLINE CGRect QBCGRectFloor(CGRect rect) {
    return CGRectMake(QBCGFloatFloor(rect.origin.x),QBCGFloatFloor(rect.origin.y),QBCGFloatFloor(rect.size.width),QBCGFloatFloor(rect.size.height));
}

/**
 使rect的x、y、width、height的值进行上取整，获取新的rect
 
 @param rect rect
 @return CGRect
 */
CG_INLINE CGRect QBCGRectCeil(CGRect rect) {
    return CGRectMake(QBCGFloatCeil(rect.origin.x),QBCGFloatCeil(rect.origin.y),QBCGFloatCeil(rect.size.width),QBCGFloatCeil(rect.size.height));
}

/**
 使rect的x、y、width、height的值进行四舍五入，获取新的rect
 
 @param rect rect
 @return CGRect
 */
CG_INLINE CGRect QBCGRectRound(CGRect rect) {
    return CGRectMake(QBCGFloatRound(rect.origin.x),QBCGFloatRound(rect.origin.y),QBCGFloatRound(rect.size.width),QBCGFloatRound(rect.size.height));
}

/**
 根据scale缩放rect
 
 @param rect rect
 @param scale scale
 @return CGRect
 */
CG_INLINE CGRect QBCGRectScale(CGRect rect, CGFloat scale) {
    return (CGRect){rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale,rect.size.height * scale};
}

/**
 获取rect的中心点
 
 @param rect rect
 @return CGPoint
 */
CG_INLINE CGPoint QBCGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/**
 获取rect的面积
 
 @param rect rect
 @return CGFloat
 */
CG_INLINE CGFloat QBCGRectGetArea(CGRect rect) {
    if (CGRectIsNull(rect)) {
        return 0.f;
    }
    rect = CGRectStandardize(rect);
    return rect.size.width * rect.size.height;
}

/**
 使用size构造一个CGRect，origin为CGPointZero
 
 @param size size
 @return CGRect
 */
CG_INLINE CGRect QBCGRectMakeWithSize(CGSize size) {
    return (CGRect){CGPointZero, size};
}

/**
 使用origin与size构造一个CGRect
 
 @param origin origin
 @param size size
 @return CGRect
 */
CG_INLINE CGRect QBCGRectMakeWithOriginAndSize(CGPoint origin, CGSize size) {
    return (CGRect){origin, size};
}

/**
 使用center与size构造一个CGRect
 
 @param center center
 @param size size
 @return CGRect
 */
CG_INLINE CGRect QBCGRectMakeWithCenterAndSize(CGPoint center, CGSize size) {
    return (CGRect){CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5), size};
}

/**
 更改CGRect.size的值
 
 @param rect rect
 @param newSize newSize
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithSize(CGRect rect, CGSize newSize) {
    rect.size = newSize;
    return rect;
}

/**
 更改CGRect.size.width的值
 
 @param rect rect
 @param newWidth newWidth
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithWidth(CGRect rect, CGFloat newWidth) {
    rect.size.width = newWidth;
    return rect;
}

/**
 更改CGRect.size.height的值
 
 @param rect rect
 @param newHeight newHeight
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithHeight(CGRect rect, CGFloat newHeight) {
    rect.size.height = newHeight;
    return rect;
}

/**
 更改CGRect.origin的值
 
 @param rect rect
 @param newOrigin newOrigin
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOrigin(CGRect rect, CGPoint newOrigin) {
    rect.origin = newOrigin;
    return rect;
}

/**
 更改CGRect的MinX值
 
 @param rect rect
 @param value value
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOriginMinX(CGRect rect, CGFloat value) {
    rect.origin.x = value;
    return rect;
}

/**
 更改CGRect的MinY值
 
 @param rect rect
 @param value value
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOriginMinY(CGRect rect, CGFloat value) {
    rect.origin.y = value;
    return rect;
}

/**
 更改CGRect的MaxX值
 
 @param rect rect
 @param value value
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOriginMaxX(CGRect rect, CGFloat value) {
    rect.origin.x = value - rect.size.width;
    return rect;
}

/**
 更改CGRect的MaxY值
 
 @param rect rect
 @param value value
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOriginMaxY(CGRect rect, CGFloat value) {
    rect.origin.y = value - rect.size.height;
    return rect;
}

/**
 更改CGRect的MidX值
 
 @param rect rect
 @param value value
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOriginMidX(CGRect rect, CGFloat value) {
    rect.origin.x = value - (rect.size.width / 2.0);
    return rect;
}

/**
 更改CGRect的MidY值
 
 @param rect rect
 @param value value
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOriginMidY(CGRect rect, CGFloat value) {
    rect.origin.y = value - (rect.size.height / 2.0);
    return rect;
}

/**
 更改CGRect的Mid Origin值
 
 @param rect rect
 @param origin origin
 @return CGRect
 */
CG_INLINE CGRect QBCGRectWithOriginMid(CGRect rect, CGPoint origin) {
    rect.origin.x = origin.x - (rect.size.width / 2.0);
    rect.origin.y = origin.y - (rect.size.height / 2.0);
    return rect;
}

CGRect QBCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

#pragma mark - Objective-C Type
/**
 判断两个ObjCType是否相同
 
 @param firstObjCType firstObjCType
 @param secondObjCType secondObjCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeEqualObjCType(const char *firstObjCType, const char *secondObjCType);

/**
 判断ObjCType是否为char型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsChar(const char *objCType);

/**
 判断ObjCType是否为int型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsInt(const char *objCType);

/**
 判断ObjCType是否为short型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsShort(const char *objCType);

/**
 判断ObjCType是否为long型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsLong(const char *objCType);

/**
 判断ObjCType是否为long long型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsLongLong(const char *objCType);

/**
 判断ObjCType是否为有符号整型
 属于char、int、short、long、long long其中任意一种
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsSignedInteger(const char *objCType);

/**
 判断ObjCType是否为unsigned char型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsUnsignedChar(const char *objCType);

/**
 判断ObjCType是否为unsigned int型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsUnsignedInt(const char *objCType);

/**
 判断ObjCType是否为unsigned short型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsUnsignedShort(const char *objCType);

/**
 判断ObjCType是否为unsigned long型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsUnsignedLong(const char *objCType);

/**
 判断ObjCType是否为unsigned long long型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsUnsignedLongLong(const char *objCType);

/**
 判断ObjCType是否为无符号整型
 属于unsigned char、unsigned int、unsigned short、unsigned long、unsigned long long其中任意一种
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsUnsignedInteger(const char *objCType);

/**
 判断ObjCType是否为整型
 符合QBObjCTypeIsSignedInteger或QBObjCTypeIsUnsignedInteger
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsInteger(const char *objCType);

/**
 判断ObjCType是否为float型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsFloat(const char *objCType);

/**
 判断ObjCType是否为double型
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsDouble(const char *objCType);

/**
 判断ObjCType是否为浮点型
 属于float、double其中任意一种
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsFloatingPoint(const char *objCType);

/**
 判断ObjCType是否为布尔型
 属于BOOL、bool其中任意一种
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsBoolean(const char *objCType);

/**
 判断ObjCType是否为数字类型
 符合QBObjCTypeIsInteger或QBObjCTypeIsFloatingPoint
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsNumeric(const char *objCType);

/**
 判断ObjCType是否为id对象
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsId(const char *objCType);

/**
 判断ObjCType是否为对象
 属于id、@?其中任意一种
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsObject(const char *objCType);

/**
 判断ObjCType是否为char *
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsCharString(const char *objCType);

/**
 判断ObjCType是否为Class
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsClass(const char *objCType);

/**
 判断ObjCType是否为SEL
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsSelector(const char *objCType);

/**
 判断ObjCType是否为block(@?)
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsBlock(const char *objCType);

/**
 判断ObjCType是否为指针类型
 符合^
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsPointerToType(const char *objCType);

/**
 判断ObjCType是否为类似指针类型
 符合QBObjCTypeIsObject、QBObjCTypeIsCharString、QBObjCTypeIsClass、QBObjCTypeIsSelector、QBObjCTypeIsPointerToType其中任意一种
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsPointerLike(const char *objCType);

/**
 判断ObjCType是否为未知类型
 符合?
 
 @param objCType objCType
 @return BOOL
 */
FOUNDATION_EXPORT BOOL QBObjCTypeIsUnknown(const char *objCType);

/**
 获取objCType长度
 
 @param objCType objCType
 @return NSUInteger
 */
FOUNDATION_EXPORT NSUInteger QBObjCTypeLength(const char *objCType);

#pragma mark - SEL
/**
 获取selector参数的个数
 
 @param selector selector
 @return NSUInteger
 */
NSUInteger QBSelectorParameterCount(SEL selector);

#pragma mark - CAGravity <==>UIViewContentMode
FOUNDATION_EXPORT UIViewContentMode QBCAGravityToUIViewContentMode(NSString *gravity);
FOUNDATION_EXPORT NSString *QBUIViewContentModeToCAGravity(UIViewContentMode contentMode);

#pragma mark - Range
FOUNDATION_STATIC_INLINE NSRange QBNSRangeFromCFRange(CFRange range)
{
    return NSMakeRange(range.location, range.length);
}

FOUNDATION_STATIC_INLINE CFRange QBCFRangeFromNSRange(NSRange range)
{
    return CFRangeMake(range.location, range.length);
}

NS_ASSUME_NONNULL_END
