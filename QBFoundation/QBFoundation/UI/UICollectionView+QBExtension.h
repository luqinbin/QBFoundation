//
//  UICollectionView+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (QBExtension)

/**
 滑到底部
 
 @param animated 动画
 */
- (void)qbScrollsToBottomAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
