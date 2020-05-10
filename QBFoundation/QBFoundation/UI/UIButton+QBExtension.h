//
//  UIButton+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (QBExtension)

@property (nonatomic, assign) BOOL qbEventUnavailable;

/** 点击时间响应时间间隔 */
@property (nonatomic, assign) NSTimeInterval qbEventInterval;

/**
 设置按钮额外热区
 */
@property (nonatomic, assign) UIEdgeInsets qbTouchAreaInsets;

/**
 设置按钮额外热区

 @param edge 边缘大小
 */
- (void)setQbTouchAreaEdge:(CGFloat)edge;

@end

NS_ASSUME_NONNULL_END
