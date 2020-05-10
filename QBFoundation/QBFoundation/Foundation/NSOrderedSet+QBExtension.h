//
//  NSOrderedSet+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSOrderedSet (QBExtension)

#pragma mark - SafeAccess
- (nullable id)qbObjectAtIndex:(NSUInteger)index;

+ (instancetype)qbOrderedSetWithArray:(NSArray *)array;

- (instancetype)qbInitWithArray:(NSArray *)array;

@end

@interface NSMutableOrderedSet (qbExtension)

- (void)qbAddObject:(id)object;

- (void)qbInsertObject:(id)object atIndex:(NSUInteger)index;

- (void)qbRemoveObjectAtIndex:(NSUInteger)index;

- (void)qbRemoveObject:(id)object;

- (void)qbAddObjectsFromArray:(NSArray *)array;

+ (instancetype)qbOrderedSetWithArray:(NSArray *)array;

- (instancetype)qbInitWithArray:(NSArray *)array;


@end

NS_ASSUME_NONNULL_END
