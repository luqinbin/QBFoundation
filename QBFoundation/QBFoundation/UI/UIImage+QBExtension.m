//
//  UIImage+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIImage+QBExtension.h"
#import <CoreServices/CoreServices.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (QBExtension)

#pragma mark - GradientImage
+ (nullable UIImage *)qbGradientImageWithSize:(CGSize)size colors:(NSArray *)colors gradientDirection:(QBImageGradientDirection)gradientDirection {
    CGPoint start = CGPointZero;
    CGPoint end = CGPointZero;
    
    switch (gradientDirection) {
        case QBImageGradientDirection_LeftToRight:
            start = CGPointMake(0.0, 0.5);
            end = CGPointMake(1.0, 0.5);
            break;
        case QBImageGradientDirection_TopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(1.0, 0.0);
            break;
        case QBImageGradientDirection_LeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(1.0, 1.0);
            break;
        case QBImageGradientDirection_LeftBottomToRightTop:
            start = CGPointMake(0.0, 1.0);
            end = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    
    return [self qbGradientImageWithSize:size colors:colors startPoint:start endPoint:end];
}

+ (nullable UIImage *)qbGradientImageWithSize:(CGSize)size colors:(NSArray<UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    if (!colors) {
        return nil;
    }
    
    NSMutableArray *cgColors = [[NSMutableArray alloc] initWithCapacity:2];
    
    for (UIColor *color in colors) {
        [cgColors addObject:(id)color.CGColor];
    }
    if (cgColors.count == 0) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)cgColors, NULL);
    
    CGPoint start = CGPointMake(size.width * startPoint.x, size.height * startPoint.y);
    CGPoint end = CGPointMake(size.width * endPoint.x, size.height * endPoint.y);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)qbImageWithColor:(UIColor *)color {
    return [UIImage qbImageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)qbImageWithColor:(UIColor *)color size:(CGSize)size {
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        size = CGSizeMake(1.0f, 1.0f);
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)qbImageWithColor:(UIColor *)color size:(CGSize)size text:(NSAttributedString *)attributeString {
    UIImage *image = [UIImage qbImageWithColor:color size:size];
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGSize textSize = [attributeString size];
    CGFloat textX = (size.width - textSize.width) / 2.f;
    CGFloat textY = (size.height - textSize.height) / 2.f;
    CGRect textRect = CGRectMake(textX, textY, textSize.width, textSize.height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:rect];
    [attributeString drawInRect:textRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Shot
+ (UIImage *)qbCurrentScreenShot {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)qbCurrentViewShot:(UIView *)view {
    CGSize size = view.frame.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)qbCurrentScrollViewShot:(UIScrollView *)scrollView {
    CGSize size = scrollView.contentSize;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    
    // 获取当前scrollview的frame和 contentoffset
    CGRect saveFrame = scrollView.frame;
    CGPoint saveOffset = scrollView.contentOffset;
    // 置为起点
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    scrollView.frame = saveFrame;
    scrollView.contentOffset = saveOffset;
    return image;
}

#pragma mark - QRCode
+ (UIImage *)qbCreateQRCodeImageWithContent:(NSString *)content imageWidth:(CGFloat)imageWidth {
    // 创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 过滤器恢复默认
    [filter setDefaults];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKey:@"inputMessage"];
    // 获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(imageWidth / CGRectGetWidth(extent), imageWidth / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return outputImage;
}

#pragma mark - Compress
+ (nullable NSData *)qbHandleJPEG:(CGFloat)quality CGImage:(CGImageRef)CGImage meta:(nullable NSDictionary *)meta {
    NSMutableData *dest_data = [NSMutableData data];
    CGImageDestinationRef dest = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data, kUTTypeJPEG, 1, NULL);
    
    if (!dest) {
        return nil;
    }
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:quality], kCGImageDestinationLossyCompressionQuality, nil];
    
    CGImageDestinationSetProperties(dest, (__bridge CFDictionaryRef)properties);
    
    CGImageDestinationAddImage(dest, CGImage, (__bridge CFDictionaryRef) meta);
    
    if(!CGImageDestinationFinalize(dest)){
        CFRelease(dest);
        return nil;
    }
    
    CFRelease(dest);
    return dest_data;
}

+ (nullable NSData *)qbCompressWithImage:(nullable UIImage *)image maxLength:(NSUInteger)maxLength {
    if (!image) {
        return nil;
    }
    
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) {
        return data;
    }
    
    data = [UIImage qbHandleJPEG:(maxLength / [data length]) CGImage:image.CGImage meta:nil];
    if (data.length < maxLength) {
        return data;
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}


