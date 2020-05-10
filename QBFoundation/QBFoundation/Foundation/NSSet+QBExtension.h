//
//  NSSet+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet (QBExtension)

- (NSArray *)qbArray;

- (NSMutableArray *)qbMutableArray;

- (NSOrderedSet *)qbOrderedSet;

- (NSMutableOrderedSet *)qbMutableOrderedSet;

@end

NS_ASSUME_NONNULL_END
