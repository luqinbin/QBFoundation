//
//  NSDictionary+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSDictionary+QBExtension.h"
#import "NSArray+QBExtension.h"
#import "NSNumber+QBExtension.h"
#import "NSString+QBExtension.h"

@implementation NSDictionary (QBExtension)

+ (BOOL)qbIsEmpty:(NSDictionary * _Nullable)dictionary {
    if (!dictionary || [dictionary isEqual:[NSNull null]] || dictionary.allKeys.count == 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Common
- (NSSet *)qbKeysSet {
    return [self.allKeys qbSet];
}

- (NSSet *)qbValuesSet {
    return [self.allValues qbSet];
}

- (NSArray *)qbSortedAllKeys {
    return [self.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)qbSortedAllKeysUsingComparator:(NSComparator)comparator {
    return [self.allKeys sortedArrayUsingComparator:comparator];
}

- (NSArray *)qbSortedAllValuesByKeys {
    NSArray *sortedKeys = [self qbSortedAllKeys];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:sortedKeys.count];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return arr;
}

- (NSArray *)qbSortedAllValuesUsingKeysComparator:(NSComparator)comparator {
    NSMutableArray *returnValues = [[NSMutableArray alloc] initWithCapacity:self.allValues.count];
    [self qbEnumerateSortedKeysAndObjectsUsingComparator:comparator usingBlock:^(id key, id value, BOOL *stop) {
        [returnValues addObject:value];
    }];
    
    return [returnValues copy];
}

- (void)qbEnumerateSortedKeysAndObjectsUsingComparator:(NSComparator)comparator usingBlock:(void (^)(id key, id value, BOOL *stop))block {
    NSArray *sortedKeys = [self qbSortedAllKeysUsingComparator:comparator];
    [sortedKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        id value = [self objectForKey:key];
        block(key, value, stop);
    }];
}

- (NSData *)qbPlistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
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
    if (jsonData == nil) {
        return @"";
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (nullable NSData *)qbJSONData {
    NSString *jsonString = [self qbJSONString];
    if (jsonString.length == 0) {
        return nil;
    }
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

- (nullable NSData *)qbJSONPrintedData {
    NSString *jsonString = [self qbJSONPrintedString];
    if (jsonString.length == 0) {
        return nil;
    }
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Merge
+ (NSDictionary *)qbDictionaryByMerging:(NSDictionary *)oneDict andOther:(NSDictionary *)otherDict {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:oneDict];
    NSMutableDictionary *resultTemp = [NSMutableDictionary dictionaryWithDictionary:oneDict];
    [resultTemp addEntriesFromDictionary:otherDict];
    [resultTemp enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ([oneDict objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[oneDict objectForKey: key] qbDictionaryByMergingOther: (NSDictionary *) obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        } else if([otherDict objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[otherDict objectForKey: key] qbDictionaryByMergingOther: (NSDictionary *) obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        }
    }];
    
    return (NSDictionary *) [result mutableCopy];
}

- (NSDictionary *)qbDictionaryByMergingOther:(NSDictionary *)dict {
    return [[self class] qbDictionaryByMerging:self andOther: dict];
}

#pragma mark - Manipulation
- (NSDictionary *)qbDictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [self mutableCopy];
    [result addEntriesFromDictionary:dictionary];
    
    return result;
}

- (NSDictionary *)qbDictionaryByRemovingEntriesWithKeys:(NSSet *)keys {
    NSMutableDictionary *result = [self mutableCopy];
    [result removeObjectsForKeys:keys.allObjects];
    
    return result;
}

#pragma mark - SafeAccess
- (BOOL)qbHadKey:(NSString *)key {
    return [self objectForKey:key] != nil;
}

- (nullable id)qbObjectForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return nil;
    }
    return value;
}

- (NSString *)qbStringForKey:(NSString *)key {
    return [self qbStringForKey:key defaultValue:@""];
}

- (NSString *)qbStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    } else if ([value isKindOfClass:[NSArray class]]) {
        return [((NSArray *)value) qbJSONString];
    } else if ([value isKindOfClass:[NSMutableArray class]]) {
        return [((NSMutableArray *)value) qbJSONString];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        return [((NSDictionary *)value) qbJSONString];
    } else if ([value isKindOfClass:[NSMutableDictionary class]]) {
        return [((NSMutableDictionary *)value) qbJSONString];
    }
    return defaultValue;
}

