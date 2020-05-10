//
//  UIControl+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIControl+QBExtension.h"
#import "NSObject+QBExtension.h"

static const int _qb_block_key;

@interface _QBUIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(void);
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(void))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _QBUIControlBlockTarget

- (id)initWithBlock:(void (^)(void))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = [block copy];
        _events = events;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block)
        _block();
}

@end

@implementation UIControl (QBExtension)

#pragma mark - Block
- (void)qbRemoveAllTargets {
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self _qb_allUIControlBlockTargets] removeAllObjects];
}

- (void)qbSetTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (!target || !action || !controlEvents)
        return;
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions) {
            [self removeTarget:currentTarget action:NSSelectorFromString(currentAction)
              forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)qbAddBlockForControlEvents:(UIControlEvents)controlEvents
                             block:(void (^)(void))block {
    if (!controlEvents)
        return;
    _QBUIControlBlockTarget *target = [[_QBUIControlBlockTarget alloc]
                                       initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _qb_allUIControlBlockTargets];
    [targets addObject:target];
}

- (void)qbAddClickBlock:(void (^)(void))block {
    [self qbAddBlockForControlEvents:UIControlEventTouchUpInside block:block];
}

- (void)qbSetBlockForControlEvents:(UIControlEvents)controlEvents
                             block:(void (^)(void))block {
    [self qbRemoveAllBlocksForControlEvents:UIControlEventAllEvents];
    [self qbAddBlockForControlEvents:controlEvents block:block];
}

- (void)qbRemoveAllBlocksForControlEvents:(UIControlEvents)controlEvents {
    if (!controlEvents)
        return;
    
    NSMutableArray *targets = [self _qb_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_QBUIControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}

- (NSMutableArray *)_qb_allUIControlBlockTargets {
    NSMutableArray *targets = [self qbGetAssociativeObjectWithKey:&_qb_block_key];
    if (!targets) {
        targets = [NSMutableArray array];
        [self qbSetAssociatedRetainNonatomicObject:targets forKey:&_qb_block_key];
    }
    return targets;
}

@end
