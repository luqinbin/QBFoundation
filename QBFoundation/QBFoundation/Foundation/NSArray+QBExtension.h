//
//  NSArray+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (QBExtension)

/**
 校验数组是否为空

 @param array 待校验的数组
 @return BOOL
 */
+ (BOOL)qbIsEmpty:(NSArray *)array;

#pragma mark - SafeAccess
/**
 安全取出数组中的元素,避免越界造成的崩溃

 @param index 索引
 @return instancetype
 */
- (nullable id)qbObjectAtIndex:(NSUInteger)index;

/**
 取出索引对应的NSString元素

 @param index 索引
 @return NSString
 */
- (NSString *)qbStringAtIndex:(NSUInteger)index;

/**
 取出索引对应的NSNumber元素

 @param index 索引
 @return NSNumber
 */
- (NSNumber *)qbNumberAtIndex:(NSUInteger)index;

/**
 取出索引对应的NSDecimalNumber元素

 @param index 索引
 @return NSDecimalNumber
 */
- (nullable NSDecimalNumber *)qbDecimalNumberAtIndex:(NSUInteger)index;

/**
 取出索引对应的NSInteger元素

 @param index 索引
 @return NSInteger
 */
- (NSInteger)qbIntegerAtIndex:(NSUInteger)index;

/**
 取出索引对应的NSUInteger元素

 @param index 索引
 @return NSUInteger
 */
- (NSUInteger)qbUnsignedIntegerAtIndex:(NSUInteger)index;

/**
 取出索引对应的BOOL元素

 @param index 索引
 @return BOOL
 */
- (BOOL)qbBoolAtIndex:(NSUInteger)index;

/**
 取出索引对应的int16_t元素

 @param index 索引
 @return int16_t
 */
- (int16_t)qbInt16AtIndex:(NSUInteger)index;

/**
 取出索引对应的int32_t元素

 @param index 索引
 @return int32_t
 */
- (int32_t)qbInt32AtIndex:(NSUInteger)index;

/**
 取出索引对应的int64_t元素

 @param index 索引
 @return int64_t
 */
- (int64_t)qbInt64AtIndex:(NSUInteger)index;

/**
 取出索引对应的char元素

 @param index 索引
 @return char
 */
- (char)qbCharAtIndex:(NSUInteger)index;

/**
 取出索引对应的short元素

 @param index 索引
 @return short
 */
- (short)qbShortAtIndex:(NSUInteger)index;

/**
 取出索引对应的float元素

 @param index 索引
 @return float
 */
- (float)qbFloatAtIndex:(NSUInteger)index;

/**
 取出索引对应的double元素

 @param index 索引
 @return double
 */
- (double)qbDoubleAtIndex:(NSUInteger)index;

/**
 取出索引对应的int元素

 @param index 索引
 @return int
 */
- (int)qbIntAtIndex:(NSUInteger)index;

/**
 取出索引对应的NSDate元素

 @param index 索引
 @param dateFormat 日期格式
 @return NSDate
 */
- (nullable NSDate *)qbDateAtIndex:(NSUInteger)index dateFormat:(NSString * _Nonnull)dateFormat;

/**
 取出索引对应的CGFloat元素

 @param index 索引
 @return CGFloat
 */
- (CGFloat)qbCGFloatAtIndex:(NSUInteger)index;

/**
 取出索引对应的CGPoint元素

 @param index 索引
 @return CGPoint
 */
- (CGPoint)qbCGPointAtIndex:(NSUInteger)index;

/**
 取出索引对应的CGSize元素

 @param index 索引
 @return CGSize
 */
- (CGSize)qbCGSizeAtIndex:(NSUInteger)index;

/**
 取出索引对应的CGRect元素

 @param index 索引
 @return CGRect
 */
- (CGRect)qbCGRectAtIndex:(NSUInteger)index;

#pragma mark - Block
/**
 串行遍历数组中所有元素

 @param block block
 */
- (void)qbEach:(void (^)(id obj))block;

