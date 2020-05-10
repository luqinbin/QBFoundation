//
//  NSDateFormatter+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSDateFormatter+QBExtension.h"
#import "NSString+QBExtension.h"

@implementation NSDateFormatter (QBExtension)

+ (NSDateFormatter *)qbDateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}

+ (NSDateFormatter *)qbDateFormatterWithFormat:(NSString *)aFormat {
    return [self qbDateFormatterWithFormat:aFormat timeZone:nil];
}

+ (NSDateFormatter *)qbDateFormatterWithFormat:(NSString *)aFormat timeZone:(NSTimeZone * _Nullable)aTimeZone {
    return [self qbDateFormatterWithFormat:aFormat timeZone:aTimeZone locale:nil];
}

+ (nullable NSDateFormatter *)qbDateFormatterWithFormat:(NSString *)aFormat timeZone:(NSTimeZone * _Nullable)aTimeZone locale:(NSLocale * _Nullable)aLocale {
    if ([NSString qbIsEmpty:aFormat]) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [self qbDateFormatter];
    [dateFormatter setDateFormat:aFormat];
    if (aTimeZone && ([aTimeZone isKindOfClass:[NSTimeZone class]])) {
        [dateFormatter setTimeZone:aTimeZone]; // this may change
    }
    if (aLocale && ([aLocale isKindOfClass:[NSLocale class]])) {
        [dateFormatter setLocale:aLocale]; // this may change so don't cache
    }
    return dateFormatter;
}

+ (NSDateFormatter *)qbDateFormatterWithDateStyle:(NSDateFormatterStyle)aStyle {
    return [self qbDateFormatterWithDateStyle:aStyle timeZone:nil];
}

+ (NSDateFormatter *)qbDateFormatterWithDateStyle:(NSDateFormatterStyle)aStyle timeZone:(NSTimeZone * _Nullable)aTimeZone {
    NSDateFormatter *dateFormatter = [self qbDateFormatter];
    [dateFormatter setDateStyle:aStyle];
    if (aTimeZone && ([aTimeZone isKindOfClass:[NSTimeZone class]])) {
        [dateFormatter setTimeZone:aTimeZone]; // this may change
    }
    return dateFormatter;
}

+ (NSDateFormatter *)qbDateFormatterWithTimeStyle:(NSDateFormatterStyle)aStyle {
    return [self qbDateFormatterWithTimeStyle:aStyle timeZone:nil];
}

+ (NSDateFormatter *)qbDateFormatterWithTimeStyle:(NSDateFormatterStyle)aStyle timeZone:(NSTimeZone * _Nullable)aTimeZone {
    NSDateFormatter *dateFormatter = [self qbDateFormatter];
    [dateFormatter setDateStyle:aStyle];
    if (aTimeZone && ([aTimeZone isKindOfClass:[NSTimeZone class]])) {
        [dateFormatter setTimeZone:aTimeZone]; // this may change
    }
    return dateFormatter;
}

@end
