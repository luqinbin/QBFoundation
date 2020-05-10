//
//  UIScrollView+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QBScrollDirection) {
    QBScrollDirectionUp,
    QBScrollDirectionDown,
    QBScrollDirectionLeft,
    QBScrollDirectionRight,
    QBScrollDirectionWTF
};

@interface UIScrollView (QBExtension)

#pragma mark - Pages
/**
 总共多少页
 
 @return NSInteger
 */
- (NSInteger)qbPages;

/**
 当前第几页
 
 @return NSInteger
 */
- (NSInteger)qbCurrentPage;

/**
 滚动百分比
 
 @return CGFloat
 */
- (CGFloat)qbScrollPercent;

/**
 y方向上的页数
 
 @return CGFloat
 */
- (CGFloat)qbPagesY;

/**
 y方向上的页数
 
 @return CGFloat
 */
- (CGFloat)qbPagesX;

/**
 y方向上当前是第几页
 
 @return CGFloat
 */
- (CGFloat)qbCurrentPageY;

/**
 x方向上当前是第几页
 
 @return CGFloat
 */
- (CGFloat)qbCurrentPageX;

/**
 设置y方向页数
 
 @param page 页数
 */
- (void)qbSetPageY:(CGFloat)page;

/**
 设置x方向页数
 
 @param page 页数
 */
- (void)qbSetPageX:(CGFloat)page;

/**
 设置y方向页数
 
 @param page 页数
 @param animated 动画
 */
- (void)qbSetPageY:(CGFloat)page animated:(BOOL)animated;

/**
 设置x方向页数
 
 @param page 页数
 @param animated 动画
 */
- (void)qbSetPageX:(CGFloat)page animated:(BOOL)animated;

#pragma mark - ZoomToPoint //放大某一点
/**
 放大某一点
 
 @param zoomPoint 放大的点
 @param scale 比例
 @param animated 动画
 */
- (void)qbZoomToPoint:(CGPoint)zoomPoint scale:(CGFloat)scale animated:(BOOL)animated;

#pragma mark - Content
@property(nonatomic) CGFloat qbContentWidth;
@property(nonatomic) CGFloat qbContentHeight;
@property(nonatomic) CGFloat qbContentOffsetX;
@property(nonatomic) CGFloat qbContentOffsetY;

- (CGPoint)qbTopContentOffset;
- (CGPoint)qbBottoqbontentOffset;
- (CGPoint)qbLeftContentOffset;
- (CGPoint)qbRightContentOffset;
- (QBScrollDirection)qbScrollDirection;
- (BOOL)qbIsScrolledToTop;
- (BOOL)qbIsScrolledToBottom;
- (BOOL)qbIsScrolledToLeft;
- (BOOL)qbIsScrolledToRight;
- (void)qbScrollToTopAnimated:(BOOL)animated;
- (void)qbScrollToBottomAnimated:(BOOL)animated;
- (void)qbScrollToLeftAnimated:(BOOL)animated;
- (void)qbScrollToRightAnimated:(BOOL)animated;
- (NSUInteger)qbVerticalPageIndex;
- (NSUInteger)qbHorizontalPageIndex;
- (void)qbScrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;
- (void)qbScrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