/**
 并发遍历容器中所有元素(不要求顺序时使用,提高遍历速度)

 @param block block
 */
- (void)qbApply:(void (^)(id obj))block;

/**
 遍历数组元素

 @param block block
 */
- (void)qbEachWithIndex:(void (^)(id obj, NSUInteger idx))block;

/**
 返回第一个符合block条件（让block返回YES）的元素

 @param block block
 @return 匹配的元素
 */
- (nullable id)qbMatch:(BOOL (^)(id obj))block;

/**
 数组过滤器
 筛选所有符合block条件（让block返回YES）的元素,返回重新生成的数组

 @param block block
 @return NSArray
 */
- (NSArray *)qbSelect:(BOOL (^)(id object))block;

/**
 数组剔除器
 剔除所有不符合block条件（让block返回YES）的元素,返回重新生成的数组

 @param block block
 @return NSArray
 */
- (NSArray *)qbReject:(BOOL (^)(id object))block;

/**
 返回元素的block映射数组

 @param block block
 @return NSArray
 */
- (NSArray *)qbMap:(id (^)(id obj))block;

- (NSArray *)qbCompact:(id (^)(id obj))block;

- (id)qbReduce:(id)initial usingBlock:(id (^)(id sum, id obj))block;

- (NSInteger)qbReduceInteger:(NSInteger)initial usingBlock:(NSInteger (^)(NSInteger, id))block;

- (CGFloat)qbReduceFloat:(CGFloat)inital usingBlock:(CGFloat (^)(CGFloat, id))block;

- (BOOL)qbAny:(BOOL (^)(id obj))block;

- (BOOL)qbNone:(BOOL (^)(id obj))block;

- (BOOL)qbAll:(BOOL (^)(id obj))block;

- (BOOL)qbCorresponds:(NSArray *)list usingBlock:(BOOL (^)(id obj1, id obj2))block;

#pragma mark - Remove
/**
 移除对象

 @param object 指定对象
 @return NSArray
 */
- (NSArray *)qbRemoveObject:(id)object;

/**
 移除指定数组返回移除后的数据

 @param otherArray 待移除的数组
 @return NSArray
 */
- (NSArray *)qbArrayByRemovingObjectsFromArray:(NSArray *)otherArray;

/**
 移除第一个对象

 @return NSArray
 */
- (NSArray *)qbRemoveFirstObject;

/**
 移除最后一个对象

 @return  NSArray
 */
- (NSArray *)qbRemoveLastObject;

#pragma mark - Move
/**
 移动对象 从一个位置到另一个位置

 @param index 原位置
 @param toIndex 目标位置
 @return NSArray
 */
- (NSArray *)qbMoveObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

#pragma mark - Object
- (nullable id)qbObjectBefore:(id)anObject;

- (nullable id)qbObjectBefore:(id)anObject wrap:(BOOL)aWrap;

- (nullable id)qbObjectAfter:(id)anObject;

- (nullable id)qbObjectAfter:(id)anObject wrap:(BOOL)aWrap;

- (NSArray *)qbObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;

/**
 获取一个随机对象

 @return id
 */
- (nullable id)qbRandomObject;

/**
 分割成两个数组 index可能会导致一个空数组
 eg： [A, B, C, D, E, F, G] split at 0 returns [[], [A, B, C, D, E, F, G]]
 [A, B, C, D, E, F, G] split at 7 returns [[A, B, C, D, E, F, G], []]
 [A, B, C, D, E, F, G] split at 3 returns [[A, B, C], [D, E, F, G]]

 @param index 索引
 @return NSArray
 */
- (NSArray *)qbSplitAtIndex:(NSInteger)index;


/// 以特定长度分割数组
/// @param subSize 分割子数组元素个数
/// @return 返回二维数组
- (NSArray *)splitwithSubSize:(int)subSize;

/**
 删除数组的重复对象并返回新的数组 使用`isEqual:`剔除

 @return NSArray
 */
- (NSArray *)qbUniquedArray;

