//
//  NSDictionary+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (QBExtension)

/**
校验NSDictionary是否为空

@param dictionary 待校验的NSDictionary
@return BOOL
*/
+ (BOOL)qbIsEmpty:(NSDictionary * _Nullable)dictionary;

/**
 获取key的集合

 @return NSSet
 */
- (NSSet *)qbKeysSet;

/**
 获取value的集合

 @return NSSet
 */
- (NSSet *)qbValuesSet;

/**
 对所有的key进行排序 使用'caseInsensitiveCompare:'排序

 @return NSArray
 */
- (NSArray *)qbSortedAllKeys;

/**
 使用comparator对所有的key排序

 @param comparator comparator
 @return NSArray
 */
- (NSArray *)qbSortedAllKeysUsingComparator:(NSComparator)comparator;

/**
 通过对所有的key进行排序(使用'caseInsensitiveCompare:'排序) 从而对所有的value排序

 @return NSArray
 */
- (NSArray *)qbSortedAllValuesByKeys;

/**
 使用comparator对所有的key排序 从而对所有的value排序

 @param comparator comparator
 @return NSArray
 */
- (NSArray *)qbSortedAllValuesUsingKeysComparator:(NSComparator)comparator;

/**
 根据排序的key列表 遍历字典

 @param comparator comparator
 @param block block
 */
- (void)qbEnumerateSortedKeysAndObjectsUsingComparator:(NSComparator)comparator usingBlock:(void (^)(id key, id value, BOOL *stop))block;

/**
 对数据字典进行二进制属性列表序列化

 @return NSData
 */
- (NSData *)qbPlistData;

#pragma mark - JSONString
/**
 NSDictionary转换成JSON格式字符串，默认输出的json数据就是一整行

 @return NSString
 */
- (NSString *)qbJSONString;

/**
 NSDictionary转换成JSON格式字符串，同时将生成的json数据格式化输出
 NSJSONWritingPrettyPrinted

 @return NSString
 */
- (NSString *)qbJSONPrintedString;

/**
 以指定格式将NSDictionary转换成JSON格式Data，默认输出的json数据就是一整行

 @param opt NSJSONWritingOptions
 @return NSString
 */
- (NSString *)qbJSONStringWithOptions:(NSJSONWritingOptions)opt;

/**
 NSDictionary转换成JSON格式Data，默认输出的json数据就是一整行

 @return NSData
 */
- (nullable NSData *)qbJSONData;

/**
 NSDictionary转换成JSON格式Data，，同时将生成的json数据格式化输出
 NSJSONWritingPrettyPrinted

 @return NSData
 */
- (nullable NSData *)qbJSONPrintedData;

#pragma mark Merge
/**
 合并两个NSDictionary

 @param oneDict NSDictionary
 @param otherDict NSDictionary
 @return NSDictionary
 */
+ (NSDictionary *)qbDictionaryByMerging:(NSDictionary *)oneDict andOther:(NSDictionary *)otherDict;

/**
 把另外一个NSDictionary合并进来

 @param dict NSDictionary
 @return NSDictionary
 */
- (NSDictionary *)qbDictionaryByMergingOther:(NSDictionary *)dict;

#pragma mark - Manipulation
/**
 添加条目

 @param dictionary dictionary
 @return dictionary
 */
- (NSDictionary *)qbDictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

/**
 移除指定keys对应的条目

 @param keys key的集合
 @return dictionary
 */
- (NSDictionary *)qbDictionaryByRemovingEntriesWithKeys:(NSSet *)keys;

#pragma mark - SafeAccess
/**
 判断是否存在key

 @param key key
 @return BOOL
 */
- (BOOL)qbHadKey:(NSString *)key;

/**
 获取键key对应的id值

 @param key key
 @return id
 */
- (nullable id)qbObjectForKey:(NSString *)key;

/**
 获取键key对应的NSString值

 @param key key
 @return NSString
 */
- (NSString *)qbStringForKey:(NSString *)key;

