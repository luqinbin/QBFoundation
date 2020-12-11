//
//  NSArray+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSArray+QBExtension.h"
#import "NSObject+QBExtension.h"
#import "NSNumber+QBExtension.h"
#import "NSDictionary+QBExtension.h"

@implementation NSArray (QBExtension)

+ (BOOL)qbIsEmpty:(NSArray *)array {
    if (![NSObject qbIsKindOfArray:array]) {
        return YES;
    }
    if (array.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - SafeAccess
- (nullable id)qbObjectAtIndex:(NSUInteger)index {
    if (self.count > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSString *)qbStringAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    if (!value) {
        return @"";
    }
    
    if ([value isKindOfClass:[NSObject class]]) {
        if ([value isKindOfClass:[NSNull class]]) {
            return @"";
        } else if ([value isKindOfClass:[NSString class]]) {
            return (NSString *)value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else if ([value isKindOfClass:[NSData class]]) {
            return [[NSString alloc] initWithData:((NSData *)value) encoding:NSUTF8StringEncoding];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            return [((NSDictionary *)value) qbJSONString];
        } else if ([value isKindOfClass:[NSArray class]]) {
            return [((NSArray *)value) qbJSONString];
        } else {
            return [NSString stringWithFormat:@"%@",value];
        }
    } else {
        return [NSString stringWithFormat:@"%@",value];
    }
}

- (NSNumber *)qbNumberAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *)value];
    }
    return @(0);
}

- (NSDecimalNumber *)qbDecimalNumberAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber *)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString *)value;
        return [str isEqualToString:@""] ? [[NSDecimalNumber alloc] initWithString:@"0"] : [NSDecimalNumber decimalNumberWithString:str];
    }
    return [[NSDecimalNumber alloc] initWithString:@"0"];
}

- (NSInteger)qbIntegerAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]]
        || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (NSUInteger)qbUnsignedIntegerAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] ||
        [value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    return 0;
}

- (BOOL)qbBoolAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    if (!value || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}

- (int16_t)qbInt16AtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (int32_t)qbInt32AtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (int64_t)qbInt64AtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (char)qbCharAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value charValue];
    }
    return 0;
}

- (short)qbShortAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (float)qbFloatAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return 0;
}

- (double)qbDoubleAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (int)qbIntAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value intValue];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (nullable NSDate *)qbDateAtIndex:(NSUInteger)index dateFormat:(NSString * _Nonnull)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self qbObjectAtIndex:index];
    
    if (!value || value == [NSNull null]) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

- (CGFloat)qbCGFloatAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    return [value doubleValue];
}

- (CGPoint)qbCGPointAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    CGPoint point = CGPointFromString(value);
    return point;
}

- (CGSize)qbCGSizeAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    CGSize size = CGSizeFromString(value);
    return size;
}

- (CGRect)qbCGRectAtIndex:(NSUInteger)index {
    id value = [self qbObjectAtIndex:index];
    CGRect rect = CGRectFromString(value);
    return rect;
}

#pragma mark - Block
- (void)qbEach:(void (^)(id obj))block {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (void)qbApply:(void (^)(id obj))block {
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj);
    }];
}

- (void)qbEachWithIndex:(void (^)(id obj, NSUInteger idx))block {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx);
    }];
}

- (nullable id)qbMatch:(BOOL (^)(id obj))block {
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return block(obj);
    }];
    if (index == NSNotFound) {
        return nil;
    }
    return self[index];
}

- (NSArray *)qbSelect:(BOOL (^)(id object))block {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return block(evaluatedObject);
    }]];
}

- (NSArray *)qbReject:(BOOL (^)(id object))block {
    return [self qbSelect:^BOOL(id  _Nonnull obj) {
        return !block(obj);
    }];
}

- (NSArray *)qbMap:(id (^)(id obj))block {
    __block NSMutableArray *result = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block(obj)? : [NSNull null];
        [result addObject:value];
    }];
    return result;
}

- (NSArray *)qbCompact:(id (^)(id obj))block {
    __block NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block(obj);
        if (value) {
            [result addObject:value];
        }
    }];
    return result;
}

- (id)qbReduce:(id)initial usingBlock:(id (^)(id sum, id obj))block {
    __block id result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (NSInteger)qbReduceInteger:(NSInteger)initial usingBlock:(NSInteger (^)(NSInteger, id))block {
    __block NSInteger result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (CGFloat)qbReduceFloat:(CGFloat)inital usingBlock:(CGFloat (^)(CGFloat, id))block {
    __block CGFloat result = inital;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

- (BOOL)qbAny:(BOOL (^)(id obj))block {
    return [self qbMatch:block] != nil;
}

- (BOOL)qbNone:(BOOL (^)(id obj))block {
    return [self qbMatch:block] == nil;
}

- (BOOL)qbAll:(BOOL (^)(id obj))block {
    __block BOOL result = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj)) {
            result = NO;
            *stop = YES;
        }
    }];
    
    return result;
}

