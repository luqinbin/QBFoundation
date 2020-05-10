//
//  NSCalendar+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (QBExtension)

+ (NSCalendarUnit)qbCompareHourUnit;

+ (NSCalendarUnit)qbCompareDayUnit;

+ (NSCalendarUnit)qbCompareMonthUnit;

+ (NSCalendarUnit)srCompareYearUnit;

+ (NSCalendarUnit)qbCompareWeekdayUnit;

+ (NSCalendarUnit)qbWeekdayUnit;

+ (NSCalendarUnit)qbWeekOfMonth;

+ (NSCalendarUnit)qbWeekOfYear;

+ (NSCalendarUnit)qbEraUnit;

+ (NSCalendarUnit)qbYearUnit;

+ (NSCalendarUnit)qbMonthUnit;

+ (NSCalendarUnit)qbDayUnit;

+ (NSCalendarUnit)qbHourUnit;

+ (NSCalendarUnit)qbMinuteUnit;

+ (NSCalendarUnit)qbSecondUnit;

+ (NSCalendarUnit)qbQuarterUnit;

+ (NSCalendar *)qbGregorianCalendar;

@end

NS_ASSUME_NONNULL_END
