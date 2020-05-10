//
//  UIViewController+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "UIViewController+QBExtension.h"
#import "NSString+QBExtension.h"

@implementation UIViewController (QBExtension)

- (nullable UIViewController *)qbFindViewController:(NSString *)className {
    if ([NSString qbIsEmpty:className]) {
        return nil;
    }
    
    Class class = NSClassFromString(className);
    if (!class) {
        return nil;
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:class]) {
            return controller;
        }
    }
    return nil;
}

- (void)qbRemoveViewController:(NSString *)className complete:(void (^ _Nullable)(void))complete {
    if ([NSString qbIsEmpty:className]) {
        return;
    }
    
    Class class = NSClassFromString(className);
    if (!class) {
        return;
    }
    
    __kindof NSMutableArray<UIViewController *> *controllers = [self.navigationController.viewControllers mutableCopy];
    for (UIViewController *viewController in controllers) {
        if ([viewController isKindOfClass:class]) {
            [controllers removeObject:viewController];
            self.navigationController.viewControllers = [controllers copy];
            if (complete) {
                complete();
            }
            return;
        }
    }
}

@end