- (BOOL)qbCorresponds:(NSArray *)list usingBlock:(BOOL (^)(id obj1, id obj2))block {
    __block BOOL result = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < list.count) {
            id obj2 = list[idx];
            result = block(obj, obj2);
        } else {
            result = NO;
        }
        *stop = !result;
    }];
    
    return result;
}

#pragma mark - Remove
- (NSArray *)qbRemoveObject:(id)object {
    if (self.count == 0) return self;
    
    NSMutableArray *result = [self mutableCopy];
    [result removeObject:object];
    return result;
}

- (NSArray *)qbArrayByRemovingObjectsFromArray:(NSArray *)otherArray {
    return [self qbObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        return ![otherArray containsObject:obj];
    }];
}

- (NSArray *)qbRemoveFirstObject {
    if (self.count == 0) return self;
    
    return [self subarrayWithRange:NSMakeRange(1, self.count - 1)];
}

- (NSArray *)qbRemoveLastObject {
    if (self.count == 0) return self;
    
    return [self subarrayWithRange:NSMakeRange(0, self.count - 1)];
}

#pragma mark - Move
- (NSArray *)qbMoveObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    if (toIndex >= self.count - 1 || index >= self.count - 1) {
        return self;
    }
    
    id originObj = self[index];
    NSMutableArray *mutableArray = [self mutableCopy];
    [mutableArray removeObjectAtIndex:index];
    [mutableArray insertObject:originObj atIndex:toIndex];
    return [NSArray arrayWithArray:mutableArray];
}

#pragma mark - Object
- (nullable id)qbObjectBefore:(id)anObject {
    return [self qbObjectBefore:anObject wrap:NO];
}

- (nullable id)qbObjectBefore:(id)anObject wrap:(BOOL)aWrap {
    //获取当前对象的位置
    NSUInteger index = [self indexOfObject:anObject];
    
    //如果当前对象是第一个返回nil
    if (index == NSNotFound ||                  // Not found?
        (!aWrap && index == 0))                  // Or no wrap and was first object?
        return nil;
    
    index = (index - 1 + self.count) % self.count;
    return self[index];
}

- (nullable id)qbObjectAfter:(id)anObject {
    return [self qbObjectAfter:anObject wrap:NO];
}

- (nullable id)qbObjectAfter:(id)anObject wrap:(BOOL)aWrap {
    NSUInteger index = [self indexOfObject:anObject];
    
    if (index == NSNotFound ||                  // Not found?
        (!aWrap && index == self.count - 1))     // Or no wrap and was last object?
        return nil;
    
    index = (index + 1) % self.count;
    return self[index];
}

- (NSArray *)qbObjectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:predicate];
    return [self objectsAtIndexes:indexes];
}