- (NSNumber *)qbNumberForKey:(NSString *)key {
    return [self qbNumberForKey:key defaultValue:@(0)];
}

- (NSNumber *)qbNumberForKey:(NSString *)key defaultValue:(NSNumber * _Nullable)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    } else if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *)value];
    }
    return defaultValue;
}

- (nullable NSNumber *)qbNumberForKeyPath:(NSString *)keyPath {
    id r = [self valueForKeyPath:keyPath];
    if ([r isKindOfClass:[NSNumber class]])
        return r;
    if ([r isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString *)r];
    }
    return nil;
}

- (nullable NSDecimalNumber *)qbDecimalNumberForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber *)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString *)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}

- (BOOL)qbBoolForKey:(NSString *)key {
    return [self qbBoolForKey:key defaultValue:NO];
}

- (BOOL)qbBoolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return defaultValue;
}

- (BOOL)qbBoolForKeyPath:(NSString *)keyPath {
    return [[self qbNumberForKeyPath:keyPath] boolValue];
}

- (NSInteger)qbIntegerForKey:(NSString *)key {
    return [self qbIntegerForKey:key defaultValue:0];
}

- (NSInteger)qbIntegerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    }
    return defaultValue;
}

- (NSUInteger)qbUnsignedIntegerForKey:(NSString *)key {
    return [self qbUnsignedIntegerForKey:key defaultValue:0];
}

- (NSUInteger)qbUnsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    return defaultValue;
}

- (char)qbCharForKey:(NSString *)key {
    return [self qbCharForKey:key defaultValue:0];
}

- (char)qbCharForKey:(NSString *)key defaultValue:(char)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value charValue];
    }
    return defaultValue;
}

- (unsigned char)qbUnsignedCharForKey:(NSString *)key {
    return [self qbUnsignedCharForKey:key defaultValue:0];
}

- (unsigned char)qbUnsignedCharForKey:(NSString *)key defaultValue:(unsigned char)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value unsignedCharValue];
    }
    return defaultValue;
}

- (short)qbShortForKey:(NSString *)key {
    return [self qbShortForKey:key defaultValue:0];
}

- (short)qbShortForKey:(NSString *)key defaultValue:(short)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return (short)[value intValue];
    }
    return defaultValue;
}

- (unsigned short)qbUnsignedShortForKey:(NSString *)key {
    return [self qbUnsignedShortForKey:key defaultValue:0];
}

- (unsigned short)qbUnsignedShortForKey:(NSString *)key defaultValue:(unsigned short)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value shortValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return (unsigned short)[value intValue];
    }
    return defaultValue;
}

- (long)qbLongForKey:(NSString *)key {
    return [self qbLongForKey:key defaultValue:0];
}

- (long)qbLongForKey:(NSString *)key defaultValue:(long)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longValue];
    }
    return defaultValue;
}

- (unsigned long)qbUnsignedLongForKey:(NSString *)key {
    return [self qbUnsignedLongForKey:key defaultValue:0];
}

- (unsigned long)qbUnsignedLongForKey:(NSString *)key defaultValue:(unsigned long)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        return [[nf numberFromString:value] unsignedLongValue];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongValue];
    }
    return defaultValue;
}

- (long long)qbLongLongForKey:(NSString *)key {
    return [self qbLongLongForKey:key defaultValue:0];
}

- (long long)qbLongLongForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return defaultValue;
}

- (unsigned long long)qbUnsignedLongLongForKey:(NSString *)key {
    return [self qbUnsignedLongLongForKey:key defaultValue:0];
}

- (unsigned long long)qbUnsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long)defaultValue {
    id value = [self objectForKey:key];
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        return [[nf numberFromString:value] unsignedLongLongValue];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return defaultValue;
}

- (int8_t)qbInt8ForKey:(NSString *)key {
    return [self qbCharForKey:key];
}

- (int8_t)qbInt8ForKey:(NSString *)key defaultValue:(int8_t)value {
    return [self qbCharForKey:key defaultValue:value];
}

- (uint8_t)qbUint8ForKey:(NSString *)key {
    return [self qbUnsignedCharForKey:key];
}

