//
//  NSData+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UIImage格式
 
 - QBImageFormatUndefined: 未定义格式
 - QBImageFormatJPEG: JPEG格式
 - QBImageFormatPNG: PNG格式
 - QBImageFormatGIF: GIF格式
 - QBImageFormatTIFF: TIFF格式
 - QBImageFormatWebP: WebP格式
 */
typedef NS_ENUM(NSInteger, QBImageFormat) {
    QBImageFormatUndefined = -1,
    QBImageFormatJPEG = 0,
    QBImageFormatPNG,
    QBImageFormatGIF,
    QBImageFormatTIFF,
    QBImageFormatWebP
};

@interface NSData (QBExtension)

#pragma mark - APNSToken
/**
 将APNS NSData类型token格式化成字符串

 @return NSString
 */
- (NSString *)qbAPNSToken;

#pragma mark - Bsae64
/**
 字符串base64后转data

 @param string 传入字符串
 @return NSData
 */
+ (nullable NSData *)qbDataWithBase64EncodedString:(NSString *)string;

/**
 NSData to NSString

 @param wrapWidth 换行长度  76、64
 @return NSString
 */
- (NSString *)qbBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

/**
 NSData to NSString 换行长度默认为64

 @return NSString
 */
- (NSString *)qbBase64EncodedString;

#pragma mark - CLLocation
/**
 为图片的NSData添加位置信息

 @param location 位置
 @return NSData
 */
- (NSData *)qbDataWithEXIFUsingLocation:(CLLocation *)location;

#pragma mark - NSStringEncoding
/**
 NSData to NSString NSUTF8StringEncoding

 @return NSString
 */
- (NSString *)qbConvertToUTF8String;

/**
 NSData to NSString NSUTF8StringEncoding

 @param data data
 @return NSString
 */
+ (NSString *)qbConvertToUTF8String:(NSData *)data;

/**
 NSData to NSString NSASCIIStringEncoding

 @return NSString
 */
- (NSString *)qbConvertToASCIIString;

/**
 NSData to NSString NSASCIIStringEncoding

 @param data data
 @return NSString
 */
+ (NSString *)qbConvertToASCIIString:(NSData *)data;

#pragma mark - BitManipulation
/**
 指定位置取出UInt8数据

 @param index 位置
 @return UInt8
 */
- (UInt8)qbUint8AtIndex:(NSUInteger)index;

/**
 指定位置取出UInt16数据

 @param index 位置
 @return UInt16
 */
- (UInt16)qbUint16AtIndex:(NSUInteger)index;

/**
 指定位置取出UInt32数据

 @param index 位置
 @return UInt32
 */
- (UInt32)qbUint32AtIndex:(NSUInteger)index;

/**
 指定位置取出UInt64数据

 @param index 位置
 @return UInt64
 */
- (UInt64)qbUint64AtIndex:(NSUInteger)index;

/**
 指定位置取出SInt8数据

 @param index 位置
 @return SInt8
 */
- (SInt8)qbSint8AtIndex:(NSUInteger)index;

/**
 指定位置取出SInt16数据

 @param index 位置
 @return SInt16
 */
- (SInt16)qbSint16AtIndex:(NSUInteger)index;

/**
 指定位置取出SInt32数据

 @param index 位置
 @return SInt32
 */
- (SInt32)srSint32AtIndex:(NSUInteger)index;

/**
 指定位置取出SInt64数据

 @param index 位置
 @return SInt64
 */
- (SInt64)qbSint64AtIndex:(NSUInteger)index;

/**
 指定位置取出float数据

 @param index 位置
 @return float
 */
- (float)qbFloatAtIndex:(NSUInteger)index;

/**
 指定位置取出double数据

 @param index 位置
 @return double
 */
- (double)qbDoubleAtIndex:(NSUInteger)index;

/**
 指定位置取出NSString数据

 @param index 位置
 @param encoding 编码格式
 @return NSString
 */
