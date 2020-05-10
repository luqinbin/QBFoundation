//
//  NSError+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (QBExtension)

+ (NSError *)qbErrorWithCode:(NSInteger)aCode;

+ (NSError *)qbErrorWithCode:(NSInteger)aCode
                 description:(NSString *)aDescription;

+ (NSError *)qbErrorWithDomain:(NSString *)aDomain
                          code:(NSInteger)aCode
                   description:(NSString *)aDescription;

+ (NSError *)qbErrorWithDomain:(NSString *)aDomain
                          code:(NSInteger)aCode
                   description:(NSString *)aDescription
                 failureReason:(NSString *)aFailureReason;

@end

NS_ASSUME_NONNULL_END
