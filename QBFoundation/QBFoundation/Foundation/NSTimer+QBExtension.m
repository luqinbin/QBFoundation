//
//  NSTimer+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/9.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSTimer+QBExtension.h"
#import <objc/runtime.h>

@implementation NSTimer (QBExtension)

+ (NSTimer *)qbScheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats {
    void (^block)(void) = [inBlock copy];
    NSTimer *ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(_executeSimpleBlock:) userInfo:block repeats:inRepeats];
    
    return ret;
}

+ (NSTimer *)qbTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)(void))inBlock repeats:(BOOL)inRepeats {
    void (^block)(void) = [inBlock copy];
    NSTimer * ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(_executeSimpleBlock:) userInfo:block repeats:inRepeats];
    
    return ret;
}

+ (void)_executeSimpleBlock:(NSTimer *)inTimer {
    if ([inTimer userInfo]) {
        void (^block)(void) = (void (^)(void))[inTimer userInfo];
        block();
    }
}

@end
