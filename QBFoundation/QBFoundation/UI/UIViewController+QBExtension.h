//
//  UIViewController+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (QBExtension)

- (nullable UIViewController *)qbFindViewController:(NSString *)className;
- (void)qbRemoveViewController:(NSString *)className complete:(void (^ _Nullable)(void))complete;

@end

NS_ASSUME_NONNULL_END
