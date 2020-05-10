//
//  UITableView+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (QBExtension)

/**
 使用代码块执行更新、插入、删除、选择等

 @param block block
 */
- (void)qbUpdateWithBlock:(void (^)(UITableView *tableView))block;

/**
 使用指定滑动方向滑到指定区指定行

 @param row 行数
 @param section 指定区
 @param scrollPosition 滑动方向
 @param animated 是否需要动画
 */
- (void)qbScrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 滑到底部

 @param animated 是否需要动画
 */
- (void)qbScrollsToBottomAnimated:(BOOL)animated;

/**
 使用一个给定动画插入指定的索引路径

 @param indexPath 索引路径
 @param animation 是否需要动画
 */
- (void)qbInsertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个动画效果在指定区插入行数

 @param row 行数
 @param section 指定区
 @param animation 是否需要动画
 */
- (void)qbInsertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个给定的动画效果重新加载指定的索引路径

 @param indexPath 索引路径
 @param animation 是否需要动画
 */
- (void)qbReloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个给定的动画效果重新加载指定区的指定行

 @param row 行数
 @param section 指定区
 @param animation 是否需要动画
 */
- (void)qbReloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个给定的动画效果删除索指定的索引路径

 @param indexPath 索引路径
 @param animation 是否需要动画
 */
- (void)qbDeleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个给定的动画效果删除指定区的指定行

 @param row 行数
 @param section 指定区
 @param animation 是否需要动画
 */
- (void)qbDeleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个给定的动画效果插入指定区

 @param section 指定区
 @param animation 是否需要动画
 */
- (void)qbInsertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个给定的动画效果删除指定区

 @param section 指定区
 @param animation 是否需要动画
 */
- (void)qbDeleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 使用一个给定的动画效果重新加载指定区

 @param section 指定区
 @param animation 是否需要动画
 */
- (void)qbReloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 取消所有选中行

 @param animated 是否需要动画
 */
- (void)qbClearSelectedRowsAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
