//
//  NSIndexPath+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSIndexPath+QBExtension.h"

@implementation NSIndexPath (QBExtension)

#pragma mark - Common
+ (NSIndexPath *)qbIndexPathWithView:(UIView *)subview inTableView:(UITableView *)tableView {
    CGPoint buttonPosition = [subview convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:buttonPosition];
    return indexPath;
}

#pragma mark - Offset
- (NSIndexPath *)qbPreviousRow {
    return [NSIndexPath indexPathForRow:self.row - 1 inSection:self.section];
}

- (NSIndexPath *)qbNextRow {
    return [NSIndexPath indexPathForRow:self.row + 1 inSection:self.section];
}

- (NSIndexPath *)qbPreviousItem {
    return [NSIndexPath indexPathForItem:self.item - 1 inSection:self.section];
}

- (NSIndexPath *)qbNextItem {
    return [NSIndexPath indexPathForItem:self.item + 1 inSection:self.section];
}


@end