- (uint8_t)qbUint8ForKey:(NSString *)key defaultValue:(uint8_t)value {
    return [self qbUnsignedCharForKey:key defaultValue:value];
}

- (int16_t)qbInt16ForKey:(NSString *)key {
    return [self qbShortForKey:key];
}

- (int16_t)qbInt16ForKey:(NSString *)key defaultValue:(int16_t)value {
    return [self qbShortForKey:key defaultValue:value];
}

- (uint16_t)qbUint16ForKey:(NSString *)key {
    return [self qbUnsignedShortForKey:key];
}

- (uint16_t)qbUint16ForKey:(NSString *)key defaultValue:(uint16_t)value {
    return [self qbUnsignedShortForKey:key defaultValue:value];
}

- (int32_t)qbInt32ForKey:(NSString *)key {
    return (int32_t)[self qbLongForKey:key];
}

- (int32_t)qbInt32ForKey:(NSString *)key defaultValue:(int32_t)value {
    return (int32_t)[self qbLongForKey:key defaultValue:value];
}

- (uint32_t)qbUint32ForKey:(NSString *)key {
    return (uint32_t)[self qbUnsignedLongForKey:key];
}

- (uint32_t)qbUint32ForKey:(NSString *)key defaultValue:(uint32_t)value {
    return (uint32_t)[self qbUnsignedLongForKey:key defaultValue:value];
}

- (int64_t)qbInt64ForKey:(NSString *)key {
    return [self qbLongLongForKey:key];
}

- (int64_t)qbInt64ForKey:(NSString *)key defaultValue:(int64_t)value {
    return [self qbLongLongForKey:key defaultValue:value];
}

- (uint64_t)qbUint64ForKey:(NSString *)key {
    return [self qbUnsignedLongLongForKey:key];
}

- (uint64_t)qbUint64ForKey:(NSString *)key defaultValue:(uint64_t)value {
    return [self qbUnsignedLongLongForKey:key defaultValue:value];
}

- (float)qbFloatForKey:(NSString *)key {
    return [self qbFloatForKey:key defaultValue:0];
}

- (float)qbFloatForKey:(NSString *)key defaultValue:(float)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return defaultValue;
}

- (double)qbDoubleForKey:(NSString *)key {
    return [self qbDoubleForKey:key defaultValue:0];
}

- (double)qbDoubleForKey:(NSString *)key defaultValue:(double)defaultValue {
    id value = [self objectForKey:key];
    
    if (!value || [value isEqual:[NSNull null]]) {
        return defaultValue;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value doubleValue];
    }
    return defaultValue;
}

- (NSTimeInterval)qbTimeIntervalForKey:(NSString *)key {
    return [self qbDoubleForKey:key defaultValue:0];
}

- (NSTimeInterval)qbTimeIntervalForKey:(NSString *)key defaultValue:(NSTimeInterval)value {
    return [self qbDoubleForKey:key defaultValue:value];
}

- (nullable NSDate *)qbDateForKey:(id)key dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self objectForKey:key];
    
    if (!value || [value isEqual:[NSNull null]]) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    
    return nil;
}

- (CGFloat)qbCGFloatForKey:(NSString *)key {
    CGFloat f = [self[key] doubleValue];
    return f;
}

- (CGPoint)qbPointForKey:(NSString *)key {
    CGPoint point = CGPointFromString(self[key]);
    return point;
}

- (CGSize)qbSizeForKey:(NSString *)key {
    CGSize size = CGSizeFromString(self[key]);
    return size;
}

- (CGRect)qbRectForKey:(NSString *)key {
    CGRect rect = CGRectFromString(self[key]);
    return rect;
}

- (nullable const char *)qbCStringForKey:(NSString *)key {
    const char *cString = NULL;
    id object = [self valueForKey:key];
    if (object && [object respondsToSelector:@selector(UTF8String)]) {
        cString = [object UTF8String];
    }
    
    return cString;
}

- (nullable SEL)qbSelectorForKey:(NSString *)key {
    SEL selector = NULL;
    const char *name = [self qbCStringForKey:key];
    if (name) {
        selector = sel_registerName(name);
    }
    
    return selector;
}

