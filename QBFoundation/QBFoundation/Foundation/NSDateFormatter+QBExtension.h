//
//  NSDateFormatter+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (QBExtension)

/**
 返回NSDateFormatter类型对象 单例形式存在

 @return NSDateFormatter
 */
+ (NSDateFormatter *)qbDateFormatter;

+ (NSDateFormatter *)qbDateFormatterWithFormat:(NSString *)aFormat;

+ (NSDateFormatter *)qbDateFormatterWithFormat:(NSString *)aFormat timeZone:(NSTimeZone * _Nullable)aTimeZone;

+ (nullable NSDateFormatter *)qbDateFormatterWithFormat:(NSString *)aFormat timeZone:(NSTimeZone * _Nullable)aTimeZone locale:(NSLocale * _Nullable)aLocale;

+ (NSDateFormatter *)qbDateFormatterWithDateStyle:(NSDateFormatterStyle)aStyle;

+ (NSDateFormatter *)qbDateFormatterWithDateStyle:(NSDateFormatterStyle)aStyle timeZone:(NSTimeZone * _Nullable)aTimeZone;

+ (NSDateFormatter *)qbDateFormatterWithTimeStyle:(NSDateFormatterStyle)aStyle;

+ (NSDateFormatter *)qbDateFormatterWithTimeStyle:(NSDateFormatterStyle)aStyle timeZone:(NSTimeZone * _Nullable)aTimeZone;

@end

NS_ASSUME_NONNULL_END