/**
 获取键key对应的NSString值

 @param key key
 @param defaultValue 默认值
 @return NSString
 */
- (NSString *)qbStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

/**
 获取键key对应的NSNumber值

 @param key key
 @return NSNumber
 */
- (NSNumber *)qbNumberForKey:(NSString *)key;

/**
 获取键key对应的NSNumber值

 @param key key
 @param defaultValue 默认值
 @return NSNumber
 */
- (NSNumber *)qbNumberForKey:(NSString *)key defaultValue:(NSNumber * _Nullable)defaultValue;

/**
 获取关键路径keyPath对应的NSNumber值

 @param keyPath 关键路径
 @return NSNumber
 */
- (nullable NSNumber *)qbNumberForKeyPath:(NSString *)keyPath;

/**
 获取键key对应的NSDecimalNumber值

 @param key key
 @return NSDecimalNumber
 */
- (nullable NSDecimalNumber *)qbDecimalNumberForKey:(NSString *)key;

/**
 获取键key对应的BOOL值

 @param key key
 @return BOOL
 */
- (BOOL)qbBoolForKey:(NSString *)key;

/**
 获取键key对应的BOOL值

 @param key key
 @param defaultValue 默认值
 @return BOOL
 */
- (BOOL)qbBoolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

/**
 获取关键路径keyPath对应的BOOL值

 @param keyPath 关键路径
 @return BOOL
 */
- (BOOL)qbBoolForKeyPath:(NSString *)keyPath;

/**
 获取键key对应的NSInteger值

 @param key key
 @return NSInteger
 */
- (NSInteger)qbIntegerForKey:(NSString *)key;

/**
 获取键key对应的NSInteger值

 @param key key
 @param defaultValue 默认值
 @return NSInteger
 */
- (NSInteger)qbIntegerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;

/**
 获取键key对应的NSUInteger值

 @param key key
 @return NSUInteger
 */
- (NSUInteger)qbUnsignedIntegerForKey:(NSString *)key;

/**
 获取键key对应的NSUInteger值

 @param key key
 @param defaultValue 默认值
 @return NSUInteger
 */
- (NSUInteger)qbUnsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;

/**
 获取键key对应的char值

 @param key key
 @return char
 */
- (char)qbCharForKey:(NSString *)key;

/**
 获取键key对应的char值

 @param key key
 @param defaultValue 默认值
 @return char
 */
- (char)qbCharForKey:(NSString *)key defaultValue:(char)defaultValue;

/**
 获取键key对应的unsigned char值

 @param key key
 @return unsigned char
 */
- (unsigned char)qbUnsignedCharForKey:(NSString *)key;

/**
 获取键key对应的unsigned char值

 @param key key
 @param defaultValue 默认值
 @return unsigned char
 */
- (unsigned char)qbUnsignedCharForKey:(NSString *)key defaultValue:(unsigned char)defaultValue;

/**
 获取键key对应的short值

 @param key key
 @return short
 */
- (short)qbShortForKey:(NSString *)key;

/**
 获取键key对应的short值

 @param key key
 @param defaultValue 默认值
 @return short
 */
- (short)qbShortForKey:(NSString *)key defaultValue:(short)defaultValue;

/**
 获取键key对应的unsigned short值

 @param key key
 @return unsigned short
 */
- (unsigned short)qbUnsignedShortForKey:(NSString *)key;

/**
 获取键key对应的unsigned short值

 @param key key
 @param defaultValue 默认值
 @return unsigned short
 */
- (unsigned short)qbUnsignedShortForKey:(NSString *)key defaultValue:(unsigned short)defaultValue;

/**
 获取键key对应的long值

 @param key key
 @return long
 */
- (long)qbLongForKey:(NSString *)key;

/**
 获取键key对应的long值

 @param key key
 @param defaultValue 默认值
 @return long
 */
- (long)qbLongForKey:(NSString *)key defaultValue:(long)defaultValue;

