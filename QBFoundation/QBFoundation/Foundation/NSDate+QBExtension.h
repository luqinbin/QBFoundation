//
//  NSDate+QBExtension.h
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (QBExtension)

#pragma mark - Comparison Day
/**
 是否为今天

 @return BOOL
 */
- (BOOL)qbIsToday;

/**
 是否为明天

 @return BOOL
 */
- (BOOL)qbIsTomorrow;

/**
 是否为昨天

 @return BOOL
 */
- (BOOL)qbIsYesterday;

/**
 是否与其他日期为同一天

 @param other 其他日期
 @return BOOL
 */
- (BOOL)qbIsSameDay:(NSDate *)other;

#pragma mark - Comparison Week
/**
 是否为本周

 @return BOOL
 */
- (BOOL)qbIsThisWeek;

/**
 是否为下周

 @return BOOL
 */
- (BOOL)qbIsNextWeek;

/**
 是否为上周

 @return BOOL
 */
- (BOOL)qbIsLastWeek;

/**
 是否与其他日期为同一周

 @param other 其他日期
 @return BOOL
 */
- (BOOL)qbIsSameWeekAsDate:(NSDate *)other;

#pragma mark - Comparison Month
/**
 是否为当月

 @return BOOL
 */
- (BOOL)qbIsThisMonth;

/**
 是否为下个月

 @return BOOL
 */
- (BOOL)qbIsNextMonth;

/**
 是否为上个月

 @return BOOL
 */
- (BOOL)qbIsLastMonth;

/**
 是否与其他日期同一个月

 @param other 其他日期
 @return BOOL
 */
- (BOOL)qbIsSameMonth:(NSDate *)other;

#pragma mark - Comparison Year
/**
 是否为今年

 @return BOOL
 */
- (BOOL)qbIsThisYear;

/**
 是否为下一年

 @return BOOL
 */
- (BOOL)qbIsNextYear;

/**
 是否为去年

 @return BOOL
 */
- (BOOL)qbIsLastYear;

/**
 是否与其他日期为同一年

 @param other 其他日期
 @return BOOL
 */
- (BOOL)qbIsSameYearAsDate:(NSDate *)other;

/**
 判断当前日期是否为闰年

 @return BOOL
 */
- (BOOL)qbIsLeapYear;

#pragma mark - Comparison Workday
/**
 判断当前日期是否为工作日

 @return BOOL
 */
- (BOOL)qbIsTypicallyWorkday;

#pragma mark - Comparison Workend
/**
 判断当前日期是否为周末

 @return BOOL
 */
- (BOOL)qbIsTypicallyWorkend;

#pragma mark - EarlierThan
/**
 是否比其他日期早

 @param other 其他日期
 @return BOOL
 */
- (BOOL)qbIsEarlierThanDate:(NSDate *)other;

/**
 判断日期是否在将来

 @return BOOL
 */
- (BOOL)qbIsInFuture;

#pragma mark -
#pragma mark LaterThan
/**
 是否比其他日期晚

 @param other 其他日期
 @return BOOL
 */
- (BOOL)qbIsLaterThanDate:(NSDate *)other;

/**
 判断日期是否在过去

 @return BOOL
 */
- (BOOL)qbIsInPast;

/**
 忽略时间 与其他日期是否相同 只比较年月日

 @param other 其他日期
 @return BOOL
 */
- (BOOL)qbIsEqualToDateIgnoringTime:(NSDate *)other;

/**
 判断当前日期所在年份有多少天

 @return NSUInteger
 */
- (NSUInteger)qbDaysInYear;

/**
 判断当前日期在当前年份中的第几天

 @return NSUInteger
 */
- (NSUInteger)qbDayOfYear;

#pragma mark - Components
/**
 当前日期的年

 @return NSInteger
 */
- (NSInteger)qbYear;

/**
 当前日期的月

 @return NSInteger
 */
- (NSInteger)qbMonth;

/**
 当前日期的当月的第几周

 @return NSInteger
 */
- (NSInteger)qbWeekOfMonth;

/**
 当前日期在当年的第几周

 @return NSInteger
 */
- (NSInteger)qbWeekOfYear;

/**
 当前日期在当年的所在周的第几天

 @return NSInteger
 */
- (NSInteger)qbWeekday;

/**
 表示当前日期WeekDay在下一个更大的日历单元中的位置。例如WeekDay=3，WeekDayOrdinal=2  就表示这个月的第2个周二。

 @return NSInteger
 */
- (NSInteger)qbNthWeekday;

/**
 当前日期的天

 @return NSInteger
 */
- (NSInteger)qbDay;

/**
 当前日期的小时

 @return NSInteger
 */
- (NSInteger)qbHour;

/**
 当前日期的分钟

 @return NSInteger
 */
- (NSInteger)qbMinutes;

/**
 当前日期的秒

 @return NSInteger
 */
- (NSInteger)qbSeconds;

/**
 当前日期的Era

 @return NSInteger
 */
- (NSInteger)qbEra;

/**
 日期组件

 @return NSDateComponents
 */
- (NSDateComponents *)qbComponents;

#pragma mark Creation
/**
 以当前日期为基准加1天为明天的日期

 @return NSDate
 */
+ (NSDate *)qbDateTomorrow;

/**
 以当前日期为基准加1天为明天的日期

 @return NSDate
 */
+ (NSDate *)qbDateYesterday;

/**
 当前的日期 只包含天月年

 @return NSDate
 */
+ (NSDate *)qbDateWithoutTime;

/**
 从当前日期起后面指定天数的日期

 @param days 天数
 @return NSDate
 */
+ (NSDate *)qbDateWithDaysFromNow:(NSInteger)days;

/**
 把日期格式的字符串转为NSDate

 @param string 日期格式字符串
 @return NSDate
 */
