//
//  UIApplication+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIApplication+QBExtension.h"

@implementation UIApplication (QBExtension)

+ (void)qbOpenURL:(NSString *)URLString completionHandler:(void (^ __nullable)(BOOL success))completion {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:[NSURL URLWithString:URLString]]) {
        if (@available(iOS 10.0, *)) {
            [application openURL:[NSURL URLWithString:URLString] options:@{} completionHandler:completion];
        } else {
            BOOL result = [application openURL:[NSURL URLWithString:URLString]];
            if (completion) {
                completion(result);
            }
        }
    }
}

+ (void)qbOpenSettingsURL:(void (^ __nullable)(BOOL success))completion {
    [[self class] qbOpenURL:UIApplicationOpenSettingsURLString completionHandler:completion];
}

@end