#pragma mark - Change
+ (nullable UIImage *)qbLaunchImage {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOr = @"Portrait";//垂直
    NSString *launchImage = nil;
    NSArray *launchImages =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in launchImages) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(viewSize, imageSize) &&
            [viewOr isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    if (!launchImage) {
        return nil;
    }
    return [UIImage imageNamed:launchImage];
}

- (UIImage *)qbChangeImageWithColor:(UIColor *)color
{
    if (!color) {
        return self;
    }
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)qbRotateImageWithAngle:(CGFloat)angle {
    UIImage *image = self;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.transform = CGAffineTransformRotate(imageView.transform, angle / 180 * M_PI);
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    imageView.center = containerView.center;
    [containerView addSubview:imageView];
    UIGraphicsBeginImageContext(containerView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [containerView.layer renderInContext:context];
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
}

+ (nullable UIImage *)qbConvertToGrayImage:(UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGImageRelease(contextRef);
    return grayImage;
}

+ (BOOL)qbHasAlphaChannel:(UIImage * _Nullable)image {
    if (!image) {
        return NO;
    }
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

+ (UIImage *)qbImageForResource:(nullable NSString *)name ofType:(nullable NSString *)ext {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]];
}

+ (UIImage *)qbImageForResource:(nullable NSString *)name {
    return [UIImage qbImageForResource:name ofType:nil];
}

- (UIImage *)qbImageCircleClip:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    CGFloat imageW = self.size.width + borderWidth * 2;
    CGFloat imageH = self.size.height + borderWidth * 2;
    imageW = MIN(imageH, imageW);
    imageH = imageW;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    //新建一个图形上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [borderColor set];
    //画大圆
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = imageW * 0.5;
    CGFloat centerY = imageH * 0.5;
    CGContextAddArc(ctx,centerX , centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    //画小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx , centerX , centerY , smallRadius ,0, M_PI * 2, 0);
    //切割
    CGContextClip(ctx);
    //画图片
    [self drawInRect:CGRectMake(borderWidth, borderWidth, self.size.width, self.size.height)];
    //从上下文中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)qbImageRoundClip:(CGFloat)cornerRadius {
    int w = self.size.width * self.scale;
    int h = self.size.height * self.scale;
    CGRect rect = CGRectMake(0, 0, w, h);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [self drawInRect:rect];
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

- (UIImage *)_flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI);
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
    
- (UIImage *)qbFlipVertical {
    return [self _flip:NO];
}
    
- (UIImage *)qbFlipHorizontal {
    return [self _flip:YES];
}

- (UIImage *)qbResizeTo:(CGSize)size {
    return [self qbResizeToWidth:size.width height:size.height];
}
    
- (UIImage *)qbResizeToWidth:(CGFloat)width height:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
    
- (UIImage *)qbScaleWithWidth:(CGFloat)width {
    if (width <= 0) {
        return self;
    }
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.width / width;
    CGFloat height = imageSize.height / scale;
    return [self qbResizeToWidth:width height:height];
}
    
- (UIImage *)qbScaleWithHeight:(CGFloat)height {
    if (height <= 0) {
        return self;
    }
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.height / height;
    CGFloat width = imageSize.width / scale;
    return [self qbResizeToWidth:width height:height];
}
    
- (UIImage *)qbCropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}
    
- (UIImage *)qbFixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;
        
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;
        
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, self.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
        break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
        
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, self.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
        break;
        default:
        CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
        break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
    
- (nullable UIColor *)qbColorAtPixel:(CGPoint)point {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
    
- (UIImage *)qbBlurredImage:(CGFloat)blurAmount {
    if (blurAmount < 0.0 || blurAmount > 1.0) {
        blurAmount = 0.5;
    }
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    }
    
    if (error) {
        free(pixelBuffer);
        CFRelease(inBitmapData);
#ifdef DEBUG
        NSLog(@"%s error: %zd", __PRETTY_FUNCTION__, error);
#endif
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)qbImageWithTitle:(NSString *)title font:(UIFont *)font color:(nonnull UIColor *)color {
    CGSize size = CGSizeMake(self.size.width,self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);//opaque:NO  scale:0.0
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;//文字居中
    
    CGSize sizeText = [title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraphStyle}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)qbSuperposeImage:(UIImage *)image {
    UIGraphicsBeginImageContext(self.size);

    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);

    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [image drawInRect:CGRectMake((self.size.width - image.size.width)/2,(self.size.height - image.size.height)/2, image.size.width, image.size.height)];

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultingImage;
}

@end