+ (NSDate *)qbDateFromString:(NSString *)string;

/**
 把日期格式的字符串按照指定格式转为NSDate

 @param string 日期格式字符串
 @param format 指定格式
 @return NSDate
 */
+ (nullable NSDate *)qbDateFromString:(NSString *)string withFormat:(NSString *)format;

/**
 获取当前日期去除时间的日期

 @return NSDate
 */
- (NSDate *)qbDateWithoutTime;

#pragma mark - Formatting
/**
 eg：cccc, dd MMM yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatCCCCDDMMMYYYY;

/**
 eg：cccc, dd MMMM yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatCCCCDDMMMMYYYY;

/**
 eg：dd MMM yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatDDMMMYYYY;

/**
 eg：dd-MM-yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatDDMMYYYYDashed;

/**
 eg：dd/MM/yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatDDMMYYYYSlashed;

/**
 eg：dd/MMM/yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatDDMMMYYYYSlashed;

/**
 eg：MMM dd, yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatMMMDDYYYY;

/**
 eg：dd-MM-yyyy

 @return NSString
 */
+ (NSString *)qbDateFormatYYYYMMDDDashed;

/**
 返回当前日期 格式为'dd-MM-yyyy'的字符串

 @return NSString
 */
- (NSString *)qbFormattedString;

/**
 返回当前日期指定格式的字符串

 @param dateFormat 日期格式
 @return NSString
 */
- (NSString *)qbFormattedStringUsingFormat:(NSString *)dateFormat;

#pragma mark - Manipulation
/**
 指定日期后推几天得到的日期

 @param days 后推的天数
 @return NSDate
 */
- (NSDate *)qbDateByAddingDays:(NSInteger)days;

/**
 指定日期后推几周得到的日期

 @param weeks 后推的周数
 @return NSDate
 */
- (NSDate *)qbDateByAddingWeeks:(NSInteger)weeks;

/**
 指定日期后推几个月得到的日期

 @param months 后推的月数
 @return NSDate
 */
- (NSDate *)qbDateByAddingMonths:(NSInteger)months;

/**
 指定日期后推几年得到的日期

 @param years 后推的年数
 @return NSDate
 */
- (NSDate *)qbDateByAddingYears:(NSInteger)years;

/**
 指定日期后推几小时得到的日期

 @param hours 后推的几个小时
 @return NSDate
 */
- (NSDate *)qbDateByAddingHours:(NSInteger)hours;

/**
 指定日期后推几分钟得到的日期

 @param minutes 后推的分钟数
 @return NSDate
 */
- (NSDate *)qbDateByAddingMinutes:(NSInteger)minutes;

/**
 指定日期后推几秒钟得到的日期

 @param seconds 后推的秒钟数
 @return NSDate
 */
- (NSDate *)qbDateByAddingSeconds:(NSInteger)seconds;

/**
 指定日期前推几天的到的日期

 @param days 前推的天数
 @return NSDate
 */
- (NSDate *)qbDateBySubtractingDays:(NSInteger)days;

/**
 指定日期前推几周的得到的日期

 @param weeks 前推的周数
 @return NSDate
 */
- (NSDate *)qbDateBySubtractingWeeks:(NSInteger)weeks;

/**
 指定日期前推几个月得到的日期

 @param months 前推的月数
 @return NSDate
 */
- (NSDate *)qbDateBySubtractingMonths:(NSInteger)months;

/**
 指定日期前推几年得到的日期

 @param years 前推的年数
 @return NSDate
 */
- (NSDate *)qbDateBySubtractingYears:(NSInteger)years;

/**
 指定日期前推几小时得到的日期

 @param hours 前推的小时数
 @return NSDate
 */
- (NSDate *)qbDateBySubtractingHours:(NSInteger)hours;

/**
 指定日期前推几分钟得到的日期

 @param minutes 前推的分钟数
 @return NSDate
 */
- (NSDate *)qbDateBySubtractingMinutes:(NSInteger)minutes;

/**
 指定日期前推几秒钟得到的日期

 @param seconds 前推的秒钟数
 @return NSDate
 */
- (NSDate *)qbDateBySubtractingSeconds:(NSInteger)seconds;

/**
 当前的日期和指定的日期之间相差的天数

 @param toDate 指定的日期
 @return NSInteger
 */
- (NSInteger)qbDifferenceInDaysToDate:(NSDate *)toDate;

/**
 当前的日期和指定的日期之间相差的月数

 @param toDate 指定的日期
 @return NSInteger
 */
- (NSInteger)qbDifferenceInMonthsToDate:(NSDate *)toDate;

/**
 当前的日期和指定的日期之间相差的年数

 @param toDate 指定的日期
 @return NSInteger
 */
- (NSInteger)qbDifferenceInYearsToDate:(NSDate *)toDate;

/**
 当前的日期和指定的日期之间相差的小时数

 @param toDate 指定的日期
 @return NSInteger
 */
- (NSInteger)qbDifferenceInHoursToDate:(NSDate *)toDate;

/**
 当前的日期和指定的日期之间相差的分钟数

 @param toDate 指定的日期
 @return NSInteger
 */
- (NSInteger)qbDifferenceInMinutesToDate:(NSDate *)toDate;

/**
 当前的日期和指定的日期之间相差的秒种数

 @param toDate 指定的日期
 @return NSInteger
 */
- (NSInteger)qbDifferenceInSecondsToDate:(NSDate *)toDate;

#pragma mark - TimeStamp
/**
 当前日期的时间戳

 @return double
 */
+ (double)qbCurrentDateTimeStamp;

/**
 当前日期的毫秒级时间戳

 @return UInt64
 */
+ (UInt64)qbCurrentDateMillisecondTimeStamp;



@end

NS_ASSUME_NONNULL_END
