//
//  NSSet+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSSet+QBExtension.h"

@implementation NSSet (QBExtension)

- (NSArray *)qbArray {
    return self.allObjects;
}

- (NSMutableArray *)qbMutableArray {
    return [self.allObjects mutableCopy];
}

- (NSOrderedSet *)qbOrderedSet {
    return [NSOrderedSet orderedSetWithSet:self];
}

- (NSMutableOrderedSet *)qbMutableOrderedSet {
    return [NSMutableOrderedSet orderedSetWithSet:self];
}

@end