- (nullable id)qbRandomObject {
    if (self.count) {
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

- (NSArray *)qbSplitAtIndex:(NSInteger)index {
    if (index < 0) {
        return @[[NSArray array], [NSArray arrayWithArray:self]];
    }
    
    if (index > self.count) {
        return @[[NSArray arrayWithArray:self], [NSArray array]];
    }
    
    NSArray *first = [self subarrayWithRange:NSMakeRange(0, index)];
    NSArray *second = [self subarrayWithRange:NSMakeRange(index, self.count - index)];
    
    return @[first, second];
}

- (NSArray *)splitwithSubSize:(int)subSize {
    unsigned long count = self.count % subSize == 0 ? (self.count / subSize) : (self.count / subSize + 1);
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i ++) {
        int index = i * subSize;
        [arr1 removeAllObjects];
        
        int j = index;
        while (j < subSize*(i + 1) && j < self.count) {
            [arr1 addObject:[self objectAtIndex:j]];
            j += 1;
        }
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
}

- (NSArray *)qbUniquedArray {
    return [[NSOrderedSet orderedSetWithArray:self] array];
}

- (NSArray *)qbReversedArray {
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *)qbCompactedArray {
    NSMutableArray *mutableArray = [self mutableCopy];
    [mutableArray removeObjectIdenticalTo:[NSNull null]];
    return mutableArray;
}

#pragma mark - Compare
+ (NSArray *)qbUsingCompareSortedArray:(NSArray * _Nullable)array {
    if (!array) {
        return @[];
    }
    
    if (array.count == 0 || array.count == 1) {
        return array;
    }
    
    return [array sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)qbUsingDescriptorSortedWithkey:(NSString *)key ascending:(BOOL)ascending {
    if (!self) {
        return @[];
    }
    
    if (!key || key.length == 0) {
        return self;
    }
    
    if (self.count == 0 || self.count == 1) {
        return self;
    }
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key
                                                                     ascending:ascending];
    return [self sortedArrayUsingDescriptors:@[sortDescriptor]];
}

#pragma mark - Set
- (NSSet *)qbSet {
    return [NSSet setWithArray:self];
}

- (NSMutableSet *)qbMutableSet {
    return [NSMutableSet setWithArray:self];
}

- (NSOrderedSet *)qbOrderedSet {
    return [NSOrderedSet orderedSetWithArray:self];
}

- (NSMutableOrderedSet *)qbMutableOrderedSet {
    return [NSMutableOrderedSet orderedSetWithArray:self];
}

#pragma mark - Subarray
- (NSArray *)qbSubarrayFromIndex:(NSUInteger)index {
    if (index >= self.count - 1) {
        return @[];
    }
    
    return [self subarrayWithRange:NSMakeRange(index, [self count] - index)];
}

- (NSArray *)qbSubarrayToIndex:(NSUInteger)index {
    if (index >= self.count - 1) {
        return @[];
    }
    
    return [self subarrayWithRange:NSMakeRange(0, index + 1)];
}

#pragma mark - Alpha Numeric Titles
+ (NSArray *)qbArrayWithAlphaNumericTitlesWithSearch:(BOOL)search {
    if (search) {
        return @[@"{search}", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    } else {
        return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    }
}

+ (NSArray *)qbArrayWithAlphaNumericTitles {
    return [self qbArrayWithAlphaNumericTitlesWithSearch:NO];
}

#pragma mark - JSONString
- (NSString *)qbJSONString {
    return [self qbJSONStringWithOptions:0];
}

- (NSString *)qbJSONPrintedString {
    return [self qbJSONStringWithOptions:NSJSONWritingPrettyPrinted];
}

- (NSString *)qbJSONStringWithOptions:(NSJSONWritingOptions)opt {
    if (![NSJSONSerialization isValidJSONObject:self]) {
        return @"";
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:opt
                                                         error:&error];
    if (error) {
#if DEBUG
        NSLog(@"error=%@",error);
#endif
        return @"";
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)qbJSONString:(NSArray *)anArray {
    return [anArray qbJSONString];
}

+ (NSString *)qbJSONPrintedString:(NSArray *)anArray {
    return [anArray qbJSONPrintedString];
}

- (NSData *)qbJSONData {
    NSString *jsonString = [self qbJSONString];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)qbJSONPrintedData {
    NSString *jsonString = [self qbJSONPrintedString];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - rewrite
/**
 重写方法解决数组输出中文乱码的问题

 @param locale locale
 @return NSString
 */
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *string = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
        //去除转义字符
        [string stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }];
    if ([string hasSuffix:@",\n"]) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 2, 1)]; // 删除最后一个逗号
    }
    [string appendString:@")\n"];
    
    return string;
}

@end

@implementation NSMutableArray (QBExtension)

- (void)qbAppendObjects:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION {
    if (firstObject) {
        [self addObject:firstObject];
        
        id eachObject;
        va_list argumentList;
        
        va_start(argumentList, firstObject);
        
        eachObject = va_arg(argumentList, id);
        
        while (eachObject) {
            [self addObject:eachObject];
        }
        
        va_end(argumentList);
    }
}

- (void)qbReverse {
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i = 0; i < mid; i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

- (void)qbShuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:(i - 1) withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

#pragma mark - Insert
- (void)qbInsertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSUInteger i = index;
    for (id obj in objects) {
        [self insertObject:obj atIndex:i++];
    }
}

