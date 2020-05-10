//
//  UIScrollView+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIScrollView+QBExtension.h"

@implementation UIScrollView (QBExtension)

#pragma mark - Pages
- (NSInteger)qbPages {
    NSInteger pages = self.contentSize.width / self.frame.size.width;
    return pages;
}

- (NSInteger)qbCurrentPage {
    NSInteger pages = self.contentSize.width / self.frame.size.width;
    CGFloat scrollPercent = [self qbScrollPercent];
    NSInteger currentPage = (NSInteger)roundf((pages-1) * scrollPercent);
    return currentPage;
}

- (CGFloat)qbScrollPercent {
    CGFloat width = self.contentSize.width - self.frame.size.width;
    CGFloat scrollPercent = self.contentOffset.x / width;
    return scrollPercent;
}

- (CGFloat)qbPagesY {
    CGFloat pageHeight = self.frame.size.height;
    CGFloat contentHeight = self.contentSize.height;
    return contentHeight / pageHeight;
}

- (CGFloat)qbPagesX {
    CGFloat pageWidth = self.frame.size.width;
    CGFloat contentWidth = self.contentSize.width;
    return contentWidth / pageWidth;
}

- (CGFloat)qbCurrentPageY {
    CGFloat pageHeight = self.frame.size.height;
    CGFloat offsetY = self.contentOffset.y;
    return offsetY / pageHeight;
}

- (CGFloat)qbCurrentPageX {
    CGFloat pageWidth = self.frame.size.width;
    CGFloat offsetX = self.contentOffset.x;
    return offsetX / pageWidth;
}

- (void)qbSetPageY:(CGFloat)page {
    [self qbSetPageY:page animated:NO];
}

- (void)qbSetPageX:(CGFloat)page {
    [self qbSetPageX:page animated:NO];
}

- (void)qbSetPageY:(CGFloat)page animated:(BOOL)animated {
    CGFloat pageHeight = self.frame.size.height;
    CGFloat offsetY = page * pageHeight;
    CGFloat offsetX = self.contentOffset.x;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self setContentOffset:offset];
}

- (void)qbSetPageX:(CGFloat)page animated:(BOOL)animated {
    CGFloat pageWidth = self.frame.size.width;
    CGFloat offsetY = self.contentOffset.y;
    CGFloat offsetX = page * pageWidth;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self setContentOffset:offset animated:animated];
}

#pragma mark - ZoomToPoint //放大某一点
- (void)qbZoomToPoint:(CGPoint)zoomPoint scale:(CGFloat)scale animated:(BOOL)animated {
    //Normalize current content size back to content scale of 1.0f
    CGSize contentSize = CGSizeZero;
    
    contentSize.width = (self.contentSize.width / self.zoomScale);
    contentSize.height = (self.contentSize.height / self.zoomScale);
    
    //translate the zoom point to relative to the content rect
    //jimneylee add compare contentsize with bounds's size
    if (self.contentSize.width < self.bounds.size.width) {
        zoomPoint.x = (zoomPoint.x / self.bounds.size.width) * contentSize.width;
    } else {
        zoomPoint.x = (zoomPoint.x / self.contentSize.width) * contentSize.width;
    }
    if (self.contentSize.height < self.bounds.size.height) {
        zoomPoint.y = (zoomPoint.y / self.bounds.size.height) * contentSize.height;
    } else {
        zoomPoint.y = (zoomPoint.y / self.contentSize.height) * contentSize.height;
    }
    
    //derive the size of the region to zoom to
    CGSize zoomSize = CGSizeZero;
    zoomSize.width = self.bounds.size.width / scale;
    zoomSize.height = self.bounds.size.height / scale;
    
    //offset the zoom rect so the actual zoom point is in the middle of the rectangle
    CGRect zoomRect = CGRectZero;
    zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0f;
    zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0f;
    zoomRect.size.width = zoomSize.width;
    zoomRect.size.height = zoomSize.height;
    
    //apply the resize
    [self zoomToRect: zoomRect animated: animated];
}

#pragma mark - Content
- (CGFloat)qbContentWidth {
    return self.contentSize.width;
}