/**
 获取键key对应的unsigned long值

 @param key key
 @return unsigned long
 */
- (unsigned long)qbUnsignedLongForKey:(NSString *)key;

/**
 获取键key对应的unsigned long值

 @param key key
 @param defaultValue 默认值
 @return unsigned long
 */
- (unsigned long)qbUnsignedLongForKey:(NSString *)key defaultValue:(unsigned long)defaultValue;

/**
 获取键key对应的long long值

 @param key key
 @return long long
 */
- (long long)qbLongLongForKey:(NSString *)key;

/**
 获取键key对应的long long值

 @param key key
 @param defaultValue 默认值
 @return long long
 */
- (long long)qbLongLongForKey:(NSString *)key defaultValue:(long long)defaultValue;

/**
 获取键key对应的unsigned long long值

 @param key key
 @return unsigned long long
 */
- (unsigned long long)qbUnsignedLongLongForKey:(NSString *)key;

/**
 获取键key对应的unsigned long long值

 @param key key
 @param defaultValue 默认值
 @return unsigned long long
 */
- (unsigned long long)qbUnsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long)defaultValue;

/**
 获取键key对应的int8_t值

 @param key key
 @return int8_t
 */
- (int8_t)qbInt8ForKey:(NSString *)key;

/**
 获取键key对应的int8_t值

 @param key key
 @param value 默认值
 @return int8_t
 */
- (int8_t)qbInt8ForKey:(NSString *)key defaultValue:(int8_t)value;

/**
 获取键key对应的uint8_t值

 @param key key
 @return uint8_t
 */
- (uint8_t)qbUint8ForKey:(NSString *)key;

/**
 获取键key对应的uint8_t值

 @param key key
 @param value 默认值
 @return uint8_t
 */
- (uint8_t)qbUint8ForKey:(NSString *)key defaultValue:(uint8_t)value;

/**
 获取键key对应的int16_t值

 @param key key
 @return int16_t
 */
- (int16_t)qbInt16ForKey:(NSString *)key;

/**
 获取键key对应的int16_t值

 @param key key
 @param value 默认值
 @return int16_t
 */
- (int16_t)qbInt16ForKey:(NSString *)key defaultValue:(int16_t)value;

/**
 获取键key对应的uint16_t值

 @param key key
 @return uint16_t
 */
- (uint16_t)qbUint16ForKey:(NSString *)key;

/**
 获取键key对应的uint16_t值

 @param key key
 @param value 默认值
 @return uint16_t
 */
- (uint16_t)qbUint16ForKey:(NSString *)key defaultValue:(uint16_t)value;

/**
 获取键key对应的int32_t值

 @param key key
 @return int32_t
 */
- (int32_t)qbInt32ForKey:(NSString *)key;

/**
 获取键key对应的int32_t值

 @param key key
 @param value 默认值
 @return int32_t
 */
- (int32_t)qbInt32ForKey:(NSString *)key defaultValue:(int32_t)value;

/**
 获取键key对应的uint32_t值

 @param key key
 @return uint32_t
 */
- (uint32_t)qbUint32ForKey:(NSString *)key;

/**
 获取键key对应的uint32_t值

 @param key key
 @param value 默认值
 @return uint32_t
 */
- (uint32_t)qbUint32ForKey:(NSString *)key defaultValue:(uint32_t)value;

/**
 获取键key对应的int64_t值

 @param key key
 @return int64_t
 */
- (int64_t)qbInt64ForKey:(NSString *)key;

/**
 获取键key对应的int64_t值

 @param key key
 @param value 默认值
 @return int64_t
 */
- (int64_t)qbInt64ForKey:(NSString *)key defaultValue:(int64_t)value;

/**
 获取键key对应的uint64_t值

 @param key key
 @return uint64_t
 */
- (uint64_t)qbUint64ForKey:(NSString *)key;

/**
 获取键key对应的uint64_t值

 @param key key
 @param value 默认值
 @return uint64_t
 */
- (uint64_t)qbUint64ForKey:(NSString *)key defaultValue:(uint64_t)value;