#pragma mark - Remove
- (void)qbRemoveFirstObject {
    if (self.count > 0) {
        [self removeObjectAtIndex:0];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)qbRemoveLastObject {
    if (self.count > 0) {
        [self removeObjectAtIndex:self.count - 1];
    }
}

#pragma clang diagnostic pop

#pragma mark - Pop
- (nullable id)qbPopFirstObject {
    id obj = nil;
    if (self.count) {
        obj = self.firstObject;
        [self qbRemoveFirstObject];
    }
    return obj;
}

- (nullable id)qbPopLastObject {
    id obj = nil;
    if (self.count) {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

#pragma mark - Move
- (void)qbMoveObjectAtIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    if (toIndex >= self.count - 1 || index >= self.count - 1) {
        return;
    }
    
    id originObj = self[index];
    [self removeObjectAtIndex:index];
    [self insertObject:originObj atIndex:toIndex];
}

//http://www.cocoabuilder.com/archive/cocoa/189484-nsarray-move-items-at-indexes.html
- (void)qbMoveObjectsAtIndexes:(NSIndexSet *)indexes toIndex:(NSUInteger)idx {
    NSArray *objectsToMove = [self objectsAtIndexes:indexes];
    
    // If any of the removed objects come before the index, we want to decrement the index appropriately
    idx -= [indexes countOfIndexesInRange:(NSRange){0, idx}];
    
    [self removeObjectsAtIndexes:indexes];
    [self replaceObjectsInRange:(NSRange){idx,0} withObjectsFromArray:objectsToMove];
}

#pragma mark - NSSet
+ (NSMutableArray *)qbArrayWithSet:(NSSet *)set {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[set count]];
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [array addObject:obj];
    }];
    return array;
}

#pragma mark - SafeAccess
- (void)qbAddObject:(id)obj {
    if (obj != nil && obj != NULL) {
        [self addObject:obj];
    }
}

- (void)qbAddBOOL:(BOOL)value {
    [self addObject:[NSNumber numberWithBool:value]];
}

- (void)qbAddInt:(int)value {
    [self addObject:@(value)];
}

- (void)qbAddInteger:(NSInteger)value {
    [self addObject:@(value)];
}

- (void)qbAddUnsignedInteger:(NSUInteger)value {
    [self addObject:@(value)];
}

- (void)qbAddCGFloat:(CGFloat)value {
    [self addObject:@(value)];
}

- (void)qbAddChar:(char)value {
    [self addObject:@(value)];
}

- (void)qbAddFloat:(float)value {
    [self addObject:@(value)];
}

- (void)qbAddPoint:(CGPoint)value {
    [self addObject:NSStringFromCGPoint(value)];
}

- (void)qbAddSize:(CGSize)value {
    [self addObject:NSStringFromCGSize(value)];
}

- (void)qbAddRect:(CGRect)value {
    [self addObject:NSStringFromCGRect(value)];
}

- (void)qbInsertBOOL:(BOOL)value atIndex:(NSUInteger)index {
    [self insertObject:@(value) atIndex:index];
}

- (void)qbInsertInt:(int)value atIndex:(NSUInteger)index {
    [self insertObject:@(value) atIndex:index];
}

- (void)qbInsertInteger:(NSInteger)value atIndex:(NSUInteger)index {
    [self insertObject:@(value) atIndex:index];
}

- (void)qbInsertUnsignedInteger:(NSUInteger)value atIndex:(NSUInteger)index {
    [self insertObject:@(value) atIndex:index];
}

- (void)qbInsertCGFloat:(CGFloat)value atIndex:(NSUInteger)index {
    [self insertObject:[NSNumber qbNumberWithCGFloat:value] atIndex:index];
}

- (void)qbInsertChar:(char)value atIndex:(NSUInteger)index {
    [self insertObject:@(value) atIndex:index];
}

- (void)qbInsertFloat:(float)value atIndex:(NSUInteger)index {
    [self insertObject:@(value) atIndex:index];
}

- (void)qbInsertPoint:(CGPoint)value atIndex:(NSUInteger)index {
    [self insertObject:NSStringFromCGPoint(value) atIndex:index];
}

- (void)qbInsertSize:(CGSize)value atIndex:(NSUInteger)index {
    [self insertObject:NSStringFromCGSize(value) atIndex:index];
}

- (void)qbInsertRect:(CGRect)value atIndex:(NSUInteger)index {
    [self insertObject:NSStringFromCGRect(value) atIndex:index];
}

#pragma mark - Block
- (void)qbPerformSelect:(BOOL (^)(id obj))block {
    NSIndexSet *list = [self indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return !block(obj);
    }];
    if (!list.count)
        return;
    [self removeObjectsAtIndexes:list];
}

- (void)qbPerformReject:(BOOL (^)(id obj))block {
    return [self qbPerformSelect:^BOOL(id  _Nonnull obj) {
        return !block(obj);
    }];
}

- (void)qbPerformMap:(id (^)(id obj))block {
    __block NSMutableArray *new = [self mutableCopy];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block(obj) ? : [NSNull null];
        if ([value isEqual:obj]) return ;
        new[idx] = value;
    }];
    [self setArray:new];
}


@end
