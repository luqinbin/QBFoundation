//
//  NSBundle+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSBundle+QBExtension.h"

@implementation NSBundle (QBExtension)

+ (NSString *)qbBundleShortVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)qbBundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)qbBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)qbBundleIdentifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)qbBundleDisplayName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

@end