/**
 获取键key对应的float值

 @param key key
 @return float
 */
- (float)qbFloatForKey:(NSString *)key;

/**
 获取键key对应的float值

 @param key key
 @param defaultValue 默认值
 @return float
 */
- (float)qbFloatForKey:(NSString *)key defaultValue:(float)defaultValue;

/**
 获取键key对应的double值

 @param key key
 @return double
 */
- (double)qbDoubleForKey:(NSString *)key;

/**
 获取键key对应的double值

 @param key key
 @param defaultValue 默认值
 @return double
 */
- (double)qbDoubleForKey:(NSString *)key defaultValue:(double)defaultValue;

/**
 获取键key对应的NSTimeInterval值

 @param key key
 @return NSTimeInterval
 */
- (NSTimeInterval)qbTimeIntervalForKey:(NSString *)key;

/**
 获取键key对应的NSTimeInterval值

 @param key key
 @param value 默认值
 @return NSTimeInterval
 */
- (NSTimeInterval)qbTimeIntervalForKey:(NSString *)key defaultValue:(NSTimeInterval)value;

/**
 获取键key对应的NSDate值

 @param key key
 @param dateFormat 日期格式
 @return NSDate
 */
- (nullable NSDate *)qbDateForKey:(id)key dateFormat:(NSString *)dateFormat;

/**
 获取键key对应的CGFloat值

 @param key key
 @return CGFloat
 */
- (CGFloat)qbCGFloatForKey:(NSString *)key;

/**
 获取键key对应的CGPoint值

 @param key key
 @return CGPoint
 */
- (CGPoint)qbPointForKey:(NSString *)key;

/**
 获取键key对应的CGSize值

 @param key key
 @return CGSize
 */
- (CGSize)qbSizeForKey:(NSString *)key;

/**
 获取键key对应的CGRect值

 @param key key
 @return CGRect
 */
- (CGRect)qbRectForKey:(NSString *)key;

/**
 获取键key对应的const char值

 @param key key
 @return const char
 */
- (nullable const char *)qbCStringForKey:(NSString *)key;

/**
 获取键key对应的SEL值

 @param key key
 @return SEL
 */
- (nullable SEL)qbSelectorForKey:(NSString *)key;

#pragma mark - URL
/**
 将url参数转换成NSDictionary

 @param query url参数
 @return NSDictionary
 */
+ (NSDictionary *)qbDictionaryWithURLQuery:(NSString *)query;

/**
 将NSDictionary转换成url参数字符串

 @return NSString
 */
- (NSString *)qbURLQueryString;

#pragma mark - Block
/**
 串行遍历字典中所有元素

 @param block block
 */
- (void)qbEach:(void (^)(id key, id obj))block;

/**
 并行遍历字典中所有元素

 @param block block
 */
- (void)qbApply:(void (^)(id key, id obj))block;

/**
 返回第一个符合block条件（让block返回YES）的元素

 @param block block
 @return id
 */
- (nullable id)qbMatch:(BOOL (^)(id key, id obj))block;

/**
 筛选所有符合block条件（让block返回YES）的元素,返回重新生成的字典

 @param block block
 @return NSDictionary
 */
- (NSDictionary *)qbSelect:(BOOL (^)(id key, id obj))block;

/**
 剔除所有不符合block条件（让block返回YES）的元素,返回重新生成的字典

 @param block block
 @return NSDictionary
 */
- (NSDictionary *)qbReject:(BOOL (^)(id key, id obj))block;

/**
 返回元素的block映射字典

 @param block block
 @return NSDictionary
 */
- (NSDictionary *)qbMap:(id (^)(id key, id obj))block;

- (BOOL)qbAny:(BOOL (^)(id key, id _Nullable obj))block;

- (BOOL)qbNone:(BOOL (^)(id key, id _Nullable obj))block;

- (BOOL)qbAll:(BOOL (^)(id key, id _Nullable obj))block;