#pragma mark - URL
+ (NSDictionary *)qbDictionaryWithURLQuery:(NSString *)query {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    for(NSString *parameter in parameters) {
        NSArray *contents = [parameter componentsSeparatedByString:@"="];
        if([contents count] == 2) {
            NSString *key = [contents objectAtIndex:0];
            NSString *value = [contents objectAtIndex:1];
            if (key && value) {
                [dict setObject:[value qbURLDecode] forKey:key];
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)qbURLQueryString {
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in [self allKeys]) {
        if ([string length]) {
            [string appendString:@"&"];
        }
        [string appendFormat:@"%@=%@", key, [[self objectForKey:key] qbURLEncode]];
    }
    
    return string;
}

#pragma mark Block
- (void)qbEach:(void (^)(id key, id obj))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key, obj);
    }];
}

- (void)qbApply:(void (^)(id key, id obj))block {
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key, obj);
    }];
}

- (nullable id)qbMatch:(BOOL (^)(id key, id obj))block {
    return self[[[self keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key, obj)) {
            *stop = YES;
            return YES;
        }
        return NO;
    }] anyObject]];
}

- (NSDictionary *)qbSelect:(BOOL (^)(id key, id obj))block {
    NSArray *keys = [[self keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return block(key, obj);
    }] allObjects];
    NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
    return [NSDictionary dictionaryWithObject:objects forKey:keys];
}

- (NSDictionary *)qbReject:(BOOL (^)(id key, id obj))block {
    return [self qbSelect:^BOOL(id  _Nonnull key, id  _Nonnull obj) {
        return !block(key, obj);
    }];
}

- (NSDictionary *)qbMap:(id (^)(id key, id obj))block {
    __block NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self qbEach:^(id  _Nonnull key, id  _Nonnull obj) {
        id value = block(key, obj) ? : [NSNull null];
        result[key] = value;
    }];
    return result;
}

- (BOOL)qbAny:(BOOL (^)(id key, id _Nullable obj))block {
    return [self qbMatch:block] != nil;
}

- (BOOL)qbNone:(BOOL (^)(id key, id _Nullable obj))block {
    return [self qbMatch:block] == nil;
}

- (BOOL)qbAll:(BOOL (^)(id key, id _Nullable obj))block {
    __block BOOL result = YES;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!block(key, obj)) {
            result = NO;
            *stop = YES;
        }
    }];
    
    return result;
}

- (NSDictionary *)qbDictionaryPickForKeys:(NSArray *)keys {
    NSMutableDictionary *picked = [[NSMutableDictionary alloc] initWithCapacity:keys.count];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([keys containsObject:key]) {
            picked[key] = obj;
        }
    }];
    
    return picked;
}

- (NSDictionary *)qbDictionaryOmitForKeys:(NSArray *)keys {
    NSMutableDictionary *omitted = [[NSMutableDictionary alloc] initWithCapacity:([self allKeys].count - keys.count)];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![keys containsObject:key]) {
            omitted[key] = obj;
        }
    }];
    
    return omitted;
}

#pragma mark - rewrite
/**
 重写方法解决字典输出中文乱码的问题

 @param locale locale
 @return NSString
 */
