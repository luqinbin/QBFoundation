//
//  UIApplication+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (QBExtension)

/**
 简化“openURL:options:completionHandler:”

 @param URLString URLString
 @param completion 完成回调
 */
+ (void)qbOpenURL:(NSString *)URLString completionHandler:(void (^ __nullable)(BOOL success))completion;

/**
 打开设置UIApplicationOpenSettingsURLString

 @param completion 完成回调
 */
+ (void)qbOpenSettingsURL:(void (^ __nullable)(BOOL success))completion;


@end

NS_ASSUME_NONNULL_END
