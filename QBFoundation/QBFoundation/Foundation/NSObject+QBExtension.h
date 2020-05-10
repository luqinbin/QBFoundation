//
//  NSObject+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/6.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QBExtension)

#pragma mark - KVO
- (void)qbAddObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(__weak id obj, id oldVal, id newVal))block;

- (void)qbRemoveObserverBlocksForKeyPath:(NSString *)keyPath;

- (void)qbRemoveObserverBlocks;

#pragma mark - Associate
- (void)qbSetAssociatedAssignObject:(id)obj forKey:(const void *)key;

- (void)qbSetAssociatedRetainNonatomicObject:(id)obj forKey:(const void *)key;

- (void)qbSetAssociatedRetainObject:(id)obj forKey:(const void *)key;

- (void)qbSetAssociatedCopyNonatomicObject:(id)obj forKey:(const void *)key;

- (void)qbSetAssociatedCopyObject:(id)obj forKey:(const void *)key;

- (id _Nullable)qbGetAssociativeObjectWithKey:(const void *)key;

#pragma mark - Reflection
- (NSString *)qbClassName;

- (NSString *)qbSuperClassName;

+ (NSString *)qbClassName;

+ (NSString *)qbSuperClassName;

- (NSDictionary<NSString *, id> *)qbPropertyDictionary;

- (NSArray<NSString *> *)qbPropertyKeys;

+ (NSArray<NSString *> *)qbPropertyKeys;

- (NSArray *)qbPropertiesInfo;

+ (NSArray *)qbPropertiesInfo;

+ (NSArray *)qbPropertiesWithCodeFormat;

- (NSArray<NSString *> *)qbMethodNameList ;

- (NSArray *)qbMethodListInfo;

+ (NSArray *)qbRegistedClassList;

- (NSDictionary *)qbProtocolList;

+ (NSDictionary *)qbProtocolList;

+ (NSArray<NSString *> *)qbInstanceVariable;

- (BOOL)qbHasPropertyForKey:(NSString *)key;

- (BOOL)qbHasIvarForKey:(NSString *)key;

#pragma mark - AutoDescribe
- (void)qbPrintObject;

- (void)qbPrintObjectKeys:(NSArray *)keys;

- (void)qbPrintObjectMethods;

#pragma mark - NSString
+ (NSString *)qbObjectToString:(id _Nullable)object;
+ (BOOL)qbIsKindOfDictionary:(id _Nullable)object;
+ (BOOL)qbIsKindOfArray:(id _Nullable)object;

@end

NS_ASSUME_NONNULL_END
