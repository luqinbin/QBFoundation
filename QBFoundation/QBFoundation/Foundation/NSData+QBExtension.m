//
//  NSData+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSData+QBExtension.h"
#import "NSDate+QBExtension.h"
#import <zlib.h>

@implementation NSData (QBExtension)

static void _fixKeyLengths( CCAlgorithm algorithm, NSMutableData * keyData, NSMutableData * ivData ) {
    NSUInteger keyLength = [keyData length];
    switch ( algorithm ) {
        case kCCAlgorithmAES128: {
            if ( keyLength < 16 ) {
                [keyData setLength: 16];
            } else if ( keyLength < 24 ) {
                [keyData setLength: 24];
            } else {
                [keyData setLength: 32];
            }
            break;
        }
            
        case kCCAlgorithmDES: {
            [keyData setLength: 8];
            break;
        }
            
        case kCCAlgorithm3DES: {
            [keyData setLength: 24];
            break;
        }
            
        case kCCAlgorithmCAST: {
            if ( keyLength < 5 ) {
                [keyData setLength: 5];
            } else if ( keyLength > 16 ) {
                [keyData setLength: 16];
            }
            
            break;
        }
            
        case kCCAlgorithmRC4: {
            if ( keyLength > 512 )
                [keyData setLength: 512];
            break;
        }
            
        default:
            break;
    }
    [ivData setLength: [keyData length]];
}

#pragma mark - APNSToken
- (NSString *)qbAPNSToken {
    if (@available(iOS 13.0, *)) {
        const unsigned *tokenBytes = (const unsigned *)[self bytes];
        NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        return hexToken;
    } else {
        return [[[[self description]
          stringByReplacingOccurrencesOfString: @"<" withString: @""]
         stringByReplacingOccurrencesOfString: @">" withString: @""]
        stringByReplacingOccurrencesOfString: @" " withString: @""];
    }
}

#pragma mark - Bsae64
+ (nullable NSData *)qbDataWithBase64EncodedString:(NSString *)string {
    NSData *decoded = nil;
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        decoded = [[self alloc] initWithBase64Encoding:[string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])]];
#pragma clang diagnostic pop
    } else
#endif
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    return [decoded length] ? decoded : nil;
}

- (NSString *)qbBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth {
    if (![self length]) {
        return @"";
    }
    NSString *encoded = @"";
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        encoded = [self base64Encoding];
#pragma clang diagnostic pop
    } else
