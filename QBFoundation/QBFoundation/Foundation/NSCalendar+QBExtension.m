//
//  NSCalendar+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSCalendar+QBExtension.h"

@implementation NSCalendar (QBExtension)

+ (NSCalendarUnit)qbCompareHourUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour);
#else
    NSCalendarUnit unitFlags = (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbCompareDayUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
#else
    NSCalendarUnit unitFlags = (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbCompareMonthUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth);
#else
    NSCalendarUnit unitFlags = (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)srCompareYearUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitEra | NSCalendarUnitYear);
#else
    NSCalendarUnit unitFlags = (NSEraCalendarUnit | NSYearCalendarUnit);
#endif
    return unitFlags;
}

//(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday)
+ (NSCalendarUnit)qbCompareWeekdayUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday);
#else
    NSCalendarUnit unitFlags = (NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbWeekdayUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitWeekday);
#else
    NSCalendarUnit unitFlags = (NSWeekdayCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbWeekOfMonth {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitWeekOfMonth);
#else
    NSCalendarUnit unitFlags = (NSWeekOfMonthCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbWeekOfYear {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitWeekOfYear);
#else
    NSCalendarUnit unitFlags = (NSWeekOfYearCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbEraUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitEra);
#else
    NSCalendarUnit unitFlags = (NSEraCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbYearUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitYear);
#else
    NSCalendarUnit unitFlags = (NSYearCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbMonthUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitMonth);
#else
    NSCalendarUnit unitFlags = (NSMonthCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbDayUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitDay);
#else
    NSCalendarUnit unitFlags = (NSDayCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbHourUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitHour);
#else
    NSCalendarUnit unitFlags = (NSHourCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbMinuteUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitMinute);
#else
    NSCalendarUnit unitFlags = (NSMinuteCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbSecondUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitSecond);
#else
    NSCalendarUnit unitFlags = (NSSecondCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendarUnit)qbQuarterUnit {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSCalendarUnit unitFlags = (NSCalendarUnitQuarter);
#else
    NSCalendarUnit unitFlags = (NSQuarterCalendarUnit);
#endif
    return unitFlags;
}

+ (NSCalendar *)qbGregorianCalendar {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    return gregorian;
}

@end
