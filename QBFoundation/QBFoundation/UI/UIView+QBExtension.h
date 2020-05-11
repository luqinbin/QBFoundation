//
//  UIView+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define QBResponder(action_protocol) ((id<action_protocol>)[self qbResponderTargetWithProtocol:@protocol(action_protocol)])

@interface UIView (QBExtension)

#pragma mark - Responder
/**
 获取响应链中遵守action_protocol协议的第一个响应者

 @param action_protocol 响应者协议
 @return 协议方法的响应者
 */
- (id)qbResponderTargetWithProtocol:(Protocol*_Nonnull)action_protocol;

#pragma mark - GestureRecognizer
- (void)qbAddTapGestureRecognizer:(void (^)(UITapGestureRecognizer *tapGestureRecognizer))callback;
- (void)qbAddLongPressRecognizer:(void (^)(UILongPressGestureRecognizer *longPressGestureRecognizer))callback;

#pragma mark - Frame
@property (nonatomic) CGFloat qbX;
@property (nonatomic) CGFloat qbY;
@property (nonatomic) CGFloat qbWidth;
@property (nonatomic) CGFloat qbHeight;
@property (nonatomic) CGPoint qbOrigin;
@property (nonatomic) CGSize qbSize;
@property (nonatomic) CGFloat qbCenterX;
@property (nonatomic) CGFloat qbCenterY;

#pragma mark - Subviews
// 移除所有子视图
- (void)qbRemoveAllSubviews;


#pragma mark - ViewController
/// 获取当前视图所在的控制器
- (nullable UIViewController *)qbViewController;

#pragma mark - GradientColor
/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */

@property(nullable, copy) NSArray *qbGradientColors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. Animatable. */

@property(nullable, copy) NSArray<NSNumber *> *qbGradientLocations;

/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */

@property CGPoint qbGradientStartPoint;
@property CGPoint qbGradientEndPoint;

- (void)qbSetGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

#pragma mark - CG
/// 返回透明度
@property (nonatomic, readonly) CGFloat qbVisibleAlpha;

- (CGPoint)qbConvertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;

- (CGPoint)qbConvertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;

- (CGRect)qbConvertRect:(CGRect)rect toViewOrWindow:(UIView *)view;

- (CGRect)qbConvertRect:(CGRect)rect fromViewOrWindow:(UIView *)view;

#pragma mark - ScreenShot
/**
 获取屏幕快照

 @return UIImage
 */
- (UIImage *)qbSnapshotImage;

/**
 获取屏幕快照

 @param afterUpdates afterUpdates
 @return UIImage
 */
- (UIImage *)qbSnapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 将视图作为PNG保存到指定路径

 @param filePath 指定路径
 */
- (void)qbSavePNG:(NSString *)filePath;

/**
 将视图作为JPEG保存到指定路径

 @param filePath 指定路径
 @param compressionQuality compressionQuality (0~1)
 */
- (void)qbSaveJPEG:(NSString *)filePath quality:(CGFloat)compressionQuality;

@end

NS_ASSUME_NONNULL_END
