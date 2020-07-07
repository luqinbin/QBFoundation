//
//  UIImage+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QBImageGradientDirection) {
    QBImageGradientDirection_LeftToRight,
    QBImageGradientDirection_TopToBottom,
    QBImageGradientDirection_LeftTopToRightBottom,
    QBImageGradientDirection_LeftBottomToRightTop,
};

@interface UIImage (QBExtension)

#pragma mark - GradientImage
/// 获取矩形的渐变色的UIImage
/// @param size 大小
/// @param colors 渐变色数组，可以设置两种颜色
/// @param gradientDirection 渐变的方式
+ (nullable UIImage *)qbGradientImageWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors gradientDirection:(QBImageGradientDirection)gradientDirection;


/// 获取矩形的渐变色的UIImage
/// @param size 大小
/// @param colors 渐变色数组，可以设置两种颜色
/// @param startPoint [0.0, 0.0] ~[1.0, 1.0]    [0,0] is the bottom-left corner of the layer, [1,1] is the top-right corner.
/// @param endPoint  [0.0, 0.0] ~[1.0, 1.0]
+ (nullable UIImage *)qbGradientImageWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 根据颜色生成纯色图片

 @param color 颜色
 @return UIImage
 */
+ (UIImage *)qbImageWithColor:(UIColor *)color;

/**
 创建指定大小、颜色的图片

 @param color 颜色
 @param size 大小
 @return UIImage
 */
+ (UIImage *)qbImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 创建纯色背景、文字居中的图片

 @param color 颜色
 @param size 大小
 @param attributeString 富文本
 @return UIImage
 */
+ (UIImage *)qbImageWithColor:(UIColor *)color size:(CGSize)size text:(NSAttributedString *)attributeString;

#pragma mark - Shot

/**
 获取屏幕截图

 @return UIImage
 */
+ (UIImage *)qbCurrentScreenShot;

/**
 获取某个视图的截图

 @param view 视图
 @return UIImage
 */
+ (UIImage *)qbCurrentViewShot:(UIView *)view;

/**
 获取某个滑动视图的截图

 @param scrollView 滑动视图
 @return UIImage
 */
+ (UIImage *)qbCurrentScrollViewShot:(UIScrollView *)scrollView;

#pragma mark - QRCode
/**
 生成二维码

 @param content 内容
 @param imageWidth 宽度
 @return UIImage
 */
+ (UIImage *)qbCreateQRCodeImageWithContent:(NSString *)content imageWidth:(CGFloat)imageWidth;

#pragma mark - Compress
+ (nullable NSData *)qbHandleJPEG:(CGFloat)quality CGImage:(CGImageRef)CGImage meta:(nullable NSDictionary *)meta;
+ (nullable NSData *)qbCompressWithImage:(nullable UIImage *)image maxLength:(NSUInteger)maxLength;

#pragma mark - Change
/**
 获取启动图

 @return UIImage
 */
+ (nullable UIImage *)qbLaunchImage;

/**
 根据颜色改变图片

 @param color 颜色
 @return UIImage
 */
- (UIImage *)qbChangeImageWithColor:(UIColor *)color;

/**
 图片旋转

 @param angle 角度
 @return UIImage
 */
- (UIImage *)qbRotateImageWithAngle:(CGFloat)angle;


/**
 转换为灰度图片

 @param image 图片
 @return UIImage
 */
+ (nullable UIImage *)qbConvertToGrayImage:(UIImage * _Nullable)image;

/**
 是否包含Alpha通道

 @param image 图片
 @return BOOL
 */
+ (BOOL)qbHasAlphaChannel:(UIImage * _Nullable)image;

+ (UIImage *)qbImageForResource:(nullable NSString *)name ofType:(nullable NSString *)ext;

+ (UIImage *)qbImageForResource:(nullable NSString *)name;

/**
 垂直翻转

 @return UIImage
 */
- (UIImage *)qbFlipVertical;

/**
 水平翻转

 @return UIImage
 */
- (UIImage *)qbFlipHorizontal;
    
/**
 改变图片的大小

 @param size size
 @return UIImage
 */
- (UIImage *)qbResizeTo:(CGSize)size;

/**
 改变图片的宽与高

 @param width 宽度
 @param height 高度
 @return UIImage
 */
- (UIImage *)qbResizeToWidth:(CGFloat)width height:(CGFloat)height;

/**
 等比例缩放至指定宽度

 @param width 指定宽度
 @return UIImage
 */
- (UIImage *)qbScaleWithWidth:(CGFloat)width;
    
/**
 等比例缩放至指定高度

 @param height 指定高度
 @return UIImage
 */
- (UIImage *)qbScaleWithHeight:(CGFloat)height;

/**
 剪切图片

 @param x x
 @param y y
 @param width 宽度
 @param height 高度
 @return UIImage
 */
- (UIImage *)qbCropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

/// 裁剪，返回圆形图像
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
- (UIImage *)qbImageCircleClip:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


/// 圆角裁剪
/// @param cornerRadius 圆角直径
- (UIImage *)qbImageRoundClip:(CGFloat)cornerRadius;


/**
 修正拍照图片的方向

 @return UIImage
 */
- (UIImage *)qbFixOrientation;

/**
 获取图片上某个像素点的颜色

 @param point 点
 @return UIColor
 */
- (nullable UIColor *)qbColorAtPixel:(CGPoint)point;
    
/**
 模糊图片

 @param blurAmount 模糊系数，范围是0.0~1.0
 @return UIImage
 */
- (UIImage *)qbBlurredImage:(CGFloat)blurAmount;

/**
 图片上添加文字

 @param title 文字
 @param font 字体
 @param color 颜色
 @return UIImage
 */
- (UIImage *)qbImageWithTitle:(NSString *)title font:(UIFont *)font color:(nonnull UIColor *)color;

/// 叠加图片
/// @param image UIImage
- (UIImage *)qbSuperposeImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