- (NSString *)qbStringAtIndex:(NSUInteger)index encoding:(NSStringEncoding)encoding;

#pragma mark - CommonDigest
- (NSData *)qbMD2Sum;

- (NSData *)qbMD4Sum;

- (NSData *)qbMD5Sum;

- (NSString *)qbMD5String;

- (NSData *)qbSHA1Hash;

- (NSData *)qbSHA224Hash;

- (NSData *)qbSHA256Hash;

- (NSData *)qbSHA384Hash;

- (NSData *)qbSHA512Hash;

#pragma mark - CommonCryptor
- (nullable NSData *)qbAES256EncryptedDataUsingKey:(id)key error:(NSError **)error;

- (nullable NSData *)qbDecryptedAES256DataUsingKey:(id)key error:(NSError **)error;

- (nullable NSData *)qbDESEncryptedDataUsingKey:(id)key error:(NSError **)error;

- (nullable NSData *)qbDecryptedDESDataUsingKey:(id)key error:(NSError **)error;

- (nullable NSData *)qbCASTEncryptedDataUsingKey:(id)key error:(NSError **)error;

- (nullable NSData *)qbDecryptedCASTDataUsingKey:(id)key error:(NSError **)error;

#pragma mark - LowLevelCommonCryptor
- (nullable NSData *)qbDataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                                             error:(CCCryptorStatus *)error;

- (nullable NSData *)qbDataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error;

- (nullable NSData *)qbDataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                              initializationVector:(nullable id)iv
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error;

- (nullable NSData *)qbDecryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                                             error:(CCCryptorStatus *)error;

- (nullable NSData *)qbDecryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error;

- (nullable NSData *)qbDecryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                              initializationVector:(nullable id)iv
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error;

#pragma mark - CommonHMAC
- (NSData *)qbHMACWithAlgorithm:(CCHmacAlgorithm)algorithm;

- (NSData *)qbHMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(nullable id)key;

#pragma mark - Gzip
/**
 GZIP压缩数据

 @param level 压缩级别
 @return NSData
 */
- (nullable NSData *)qbGzipDeflateWithCompressionLevel:(float)level;

/**
 GZIP压缩数据，默认压缩级别为-1

 @return NSData
 */
- (nullable NSData *)qbGzipDeflate;

/**
 解压数据

 @return NSData
 */
- (nullable NSData *)qbGzipInflate;

/**
 是否是压缩的数据

 @return BOOL
 */
- (BOOL)qbIsGzipped;

#pragma mark - Zlib
/**
 解压数据

 @return NSData
 */
- (nullable NSData *)qbZlibInflate;

/**
 压缩数据

 @return NSData
 */
- (nullable NSData *)qbZlibDeflate;

#pragma mark - ImageContentType
/**
 获取NSData中图片的格式

 @param data data
 @return qbImageFormat
 */
+ (QBImageFormat)qbImageFormatForImageData:(NSData *)data;

#pragma mark - NSValue
/**
 NSValue转换为NSData

 @param value NSValue对象
 @return NSData
 */
+ (nullable NSData *)qbDataFromValue:(NSValue * _Nullable)value;


@end

@interface NSMutableData (QBExtension)

- (void)qbAppendUInt8:(UInt8)data;

- (void)qbAppendUInt16:(UInt16)data;

- (void)qbAppendUInt32:(UInt32)data;

- (void)qbAppendUInt64:(UInt64)data;

- (void)qbAppendSInt8:(SInt8)data;

- (void)qbAppendSInt16:(SInt16)data;

- (void)qbAppendSInt32:(SInt32)data;

- (void)qbAppendSInt64:(SInt64)data;

- (void)qbAppendFloat:(float)data;

- (void)qbAppendDouble:(double)data;

- (void)qbAppendString:(NSString *)data encoding:(NSStringEncoding)encoding;

@end

NS_ASSUME_NONNULL_END
