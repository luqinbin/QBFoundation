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
+ (NSString *)qbBundleShortVersionString;

/// CFBundleVersion
+ (NSString *)qbBundleVersion;

/// CFBundleName
+ (NSString *)qbBundleName;

/// CFBundleIdentifier
+ (NSString *)qbBundleIdentifier;

/// CFBundleDisplayName
+ (NSString *)qbBundleDisplayName;

@end

NS_ASSUME_NONNULL_END
