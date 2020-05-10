//
//  NSIndexPath+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (QBExtension)

#pragma mark - Common
+ (NSIndexPath *)qbIndexPathWithView:(UIView *)subview inTableView:(UITableView *)tableView;

#pragma mark - Offset
/**
 前一行

 @return NSIndexPath
 */
- (NSIndexPath *)qbPreviousRow;

/**
 下一行

 @return NSIndexPath
 */
- (NSIndexPath *)qbNextRow;

/**
 前一项

 @return NSIndexPath
 */
- (NSIndexPath *)qbPreviousItem;

/**
 下一项

 @return NSIndexPath
 */
- (NSIndexPath *)qbNextItem;


@end

NS_ASSUME_NONNULL_END