/**
 返回一个按照相反顺序组成的新数组 倒序

 @return NSArray
 */
- (NSArray *)qbReversedArray;

/**
 移除所有NSNull对象，并返回新数组

 @return NSArray
 */
- (NSArray *)qbCompactedArray;

#pragma mark - Compare
/**
 返回一个按照生序排列的新数组 使用`compare:`进行比较
 
 @param array 需要排序的数组
 @return NSArray
 */
+ (NSArray *)qbUsingCompareSortedArray:(NSArray * _Nullable)array;

/// 排序
/// @param key key
/// @param ascending ascending
- (NSArray *)qbUsingDescriptorSortedWithkey:(NSString *)key ascending:(BOOL)ascending;

#pragma mark - Set
- (NSSet *)qbSet;
- (NSMutableSet *)qbMutableSet;
- (NSOrderedSet *)qbOrderedSet;
- (NSMutableOrderedSet *)qbMutableOrderedSet;

#pragma mark - Subarray
/**
 获取从指定索引开始到结束的数据形成新的数组

 @param index 索引
 @return NSArray
 */
- (NSArray *)qbSubarrayFromIndex:(NSUInteger)index;

/**
 获取从开始到指定索引的数据形成的新数组

 @param index 索引
 @return NSArray
 */
- (NSArray *)qbSubarrayToIndex:(NSUInteger)index;

#pragma mark - Alpha Numeric Titles
/**
 返回A-Z 、# 和 the Search icon组成的数组

 @param search 是否包含搜索icon
 @return NSArray
 */
+ (NSArray *)qbArrayWithAlphaNumericTitlesWithSearch:(BOOL)search;

/**
 返回A-Z 和 # 组成的数组

 @return NSArray
 */
+ (NSArray *)qbArrayWithAlphaNumericTitles;

#pragma mark - JSONString
/**
 NSArray转换成JSON格式字符串，默认将生成的json数据以一整行输出

 @return NSString
 */
- (NSString *)qbJSONString;

/**
 NSArray转换成JSON格式字符串，同时将生成的json数据格式化输出
 NSJSONWritingPrettyPrinted

 @return NSString
 */
- (NSString *)qbJSONPrintedString;
/**
 NSArray转换成JSON格式字符串，默认输出的json数据就是一整行

 @param opt NSJSONWritingOptions
 @return NSString
 */
- (NSString *)qbJSONStringWithOptions:(NSJSONWritingOptions)opt;

/**
 NSArray转换成JSON格式字符串，默认输出的json数据就是一整行

 @param anArray anArray
 @return NSString
 */
+ (NSString *)qbJSONString:(NSArray *)anArray;

/**
 NSArray转换成JSON格式字符串，同时将生成的json数据格式化输出
 NSJSONWritingPrettyPrinted

 @param anArray anArray
 @return NSString
 */
+ (NSString *)qbJSONPrintedString:(NSArray *)anArray;

/**
 NSArray转换成JSON格式Data，默认输出的json数据就是一整行

 @return NSData
 */
- (NSData *)qbJSONData;

/**
 NSArray转换成JSON格式Data，同时将生成的json数据格式化输出
 NSJSONWritingPrettyPrinted

 @return NSData
 */
- (NSData *)qbJSONPrintedData;

@end

@interface NSMutableArray (QBExtension)

/**
 追加对象

 @param firstObject 对象
 */
- (void)qbAppendObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

/**
 数据反转 倒序
 */
- (void)qbReverse;

/**
 随机排序
 */
- (void)qbShuffle;

#pragma mark - Insert
/**
 在索引位置插入数据

 @param objects 数据对象
 @param index 索引
 */
- (void)qbInsertObjects:(NSArray *)objects atIndex:(NSUInteger)index;

#pragma mark - Remove
/**
 移除第一个对象
 */
- (void)qbRemoveFirstObject;

/**
 移除最后一个对象
 */
- (void)qbRemoveLastObject;

#pragma mark - Pop
/**
 推出第一个对象

 @return id
 */
