//
//  UITextView+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (QBExtension)

#pragma mark - Select
/**
 当前选中的字符串范围

 @return NSRange
 */
- (NSRange)qbSelectedRange;

/**
 选中所有文字
 */
- (void)qbSelectAllText;

/**
 选中指定范围的文字

 @param range NSRange
 */
- (void)qbSetSelectedRange:(NSRange)range;

/**
 获取文本长度
 用于计算textview输入情况下的字符数，解决实现限制字符数时，计算不准的问题

 @param text text
 @return NSInteger
 */
- (NSInteger)qbGetInputLengthWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
