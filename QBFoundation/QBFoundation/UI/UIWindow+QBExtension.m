//
//  UIWindow+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/4.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIWindow+QBExtension.h"

@implementation UIWindow (QBExtension)

+ (NSArray<UIWindow *> *)getLevelNormalWindow {
    NSMutableArray *normalWindows = [NSMutableArray arrayWithCapacity:1];
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *tempWindow in windows) {
        if (tempWindow.windowLevel == UIWindowLevelNormal) {
            [normalWindows addObject:tempWindow];
        }
    }
                     
    return normalWindows;
}

@end
