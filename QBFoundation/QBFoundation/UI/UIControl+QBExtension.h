//
//  UIControl+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (QBExtension)

#pragma mark - EventInterval

@property (nonatomic, assign) BOOL qbEventUnavailable;

/** 点击时间响应时间间隔 */
@property (nonatomic, assign) NSTimeInterval qbEventInterval;

#pragma mark - TouchArea

/**
 设置按钮额外热区
 */
@property (nonatomic, assign) UIEdgeInsets qbTouchAreaInsets;

/**
 设置按钮额外热区

 @param edge 边缘大小
 */
- (void)setQbTouchAreaEdge:(CGFloat)edge;

#pragma mark - Block
/**
 从内部调度表移除所有的目标和动作
 */
- (void)qbRemoveAllTargets;

/**
 为特定事件（或事件）添加或替换目标和操作到内部调度表

 @param target 目标
 @param action 动作
 @param controlEvents 事件
 */
- (void)qbSetTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 将特定事件（或事件）的块添加到内部调度表中。它将可能导致强引用

 @param controlEvents 事件
 @param block 代码块
 */
- (void)qbAddBlockForControlEvents:(UIControlEvents)controlEvents
                             block:(void (^)(void))block;

/**
 将UIControlEventTouchUpInside事件的块添加到内部调度表中。它将可能导致强引用

 @param block 代码块
 */
- (void)qbAddClickBlock:(void (^)(void))block;

/**
 添加或替换特定事件（或事件）的块添加到内部调度表中。它将可能导致强引用
 与'qbAddBlockForControlEvents:block:'方法的区别：
 先移除所有的controlEvents，再调用'qbAddBlockForControlEvents:block:'方法
 
 @param controlEvents 事件
 @param block 代码块
 */
- (void)qbSetBlockForControlEvents:(UIControlEvents)controlEvents
                             block:(void (^)(void))block;

/**
 从内部调度表中删除特定事件（或事件）的所有块

 @param controlEvents 事件
 */
- (void)qbRemoveAllBlocksForControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
