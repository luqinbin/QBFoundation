//
//  CALayer+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 圆角类型

 - QBCornerRadiusTypeNone: 无圆角
 - QBCornerRadiusTypeTop: 顶部圆角
 - QBCornerRadiusTypeBottom: 底部圆角
 - QBCornerRadiusTypeLeft: 左侧圆角
 - QBCornerRadiusTypeRight: 右侧圆角
 - QBCornerRadiusTypeTopLeft: 左上圆角
 - QBCornerRadiusTypeTopRight: 右上圆角
 - QBCornerRadiusTypeBottomLeft 左下圆角
 - QBCornerRadiusTypeBottomRight: 右下圆角
 - QBCornerRadiusTypeAll: 全圆角
 */
typedef NS_ENUM(NSInteger, QBCornerRadiusType) {
    QBCornerRadiusTypeNone = 0,
    QBCornerRadiusTypeTop,
    QBCornerRadiusTypeBottom,
    QBCornerRadiusTypeLeft,
    QBCornerRadiusTypeRight,
    QBCornerRadiusTypeTopLeft,
    QBCornerRadiusTypeTopRight,
    QBCornerRadiusTypeBottomLeft,
    QBCornerRadiusTypeBottomRight,
    QBCornerRadiusTypeAll
};

typedef NS_ENUM(NSInteger, QBBorderPath) {
    QBBorderPathLeft,
    QBBorderPathRight,
    QBBorderPathTop,
    QBBorderPathBottom,
    QBBorderPathCenterV,
    QBBorderPathCenterH,
};

typedef NS_ENUM(NSInteger, QBShadowPath) {
    QBShadowPathLeft,
    QBShadowPathRight,
    QBShadowPathTop,
    QBShadowPathBottom,
    QBShadowPathNoTop,
    QBShadowPathAll
};

@interface CALayer (QBExtension)

/**
 圆角图层
 */
@property (nonatomic, strong) CAShapeLayer *qbMaskLayer;

/**
 边框图层
 */
@property (nonatomic, strong) CAShapeLayer *qbBorderLayer;

/**
 添加圆角

 @param cornerRadius 圆角角度
 @param type 圆角类型
 */
- (void)qbAddCornerRadiusWithCornerRadius:(CGFloat)cornerRadius type:(QBCornerRadiusType)type;

/**
 添加边框

 @param borderColor 边框颜色
 @param lineWidth 边框宽度
 */
- (void)qbAddBorderWithColor:(UIColor *)borderColor lineWidth:(CGFloat)lineWidth;

#pragma mark - DottedLineBorder
/// 设置虚线边框
/// @param lineColor 线的颜色
/// @param lineWidth 线的宽度
/// @param lineLength 线的长度
/// @param lineSpace 线的间距 (间距设置为0，就是实线)
/// @param lineCap The cap style used when stroking the path. Options are `butt', `round' and `square'. Defaults to `butt'.
- (void)qbSetDottedlineBorderWithColor:(UIColor *)lineColor width:(CGFloat)lineWidth length:(CGFloat)lineLength space:(CGFloat)lineSpace cap:(NSString *)lineCap;

// 移除虚线边框
- (void)qbRemoveDottedlineBorder;



/// 设置虚线描边
/// @param pathSide 左、右、上、下、垂直居中、水平居中
/// @param lineWidth 线的宽度
/// @param lineLength 线的长度
/// @param lineSpace 线的间距 (间距设置为0，就是实线)
/// @param lineColor 线的颜色
/// @param lineJoin  The join style used when stroking the path. Options are `miter', `round' and `bevel'. Defaults to `miter'.
- (void)qbDrawDashLineAtPathSide:(QBBorderPath)pathSide width:(CGFloat)lineWidth length:(CGFloat)lineLength space:(CGFloat)lineSpace lineColor:(UIColor *)lineColor join:(NSString *)lineJoin;

// 移除虚线
- (void)qbRemoveDottedline;

#pragma mark - ShadowPath
-(void)qbSetShadowPathWithColor:(UIColor *)color shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(QBShadowPath)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth;

#pragma mark - Snapshot
- (UIImage *)qbSnapshotImage;
- (NSData *)qbSnapshotPDF;

- (void)qbSetLayerShadow:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;
- (void)qbRemoveAllSublayers;
- (void)qbAddFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;
- (void)qbRemovePreviousFadeAnimation;

@end

NS_ASSUME_NONNULL_END
