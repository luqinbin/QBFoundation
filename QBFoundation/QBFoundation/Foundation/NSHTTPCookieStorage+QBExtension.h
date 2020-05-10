//
//  NSHTTPCookieStorage+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSHTTPCookieStorage (QBExtension)

#pragma mark - FreezeDry
/**
 保存cookie到指定路径

 @param path 路径
 */
- (void)qbSaveCookieWithFilePath:(NSString *)path;

/**
 从指定路径读取cookie

 @param path 路径
 */
- (void)qbReadCookieWithFilePath:(NSString *)path;

/**
 清理http cookies
 */
+ (void)qbDeleteCookie;

@end

NS_ASSUME_NONNULL_END
