//
//  UITextField+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (QBExtension)

#pragma mark - Select
/**
 设置选定的所有文本
 */
- (void)qbSelectAllText;

/**
 设置选定范围内的文本

 @param range 文档中选定文本的范围
 */
- (void)qbSetSelectedRange:(NSRange)range;

/**
 当前选中的字符串范围

 @return NSRange
 */
- (NSRange)qbSelectedRange;

/**
 限制字符长度

 @param length 长度
 */
- (void)limitTextLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
