//
//  NSBundle+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (QBExtension)

/// CFBundleShortVersionString
+ (NSString *)bundleShortVersionString;

/// CFBundleVersion
+ (NSString *)bundleVersion;

/// CFBundleName
+ (NSString *)bundleName;

/// CFBundleIdentifier
+ (NSString *)bundleIdentifier;

/// CFBundleDisplayName
+ (NSString *)bundleDisplayName;

@end

NS_ASSUME_NONNULL_END