- (NSString *)descriptionWithLocale:(id)locale {
    // 以下两种方法均能实现目的，第二中方法排版视觉效果更好
    /*
    NSMutableString *string = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"\t%@ = %@;\n", key, obj];
        //去除转义字符
        [string stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }];
    [string appendString:@"}\n"];
    return string; */
    
    NSString *output;
    @try {
        output = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        output = [output stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; // 处理\/转义字符
    } @catch (NSException *exception) {
        output = self.description;
    }
    return output;
}

@end

@implementation NSMutableDictionary (QBExtension)

#pragma mark - SafeAccess
- (void)qbSetObject:(id)value forKey:(NSString *)key {
    if (value != nil) {
        self[key] = value;
    }
}

- (void)qbSetString:(NSString *)value forKey:(NSString *)key {
    if (value != nil) {
        [self setValue:value forKey:key];
    }
}

- (void)qbSetBool:(BOOL)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetInt:(int)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetInteger:(NSInteger)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetUnsignedInteger:(NSUInteger)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetChar:(char)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetUnsignedChar:(unsigned char)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetShort:(short)value forKey:(NSString *)key {
    [self setObject:@(value) forKey:key];
}

- (void)qbSetUnsignedShort:(unsigned short)value forKey:(NSString *)key {
    [self setObject:@(value) forKey:key];
}

- (void)qbSetLong:(long)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetUnsignedLong:(unsigned long)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetLongLong:(long long)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetUnsignedLongLong:(unsigned long long)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetInt8:(int8_t)value forKey:(NSString *)key {
    [self qbSetChar:value forKey:key];
}

- (void)qbSetUInt8:(uint8_t)value forKey:(NSString *)key {
    [self qbSetUnsignedChar:value forKey:key];
}

- (void)qbSetInt16:(int16_t)value forKey:(NSString *)key {
    [self qbSetShort:value forKey:key];
}

- (void)qbSetUInt16:(uint16_t)value forKey:(NSString *)key {
    [self qbSetUnsignedShort:value forKey:key];
}

- (void)qbSetInt32:(int32_t)value forKey:(NSString *)key {
    [self qbSetLong:value forKey:key];
}

- (void)qbSetUInt32:(uint32_t)value forKey:(NSString *)key {
    [self qbSetUnsignedLong:value forKey:key];
}

- (void)qbSetInt64:(int64_t)value forKey:(NSString *)key {
    [self qbSetLongLong:value forKey:key];
}

- (void)qbSetUInt64:(uint64_t)value forKey:(NSString *)key {
    [self qbSetUnsignedLongLong:value forKey:key];
}

- (void)qbSetFloat:(float)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetDouble:(double)value forKey:(NSString *)key {
    [self setValue:@(value) forKey:key];
}

- (void)qbSetCGFloat:(CGFloat)value forKey:(NSString *)key {
    [self setValue:[NSNumber qbNumberWithCGFloat:value] forKey:key];
}

- (void)qbSetTimeInterval:(NSTimeInterval)value forKey:(NSString *)key {
    [self qbSetDouble:value forKey:key];
}

- (void)qbSetCString:(const char *)value forKey:(NSString *)key {
    [self setValue:[NSString stringWithUTF8String:value] forKey:key];
}

- (void)qbSetSelector:(SEL)value forKey:(NSString *)key {
    [self qbSetCString:sel_getName(value) forKey:key];
}

- (void)qbSetCGPoint:(CGPoint)value forKey:(NSString *)key {
    self[key] = NSStringFromCGPoint(value);
}

- (void)qbSetCGSize:(CGSize)value forKey:(NSString *)key {
    self[key] = NSStringFromCGSize(value);
}

- (void)qbSetCGRect:(CGRect)value forKey:(NSString *)key {
    self[key] = NSStringFromCGRect(value);
}

- (void)qbSetCGAffineTransform:(CGAffineTransform)value forKey:(NSString *)key {
    [self setValue:[NSValue valueWithCGAffineTransform:value] forKey:key];
}

- (void)qbSetUIEdgeInsets:(UIEdgeInsets)value forKey:(NSString *)key {
    [self setValue:[NSValue valueWithUIEdgeInsets:value] forKey:key];
}

- (void)qbSetUIOffset:(UIOffset)value forKey:(NSString *)key {
    [self setValue:[NSValue valueWithUIOffset:value] forKey:key];
}

#pragma mark - Common
- (void)qbRenameKey:(NSString *)key toKey:(NSString *)newKey {
    if (!key || !newKey)
        return;
    
    id object = self[key];
    
    if (!object)
        return;
    
    [self setObject:object forKey:newKey];
    [self removeObjectForKey:key];
}

#pragma mark - Block
- (void)qbPerformSelect:(BOOL (^)(id key, id obj))block {
    NSArray *keys = [[self keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return !block(key, obj);
    }] allObjects];
    [self removeObjectsForKeys:keys];
}

- (void)qbPerformReject:(BOOL (^)(id key, id obj))block {
    [self qbPerformSelect:^BOOL(id  _Nonnull key, id  _Nonnull obj) {
        return !block(key, obj);
    }];
}

- (void)qbPerformMap:(id (^)(id key, id obj))block {
    __block NSMutableDictionary *new = [self mutableCopy];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        id value = block(key, obj) ?: [NSNull null];
        if ([value isEqual:obj]) {
            return ;
        }
        new[key] = value;
    }];
    [self setDictionary:new];
}

@end