- (NSDictionary *)qbDictionaryPickForKeys:(NSArray *)keys;

- (NSDictionary *)qbDictionaryOmitForKeys:(NSArray *)keys;


@end


@interface NSMutableDictionary (QBExtension)

/**
 把id值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetObject:(id)value forKey:(NSString *)key;

/**
 把NSString值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetString:(NSString *)value forKey:(NSString *)key;

/**
 把BOOL值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetBool:(BOOL)value forKey:(NSString *)key;

/**
 把int值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetInt:(int)value forKey:(NSString *)key;

/**
 把NSInteger值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetInteger:(NSInteger)value forKey:(NSString *)key;

/**
 把NSUInteger值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUnsignedInteger:(NSUInteger)value forKey:(NSString *)key;

/**
 把char值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetChar:(char)value forKey:(NSString *)key;

/**
 把unsigned char值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUnsignedChar:(unsigned char)value forKey:(NSString *)key;

/**
 把short值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetShort:(short)value forKey:(NSString *)key;

/**
 把unsigned short值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUnsignedShort:(unsigned short)value forKey:(NSString *)key;

/**
 把long值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetLong:(long)value forKey:(NSString *)key;

/**
 把unsigned long值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUnsignedLong:(unsigned long)value forKey:(NSString *)key;

/**
 把long long值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetLongLong:(long long)value forKey:(NSString *)key;

/**
 把unsigned long long值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUnsignedLongLong:(unsigned long long)value forKey:(NSString *)key;

/**
 把int8_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetInt8:(int8_t)value forKey:(NSString *)key;

/**
 把uint8_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUInt8:(uint8_t)value forKey:(NSString *)key;

/**
 把int16_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetInt16:(int16_t)value forKey:(NSString *)key;

/**
 把uint16_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUInt16:(uint16_t)value forKey:(NSString *)key;

/**
 把int32_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetInt32:(int32_t)value forKey:(NSString *)key;

/**
 把uint32_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUInt32:(uint32_t)value forKey:(NSString *)key;

/**
 把int64_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetInt64:(int64_t)value forKey:(NSString *)key;

/**
 把uint64_t值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUInt64:(uint64_t)value forKey:(NSString *)key;

/**
 把float值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetFloat:(float)value forKey:(NSString *)key;

/**
 把double值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetDouble:(double)value forKey:(NSString *)key;

/**
 把CGFloat值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetCGFloat:(CGFloat)value forKey:(NSString *)key;

/**
 把NSTimeInterval值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetTimeInterval:(NSTimeInterval)value forKey:(NSString *)key;

/**
 把const char值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetCString:(const char *)value forKey:(NSString *)key;

/**
 把SEL值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetSelector:(SEL)value forKey:(NSString *)key;

/**
 把CGPoint值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetCGPoint:(CGPoint)value forKey:(NSString *)key;

/**
 把CGSize值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetCGSize:(CGSize)value forKey:(NSString *)key;

/**
 把CGRect值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetCGRect:(CGRect)value forKey:(NSString *)key;

/**
 把CGAffineTransform值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetCGAffineTransform:(CGAffineTransform)value forKey:(NSString *)key;

/**
 把UIEdgeInsets值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUIEdgeInsets:(UIEdgeInsets)value forKey:(NSString *)key;

/**
 把UIOffset值以key为键作存储

 @param value value
 @param key key
 */
- (void)qbSetUIOffset:(UIOffset)value forKey:(NSString *)key;

#pragma mark - Common
/**
 把key的名字重新命名为newKey

 @param key 旧key
 @param newKey 新key
 */
- (void)qbRenameKey:(NSString *)key toKey:(NSString *)newKey;

#pragma mark - Block
- (void)qbPerformSelect:(BOOL (^)(id key, id obj))block;

- (void)qbPerformReject:(BOOL (^)(id key, id obj))block;

- (void)qbPerformMap:(id (^)(id key, id obj))block;

@end

NS_ASSUME_NONNULL_END