- (nullable id)qbPopFirstObject;

/**
 推出最后一个对象

 @return id
 */
- (nullable id)qbPopLastObject;

#pragma mark - Move
/**
 移动对象 从一个位置到另一个位置

 @param index 原位置
 @param toIndex 目标位置
 */
- (void)qbMoveObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex;

/**
 将指定索引处的对象移动到新位置

 @param indexes 索引对象
 @param idx 新的位置
 */
- (void)qbMoveObjectsAtIndexes:(NSIndexSet *)indexes toIndex:(NSUInteger)idx;

#pragma mark - NSSet
/**
 把NSSet转换为NSMutableArray

 @param set NSSet对象
 @return NSMutableArray
 */
+ (NSMutableArray *)qbArrayWithSet:(NSSet *)set;

#pragma mark - SafeAccess
/**
 添加id值

 @param obj id对象
 */
- (void)qbAddObject:(id)obj;

/**
 添加BOOL值

 @param value BOOL值
 */
- (void)qbAddBOOL:(BOOL)value;

/**
 添加int值

 @param value int值
 */
- (void)qbAddInt:(int)value;

/**
 添加NSInteger值

 @param value NSInteger值
 */
- (void)qbAddInteger:(NSInteger)value;

/**
 添加NSUInteger值

 @param value NSUInteger值
 */
- (void)qbAddUnsignedInteger:(NSUInteger)value;

/**
 添加CGFloat值

 @param value CGFloat值
 */
- (void)qbAddCGFloat:(CGFloat)value;

/**
 添加char值

 @param value char值
 */
- (void)qbAddChar:(char)value;

/**
 添加float值

 @param value float值
 */
- (void)qbAddFloat:(float)value;

/**
 添加CGPoint结构体

 @param value CGPoint结构体
 */
- (void)qbAddPoint:(CGPoint)value;

/**
 添加CGSize结构体

 @param value CGSize结构体
 */
- (void)qbAddSize:(CGSize)value;

/**
 添加CGRect结构体

 @param value CGRect结构体
 */
- (void)qbAddRect:(CGRect)value;

/**
 在指定索引位置插入一个BOOL值

 @param value BOOL值
 @param index 索引
 */
- (void)qbInsertBOOL:(BOOL)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个int值

 @param value int值
 @param index 索引
 */
- (void)qbInsertInt:(int)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个NSInteger值

 @param value NSInteger值
 @param index 索引
 */
- (void)qbInsertInteger:(NSInteger)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个NSUInteger值

 @param value NSUInteger值
 @param index 索引
 */
- (void)qbInsertUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个CGFloat值

 @param value CGFloat值
 @param index 索引
 */
- (void)qbInsertCGFloat:(CGFloat)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个char值

 @param value char值
 @param index 索引
 */
- (void)qbInsertChar:(char)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个float值

 @param value float值
 @param index 索引
 */
- (void)qbInsertFloat:(float)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个CGPoint结构体

 @param value CGPoint结构体
 @param index 索引
 */
- (void)qbInsertPoint:(CGPoint)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个CGSize结构体

 @param value CGSize结构体
 @param index 索引
 */
- (void)qbInsertSize:(CGSize)value atIndex:(NSUInteger)index;

/**
 在指定索引位置插入一个CGRect结构体

 @param value CGRect结构体
 @param index 索引
 */
- (void)qbInsertRect:(CGRect)value atIndex:(NSUInteger)index;

#pragma mark - Block
/**
 删除数组中不符合block条件的元素，即只保留符合block条件的元素

 @param block block
 */
- (void)qbPerformSelect:(BOOL (^)(id obj))block;

/**
 删除数组中符合block条件的元素

 @param block block
 */
- (void)qbPerformReject:(BOOL (^)(id obj))block;

/**
 数组中的元素变换为自己的block映射元素

 @param block block
 */
- (void)qbPerformMap:(id (^)(id obj))block;

@end

NS_ASSUME_NONNULL_END