- (void)setQbContentWidth:(CGFloat)qbContentWidth {
    CGSize currentSize = self.contentSize;
    if (currentSize.width != qbContentWidth) {
        currentSize.width = qbContentWidth;
        self.contentSize = currentSize;
    }
}

- (CGFloat)qbContentHeight {
    return self.contentSize.height;
}

- (void)setQbContentHeight:(CGFloat)qbContentHeight {
    CGSize currentSize = self.contentSize;
    if (currentSize.height != qbContentHeight) {
        currentSize.height = qbContentHeight;
        self.contentSize = currentSize;
    }
}

- (CGFloat)qbContentOffsetX {
    return self.contentOffset.x;
}

- (void)setQbContentOffsetX:(CGFloat)qbContentOffsetX {
    CGPoint currentOffset = self.contentOffset;
    if (currentOffset.x != qbContentOffsetX) {
        currentOffset.x = qbContentOffsetX;
        self.contentOffset = currentOffset;
    }
}

- (CGFloat)qbContentOffsetY {
    return self.contentOffset.y;
}

- (void)setQbContentOffsetY:(CGFloat)qbContentOffsetY {
    CGPoint currentOffset = self.contentOffset;
    if (currentOffset.y != qbContentOffsetY) {
        currentOffset.y = qbContentOffsetY;
        self.contentOffset = currentOffset;
    }
}

- (CGPoint)qbTopContentOffset {
    return CGPointMake(0.0f, - self.contentInset.top);
}

- (CGPoint)qbBottoqbontentOffset {
    return CGPointMake(0.0f, self.contentSize.height + self.contentInset.bottom - self.bounds.size.height);
}

- (CGPoint)qbLeftContentOffset {
    return CGPointMake(- self.contentInset.left, 0.0f);
}

- (CGPoint)qbRightContentOffset {
    return CGPointMake(self.contentSize.width + self.contentInset.right - self.bounds.size.width, 0.0f);
}

- (QBScrollDirection)qbScrollDirection {
    QBScrollDirection direction;
    
    if ([self.panGestureRecognizer translationInView:self.superview].y > 0.0f) {
        direction = QBScrollDirectionUp;
    } else if ([self.panGestureRecognizer translationInView:self.superview].y < 0.0f) {
        direction = QBScrollDirectionDown;
    } else if ([self.panGestureRecognizer translationInView:self].x < 0.0f) {
        direction = QBScrollDirectionLeft;
    } else if ([self.panGestureRecognizer translationInView:self].x > 0.0f) {
        direction = QBScrollDirectionRight;
    } else {
        direction = QBScrollDirectionWTF;
    }
    
    return direction;
}

- (BOOL)qbIsScrolledToTop {
    return self.contentOffset.y <= [self qbTopContentOffset].y;
}

- (BOOL)qbIsScrolledToBottom {
    return self.contentOffset.y >= [self qbBottoqbontentOffset].y;
}

- (BOOL)qbIsScrolledToLeft {
    return self.contentOffset.x <= [self qbLeftContentOffset].x;
}

- (BOOL)qbIsScrolledToRight {
    return self.contentOffset.x >= [self qbRightContentOffset].x;
}

- (void)qbScrollToTopAnimated:(BOOL)animated {
    [self setContentOffset:[self qbTopContentOffset] animated:animated];
}

- (void)qbScrollToBottomAnimated:(BOOL)animated {
    [self setContentOffset:[self qbBottoqbontentOffset] animated:animated];
}

- (void)qbScrollToLeftAnimated:(BOOL)animated {
    [self setContentOffset:[self qbLeftContentOffset] animated:animated];
}

- (void)qbScrollToRightAnimated:(BOOL)animated {
    [self setContentOffset:[self qbRightContentOffset] animated:animated];
}

- (NSUInteger)qbVerticalPageIndex {
    return (self.contentOffset.y + (self.frame.size.height * 0.5f)) / self.frame.size.height;
}

- (NSUInteger)qbHorizontalPageIndex {
    return (self.contentOffset.x + (self.frame.size.width * 0.5f)) / self.frame.size.width;
}

- (void)qbScrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(0.0f, self.frame.size.height * pageIndex) animated:animated];
}

- (void)qbScrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.frame.size.width * pageIndex, 0.0f) animated:animated];
}


@end
