//
//  NSError+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSError+QBExtension.h"

@implementation NSError (QBExtension)

+ (NSError *)qbErrorWithCode:(NSInteger)aCode {
    NSString *domain = [[NSBundle mainBundle] bundleIdentifier];
    if (!domain) {
        domain = @"com.qb";
    }
    NSError *result = [NSError errorWithDomain:domain
                                          code:aCode
                                      userInfo:nil];
    return result;
}


+ (NSError *)qbErrorWithCode:(NSInteger)aCode
                 description:(NSString *)aDescription {
    NSString *domain = [[NSBundle mainBundle] bundleIdentifier];
    if (!domain) {
        domain = @"com.qb";
    }
    NSError *result = [NSError errorWithDomain:domain
                                          code:aCode
                                      userInfo:@{NSLocalizedDescriptionKey: aDescription}];
    return result;
}

+ (NSError *)qbErrorWithDomain:(NSString *)aDomain
                          code:(NSInteger)aCode
                   description:(NSString *)aDescription {
    NSError *result = [NSError errorWithDomain:aDomain
                                          code:aCode
                                      userInfo:@{NSLocalizedDescriptionKey: aDescription}];
    return result;
}

+ (NSError *)qbErrorWithDomain:(NSString *)aDomain
                          code:(NSInteger)aCode
                   description:(NSString *)aDescription
                 failureReason:(NSString *)aFailureReason {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: aDescription, NSLocalizedFailureReasonErrorKey: aFailureReason};
    NSError *result = [NSError errorWithDomain:aDomain
                                          code:aCode
                                      userInfo:userInfo];
    return result;
}


@end