#endif
    {
        switch (wrapWidth) {
            case 64: {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76: {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default: {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    
    if (!wrapWidth || wrapWidth >= [encoded length]) {
        return encoded;
    }
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth) {
        if (i + wrapWidth >= [encoded length]) {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    return result;
}

- (NSString *)qbBase64EncodedString {
    return [self qbBase64EncodedStringWithWrapWidth:0];
}

#pragma mark - CLLocation
- (NSData *)qbDataWithEXIFUsingLocation:(CLLocation *)location {
    NSMutableData *newJPEGData = [[NSMutableData alloc] initWithCapacity:10];
    NSMutableDictionary *exifDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    CGImageSourceRef img = CGImageSourceCreateWithData((CFDataRef)self, NULL);
    CLLocationDegrees exifLatitude = location.coordinate.latitude;
    CLLocationDegrees exifLongitude = location.coordinate.longitude;
    
    NSString *datetime = [location.timestamp qbFormattedStringUsingFormat:@"yyyy:MM:dd HH:mm:ss"];
    [exifDict setObject:datetime forKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
    [exifDict setObject:datetime forKey:(NSString *)kCGImagePropertyExifDateTimeDigitized];
    
    [locDict setObject:location.timestamp forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    
    if (exifLatitude < 0.0) {
        exifLatitude = exifLatitude * (-1);
        [locDict setObject:@"S" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    } else {
        [locDict setObject:@"N" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    }
    [locDict setObject:@(exifLatitude) forKey:(NSString*)kCGImagePropertyGPSLatitude];
    
    if (exifLongitude < 0.0) {
        exifLongitude = exifLongitude * (-1);
        [locDict setObject:@"W" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    } else {
        [locDict setObject:@"E" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    }
    [locDict setObject:@(exifLongitude) forKey:(NSString*) kCGImagePropertyGPSLatitude];
    
    NSDictionary *properties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                locDict, (NSString *)kCGImagePropertyGPSDictionary,
                                exifDict, (NSString *)kCGImagePropertyExifDictionary, nil];
    CGImageDestinationRef dest = CGImageDestinationCreateWithData((CFMutableDataRef)newJPEGData, CGImageSourceGetType(img), 1, NULL);
    CGImageDestinationAddImageFromSource(dest, img, 0, (CFDictionaryRef)properties);
    CGImageDestinationFinalize(dest);
    
    CFRelease(img);
    CFRelease(dest);
    
    return newJPEGData;
}

#pragma mark - NSStringEncoding
- (NSString *)qbConvertToUTF8String {
    return [NSData qbConvertToUTF8String:self];
}

+ (NSString *)qbConvertToUTF8String:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)qbConvertToASCIIString {
    return [NSData qbConvertToASCIIString:self];
}

+ (NSString *)qbConvertToASCIIString:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

#pragma mark - BitManipulation
- (UInt8)qbUint8AtIndex:(NSUInteger)index {
    UInt8 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (UInt16)qbUint16AtIndex:(NSUInteger)index {
    UInt16 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (UInt32)qbUint32AtIndex:(NSUInteger)index {
    UInt32 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (UInt64)qbUint64AtIndex:(NSUInteger)index {
    UInt64 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (SInt8)qbSint8AtIndex:(NSUInteger)index {
    SInt8 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (SInt16)qbSint16AtIndex:(NSUInteger)index {
    SInt16 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (SInt32)srSint32AtIndex:(NSUInteger)index {
    SInt32 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (SInt64)qbSint64AtIndex:(NSUInteger)index {
    SInt64 data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (float)qbFloatAtIndex:(NSUInteger)index {
    float data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (double)qbDoubleAtIndex:(NSUInteger)index {
    double data = 0;
    [[self subdataWithRange:NSMakeRange(index, sizeof(data))] getBytes:&data length:sizeof(data)];
    return data;
}

- (NSString *)qbStringAtIndex:(NSUInteger)index encoding:(NSStringEncoding)encoding {
    NSUInteger length = [self qbUint32AtIndex:index];
    index += sizeof(UInt32);
    
    return [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(index, length)] encoding:encoding];
}

+ (NSError *)_errorWithCCCryptorStatus: (CCCryptorStatus) status {
    NSError * result = [NSError errorWithDomain:@"" code:status userInfo:nil];
    return (result);
}

#pragma mark - CommonDigest
- (NSData *)qbMD2Sum {
    unsigned char hash[CC_MD2_DIGEST_LENGTH];
    (void) CC_MD2( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD2_DIGEST_LENGTH] );
}

- (NSData *)qbMD4Sum {
    unsigned char hash[CC_MD4_DIGEST_LENGTH];
    (void) CC_MD4( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD4_DIGEST_LENGTH] );
}

- (NSData *)qbMD5Sum {
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    (void) CC_MD5( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_MD5_DIGEST_LENGTH] );
}

- (NSString *)qbMD5String {
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (CC_LONG)self.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    
    return output;
}

- (NSData *)qbSHA1Hash {
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void) CC_SHA1( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA1_DIGEST_LENGTH] );
}

- (NSData *)qbSHA224Hash {
    unsigned char hash[CC_SHA224_DIGEST_LENGTH];
    (void) CC_SHA224( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA224_DIGEST_LENGTH] );
}

- (NSData *)qbSHA256Hash {
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}

- (NSData *)qbSHA384Hash {
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    (void) CC_SHA384( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA384_DIGEST_LENGTH] );
}

- (NSData *)qbSHA512Hash {
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void) CC_SHA512( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}

#pragma mark - CommonCryptor
- (nullable NSData *)qbAES256EncryptedDataUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self qbDataEncryptedUsingAlgorithm:kCCAlgorithmAES128
                                                      key:key
                                                  options:kCCOptionPKCS7Padding
                                                    error:&status];
    
    if ( result != nil ) {
        return ( result );
    }
    
    if ( error != NULL )
        *error = [[self class] _errorWithCCCryptorStatus:status];
    
    return ( nil );
}

- (nullable NSData *)qbDecryptedAES256DataUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self qbDecryptedDataUsingAlgorithm:kCCAlgorithmAES128
                                                      key:key
                                                  options:kCCOptionPKCS7Padding
                                                    error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [[self class] _errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (nullable NSData *)qbDESEncryptedDataUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self qbDataEncryptedUsingAlgorithm:kCCAlgorithmDES
                                                      key:key
                                                  options:kCCOptionPKCS7Padding
                                                    error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [[self class] _errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (nullable NSData *)qbDecryptedDESDataUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self qbDecryptedDataUsingAlgorithm:kCCAlgorithmDES
                                                      key:key
                                                  options:kCCOptionPKCS7Padding
                                                    error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [[self class] _errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (nullable NSData *)qbCASTEncryptedDataUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self qbDecryptedDataUsingAlgorithm:kCCAlgorithmCAST
                                                      key:key
                                                  options:kCCOptionPKCS7Padding
                                                    error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [[self class] _errorWithCCCryptorStatus: status];
    
    return ( nil );
}

- (nullable NSData *)qbDecryptedCASTDataUsingKey:(id)key error:(NSError **)error {
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self qbDecryptedDataUsingAlgorithm:kCCAlgorithmCAST
                                                      key:key
                                                  options:kCCOptionPKCS7Padding
                                                    error:&status];
    
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [[self class] _errorWithCCCryptorStatus: status];
    
    return ( nil );
}

#pragma mark - LowLevelCommonCryptor
- (NSData *) _runCryptor: (CCCryptorRef) cryptor result: (CCCryptorStatus *) status {
    size_t bufsize = CCCryptorGetOutputLength( cryptor, (size_t)[self length], true );
    void * buf = malloc( bufsize );
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate( cryptor, [self bytes], (size_t)[self length],
                              buf, bufsize, &bufused );
    if ( *status != kCCSuccess ) {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    // From Brent Royal-Gordon (Twitter: architechies):
    //  Need to update buf ptr past used bytes when calling CCCryptorFinal()
    *status = CCCryptorFinal( cryptor, buf + bufused, bufsize - bufused, &bufused );
    if ( *status != kCCSuccess ) {
        free( buf );
        return ( nil );
    }
    
    bytesTotal += bufused;
    
    return ( [NSData dataWithBytesNoCopy: buf length: bytesTotal] );
}

- (nullable NSData *)qbDataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                                             error:(CCCryptorStatus *)error {
    return ( [self qbDataEncryptedUsingAlgorithm: algorithm
                                             key: key
                            initializationVector: nil
                                         options: 0
                                           error: error] );
}

- (nullable NSData *)qbDataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error {
    return ( [self qbDataEncryptedUsingAlgorithm:algorithm
                                             key:key
                            initializationVector:nil
                                         options:options
                                           error:error] );
}

- (nullable NSData *)qbDataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key
                              initializationVector:(nullable id)iv
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData * keyData, * ivData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    if ( [iv isKindOfClass: [NSString class]] )
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    else
        ivData = (NSMutableData *) [iv mutableCopy];    // data or nil
    
    // ensure correct lengths for key and iv data, based on algorithms
    _fixKeyLengths( algorithm, keyData, ivData );
    
    status = CCCryptorCreate( kCCEncrypt, algorithm, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor );
    
    if ( status != kCCSuccess ) {
        if ( error != NULL )
            *error = status;
        return ( nil );
    }
    
    NSData * result = [self _runCryptor: cryptor result: &status];
    if ( (result == nil) && (error != NULL) )
        *error = status;
    
    CCCryptorRelease( cryptor );
    
    return ( result );
}

- (nullable NSData *)qbDecryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key        // data or string
                                             error:(CCCryptorStatus *)error {
    return ( [self qbDecryptedDataUsingAlgorithm:algorithm
                                             key:key
                            initializationVector:nil
                                         options:0
                                           error:error] );
}

- (nullable NSData *)qbDecryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key        // data or string
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error {
    return ( [self qbDecryptedDataUsingAlgorithm:algorithm
                                             key:key
                            initializationVector:nil
                                         options:options
                                           error:error] );
}

- (nullable NSData *)qbDecryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                               key:(id)key        // data or string
                              initializationVector:(nullable id)iv        // data or string
                                           options:(CCOptions)options
                                             error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData * keyData, * ivData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *) [key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    if ( [iv isKindOfClass: [NSString class]] )
        ivData = [[iv dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    else
        ivData = (NSMutableData *) [iv mutableCopy];    // data or nil
    
    // ensure correct lengths for key and iv data, based on algorithms
    _fixKeyLengths( algorithm, keyData, ivData );
    
    status = CCCryptorCreate( kCCDecrypt, algorithm, options,
                             [keyData bytes], [keyData length], [ivData bytes],
                             &cryptor );
    
    if ( status != kCCSuccess ) {
        if ( error != NULL )
            *error = status;
        return ( nil );
    }
    
    NSData * result = [self _runCryptor: cryptor result: &status];
    if ( (result == nil) && (error != NULL) )
        *error = status;
    
    CCCryptorRelease( cryptor );
    
    return ( result );
}

#pragma mark - CommonHMAC
- (NSData *)qbHMACWithAlgorithm:(CCHmacAlgorithm)algorithm {
    return ( [self qbHMACWithAlgorithm: algorithm key: nil] );
}

- (NSData *)qbHMACWithAlgorithm:(CCHmacAlgorithm)algorithm key:(nullable id) key {
    NSData * keyData = nil;
    if ( [key isKindOfClass: [NSString class]] )
        keyData = [key dataUsingEncoding: NSUTF8StringEncoding];
    else
        keyData = (NSData *) key;
    
    // this could be either CC_SHA1_DIGEST_LENGTH or CC_MD5_DIGEST_LENGTH. SHA1 is larger.
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac( algorithm, [keyData bytes], [keyData length], [self bytes], [self length], buf );
    
    return ( [NSData dataWithBytes: buf length: (algorithm == kCCHmacAlgMD5 ? CC_MD5_DIGEST_LENGTH : CC_SHA1_DIGEST_LENGTH)] );
}

#pragma mark - Gzip
- (nullable NSData *)qbGzipDeflateWithCompressionLevel:(float)level {
    if (self.length == 0 || [self qbIsGzipped]) {
        return self;
    }
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)self.length;
    stream.next_in = (Bytef *)(void *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    static const NSUInteger ChunkSize = 16384;
    
    NSMutableData *output = nil;
    int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0) {
            if (stream.total_out >= output.length) {
                output.length += ChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }
    
    return output;
}

- (nullable NSData *)qbGzipDeflate {
    return [self qbGzipDeflateWithCompressionLevel:-1.0f];
}

- (nullable NSData *)qbGzipInflate {
    if (self.length == 0 || ![self qbIsGzipped]) {
        return self;
    }
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)self.length;
    stream.next_in = (Bytef *)self.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    NSMutableData *output = nil;
    if (inflateInit2(&stream, 47) == Z_OK) {
        int status = Z_OK;
        output = [NSMutableData dataWithCapacity:self.length * 2];
        while (status == Z_OK) {
            if (stream.total_out >= output.length) {
                output.length += self.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }
        if (inflateEnd(&stream) == Z_OK) {
            if (status == Z_STREAM_END) {
                output.length = stream.total_out;
            }
        }
    }
    
    return output;
}

/** 是否是压缩的数据 */
- (BOOL)qbIsGzipped {
    const UInt8 *bytes = (const UInt8 *)self.bytes;
    return (self.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

#pragma mark - Zlib
- (nullable NSData *)qbZlibInflate {
    if ([self length] == 0) {
        return self;
    }
    
    NSUInteger full_length = [self length];
    NSUInteger half_length = [self length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength:full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)full_length;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit(&strm) != Z_OK) {
        return nil;
    }
    
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length])
            [decompressed increaseLengthBy:half_length];
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) done = YES;
        else if (status != Z_OK) break;
    }
    if (inflateEnd(&strm) != Z_OK) {
        return nil;
    }
    
    // Set real length.
    if (done) {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    } else {
        return nil;
    }
}

- (nullable NSData *)qbZlibDeflate {
    if ([self length] == 0) {
        return self;
    }
    
    z_stream strm;
    
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uInt)[self length];
    
    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION
    
    if (deflateInit(&strm, Z_DEFAULT_COMPRESSION) != Z_OK) {
        return nil;
    }
    
    // 16K chuncks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];
    
    do {
        if (strm.total_out >= [compressed length]) {
            [compressed increaseLengthBy:16384];
        }
        
        strm.next_out = [compressed mutableBytes] + strm.total_out;
        strm.avail_out = (uInt)([compressed length] - strm.total_out);
        
        deflate(&strm, Z_FINISH);
    } while (strm.avail_out == 0);
    
    deflateEnd(&strm);
    
    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}

#pragma mark - ImageContentType
+ (QBImageFormat)qbImageFormatForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    QBImageFormat imageFormat = QBImageFormatUndefined;
    if (c == (0xFF)) {
        imageFormat = QBImageFormatJPEG;
    } else if (c == (0x89)) {
        imageFormat = QBImageFormatPNG;
    } else if (c == (0x47)) {
        imageFormat = QBImageFormatGIF;
    } else if ((c == (0x49)) || (c == (0x4D))) {
        imageFormat = QBImageFormatTIFF;
    } else if (c == (0x52)) {
        // R as RIFF for WEBP
        if (data.length >= 12) {
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                imageFormat = QBImageFormatWebP;
            }
        }
    }
    return imageFormat;
}

#pragma mark - NSValue
+ (nullable NSData *)qbDataFromValue:(NSValue * _Nullable)value {
    if (!value) {
        return nil;
    }
    NSUInteger typeSize = 0;
    NSGetSizeAndAlignment(value.objCType, &typeSize, NULL);
    void *buffer = malloc(typeSize);
    [value getValue:buffer];
    NSData *data = [NSData dataWithBytes:buffer length:typeSize];
    free(buffer);
    return data;
}


@end


@implementation NSMutableData (MCExtension)

#pragma mark - BitManipulation
- (void)qbAppendUInt8:(UInt8)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendUInt16:(UInt16)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendUInt32:(UInt32)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendUInt64:(UInt64)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendSInt8:(SInt8)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendSInt16:(SInt16)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendSInt32:(SInt32)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendSInt64:(SInt64)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendFloat:(float)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendDouble:(double)data {
    [self appendBytes:&data length:sizeof(data)];
}

- (void)qbAppendString:(NSString *)data encoding:(NSStringEncoding)encoding {
    if (data != nil) {
        [self qbAppendUInt32:(UInt32)[data lengthOfBytesUsingEncoding:encoding]];
        [self appendData:[data dataUsingEncoding:encoding]];
    }
}

@end
