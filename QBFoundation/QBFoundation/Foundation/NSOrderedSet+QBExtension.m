//
//  NSOrderedSet+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSOrderedSet+QBExtension.h"

@implementation NSOrderedSet (QBExtension)

#pragma mark - SafeAccess
- (nullable id)qbObjectAtIndex:(NSUInteger)index {
    if ([self count] > index)
        return [self objectAtIndex:index];
    
    return nil;
}

+ (instancetype)qbOrderedSetWithArray:(NSArray *)array {
    if (array && array.count > 0) {
        return [self orderedSetWithArray:array];
    }
    return [self orderedSet];
}

- (instancetype)qbInitWithArray:(NSArray *)array {
    if (array && array.count > 0) {
        return [self initWithArray:array];
    }
    return [self init];
}

@end

@implementation NSMutableOrderedSet (qbExtension)

#pragma mark - SafeAccess
- (void)qbAddObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

- (void)qbInsertObject:(id)object atIndex:(NSUInteger)index {
    if (object) {
        if (index > self.count) {
            index = self.count;
        }
        
        [self insertObject:object atIndex:index];
    }
}

- (void)qbRemoveObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)qbRemoveObject:(id)object {
    if (object) {
        [self removeObject:object];
    }
}

- (void)qbAddObjectsFromArray:(NSArray *)array {
    if (array && array.count > 0) {
        [self addObjectsFromArray:array];
    }
}

+ (instancetype)qbOrderedSetWithArray:(NSArray *)array {
    if (array && array.count > 0) {
        return [self orderedSetWithArray:array];
    }
    
    return [self orderedSetWithCapacity:0];
}

- (instancetype)qbInitWithArray:(NSArray *)array {
    if (array && array.count > 0) {
        return [self initWithArray:array];
    }
    
    return [self initWithCapacity:0];
}


@end
