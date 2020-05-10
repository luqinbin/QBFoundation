//
//  NSDate+QBExtension.m
//  QBFoundation
//
//  Created by 覃斌 卢    on 2020/5/10.
//  Copyright © 2020 覃斌 卢   . All rights reserved.
//

#import "NSDate+QBExtension.h"
#import "NSCalendar+QBExtension.h"
#import "NSDateFormatter+QBExtension.h"

@implementation NSDate (QBExtension)

#pragma mark - Comparison Day
- (BOOL)qbIsToday {
    return [self qbIsEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)qbIsTomorrow {
    return [self qbIsEqualToDateIgnoringTime:[NSDate qbDateTomorrow]];
}

- (BOOL)qbIsYesterday {
    return [self qbIsEqualToDateIgnoringTime:[NSDate qbDateYesterday]];
}

- (BOOL)qbIsSameDay:(NSDate *)other {
    NSDateComponents *components1 = [self qbComponents];
    NSDateComponents *components2 = [other qbComponents];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}

#pragma mark - Comparison Week
- (BOOL)qbIsThisWeek {
    return [self qbIsSameWeekAsDate:[NSDate date]];
}

- (BOOL)qbIsNextWeek {
    return [self qbIsSameWeekAsDate:[[NSDate date] qbDateByAddingWeeks:1]];
}

- (BOOL)qbIsLastWeek {
    return [self qbIsSameWeekAsDate:[[NSDate date] qbDateBySubtractingWeeks:1]];
}

- (BOOL)qbIsSameWeekAsDate:(NSDate *)other {
    /*
     NOTE: Depending on localization, week starts on Monday or Sunday.
     */
    
    NSDateComponents *components1 = [self qbComponents];
    NSDateComponents *components2 = [other qbComponents];
    
    return (([components1 year] == [components2 year]) &&
            ([components1 weekOfYear] == [components2 weekOfYear]));
}

#pragma mark - Comparison Month
- (BOOL)qbIsThisMonth {
    return [self qbIsSameMonth:[NSDate date]];
}

- (BOOL)qbIsNextMonth {
    return [self qbIsSameWeekAsDate:[self qbDateByAddingMonths:1]];
}

- (BOOL)qbIsLastMonth {
    return [self qbIsSameWeekAsDate:[self qbDateBySubtractingMonths:1]];
}

- (BOOL)qbIsSameMonth:(NSDate *)other {
    NSDateComponents *components1 = [self qbComponents];
    NSDateComponents *components2 = [other qbComponents];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]);
}

#pragma mark - Comparison Year
- (BOOL)qbIsThisYear {
    return [self qbIsSameYearAsDate:[NSDate date]];
}

- (BOOL)qbIsNextYear {
    return [self qbIsSameYearAsDate:[[NSDate date] qbDateByAddingYears:1]];
}

- (BOOL)qbIsLastYear {
    return [self qbIsSameYearAsDate:[[NSDate date] qbDateBySubtractingYears:1]];
}

- (BOOL)qbIsSameYearAsDate:(NSDate *)other {
    NSDateComponents *components1 = [self qbComponents];
    NSDateComponents *components2 = [other qbComponents];
    
    return ([components1 year] == [components2 year]);
}

- (BOOL)qbIsLeapYear {
    NSUInteger year = [self qbYear];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Comparison Workday
- (BOOL)qbIsTypicallyWorkday {
    return ![self qbIsTypicallyWorkend];
}

#pragma mark - Comparison Workend
- (BOOL)qbIsTypicallyWorkend {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:[NSCalendar qbWeekdayUnit]
                                               fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

#pragma mark - EarlierThan
- (BOOL)qbIsEarlierThanDate:(NSDate *)other {
    return ([self compare:other] == NSOrderedAscending);
}

- (BOOL)qbIsInFuture {
    return ([self qbIsEarlierThanDate:[NSDate date]]);
}

#pragma mark - LaterThan
- (BOOL)qbIsLaterThanDate:(NSDate *)other {
    return ([self compare:other] == NSOrderedDescending);
}

- (BOOL)qbIsInPast {
    return ([self qbIsLaterThanDate:[NSDate date]]);
}

- (BOOL)qbIsEqualToDateIgnoringTime:(NSDate *)other {
    NSDateComponents *components1 = [self qbComponents];
    NSDateComponents *components2 = [other qbComponents];
    
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]) &&
            ([components1 day] == [components2 day]));
}

- (NSUInteger)qbDaysInYear {
    return [self qbIsLeapYear] ? 366 : 365;
}

- (NSUInteger)qbDayOfYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar ordinalityOfUnit:[NSCalendar qbDayUnit] inUnit:[NSCalendar qbYearUnit] forDate:self];
}

#pragma mark - Components
- (NSInteger)qbYear {
    return [[self qbComponents] year];
}

- (NSInteger)qbMonth {
    return [[self qbComponents] month];
}

- (NSInteger)qbWeekOfMonth {
    return [[self qbComponents] weekOfMonth];
}

- (NSInteger)qbWeekOfYear {
    return [[self qbComponents] weekOfYear];
}

- (NSInteger)qbWeekday {
    /*
     NOTE: Depending on localization, week starts on Monday or Sunday.
     */
    return [[self qbComponents] weekday];
}

- (NSInteger)qbNthWeekday {
    return [[self qbComponents] weekdayOrdinal];
}

- (NSInteger)qbDay {
    return [[self qbComponents] day];
}

- (NSInteger)qbHour {
    return [[self qbComponents] hour];
}

- (NSInteger)qbMinutes {
    return [[self qbComponents] minute];
}

- (NSInteger)qbSeconds {
    return [[self qbComponents] second];
}

- (NSInteger)qbEra {
    return [[self qbComponents] era];
}

- (NSDateComponents *)qbComponents {
    return [[NSCalendar currentCalendar] components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
}

#pragma mark - creation
+ (NSDate *)qbDateTomorrow {
    return [[NSDate date] qbDateByAddingDays:1];
}

+ (NSDate *)qbDateYesterday {
    return [[NSDate date] qbDateBySubtractingDays:1];
}

+ (NSDate *)qbDateWithoutTime {
    return [[NSDate date] qbDateWithoutTime];
}

+ (NSDate *)qbDateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] qbDateByAddingDays:days];
}

+ (NSDate *)qbDateFromString:(NSString *)string {
    return [self qbDateFromString:string withFormat:[NSDate qbDateFormatDDMMYYYYDashed]];
}

+ (nullable NSDate *)qbDateFromString:(NSString *)string withFormat:(NSString *)format {
    if ((NSNull *)string == [NSNull null] || string == nil || [string isEqualToString:@""]) {
        return nil;
    }
    
    if (format == nil) {
        format = [NSDate qbDateFormatDDMMYYYYDashed];
    }
    
    NSDateFormatter *formatter = [NSDateFormatter qbDateFormatter];
    [formatter setDateFormat:format];
    NSDate *result = [formatter dateFromString:string];
    
    return result;
}

- (NSDate *)qbDateWithoutTime {
    NSString *formattedString = [self qbFormattedString];
    
    NSDateFormatter *formatter = [NSDateFormatter qbDateFormatter];
    [formatter setDateFormat:[NSDate qbDateFormatDDMMYYYYDashed]];
    NSDate *result = [formatter dateFromString:formattedString];
    
    return result;
}

#pragma mark - Formatting
+ (NSString *)qbDateFormatCCCCDDMMMYYYY {
    return @"cccc, dd MMM yyyy";
}

+ (NSString *)qbDateFormatCCCCDDMMMMYYYY {
    return @"cccc, dd MMMM yyyy";
}

+ (NSString *)qbDateFormatDDMMMYYYY {
    return @"dd MMM yyyy";
}

+ (NSString *)qbDateFormatDDMMYYYYDashed {
    return @"dd-MM-yyyy";
}

+ (NSString *)qbDateFormatDDMMYYYYSlashed {
    return @"dd/MM/yyyy";
}

+ (NSString *)qbDateFormatDDMMMYYYYSlashed {
    return @"dd/MMM/yyyy";
}

+ (NSString *)qbDateFormatMMMDDYYYY {
    return @"MMM dd, yyyy";
}

+ (NSString *)qbDateFormatYYYYMMDDDashed {
    return @"yyyy-MM-dd";
}

- (NSString *)qbFormattedString {
    return [self qbFormattedStringUsingFormat:[NSDate qbDateFormatDDMMYYYYDashed]];
}

- (NSString *)qbFormattedStringUsingFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [NSDateFormatter qbDateFormatterWithFormat:dateFormat];
    return [formatter stringFromDate:self];
}

#pragma mark - Manipulation
- (NSDate *)qbDateByAddingDays:(NSInteger)days {
    return [self _qbDateByAdding:days ofUnit:NSCalendarUnitDay];
}

- (NSDate *)qbDateByAddingWeeks:(NSInteger)weeks {
    return [self qbDateByAddingDays:(weeks * 7)];
}

- (NSDate *)qbDateByAddingMonths:(NSInteger)months {
    return [self _qbDateByAdding:months ofUnit:NSCalendarUnitMonth];
}

- (NSDate *)qbDateByAddingYears:(NSInteger)years {
    return [self _qbDateByAdding:years ofUnit:NSCalendarUnitYear];
}

- (NSDate *)qbDateByAddingHours:(NSInteger)hours {
    return [self _qbDateByAdding:hours ofUnit:NSCalendarUnitHour];
}

- (NSDate *)qbDateByAddingMinutes:(NSInteger)minutes {
    return [self _qbDateByAdding:minutes ofUnit:NSCalendarUnitMinute];
}

- (NSDate *)qbDateByAddingSeconds:(NSInteger)seconds {
    return [self _qbDateByAdding:seconds ofUnit:NSCalendarUnitSecond];
}

- (NSDate *)qbDateBySubtractingDays:(NSInteger)days {
    return [self _qbDateByAdding:-days ofUnit:NSCalendarUnitDay];
}

- (NSDate *)qbDateBySubtractingWeeks:(NSInteger)weeks {
    return [self qbDateByAddingDays:- (weeks * 7)];
}

- (NSDate *)qbDateBySubtractingMonths:(NSInteger)months {
    return [self _qbDateByAdding:- months ofUnit:NSCalendarUnitMonth];
}

- (NSDate *)qbDateBySubtractingYears:(NSInteger)years {
    return [self _qbDateByAdding:- years ofUnit:NSCalendarUnitYear];
}

- (NSDate *)qbDateBySubtractingHours:(NSInteger)hours {
    return [self _qbDateByAdding:- hours ofUnit:NSCalendarUnitHour];
}

- (NSDate *)qbDateBySubtractingMinutes:(NSInteger)minutes {
    return [self _qbDateByAdding:- minutes ofUnit:NSCalendarUnitMinute];
}

- (NSDate *)qbDateBySubtractingSeconds:(NSInteger)seconds {
    return [self _qbDateByAdding:- seconds ofUnit:NSCalendarUnitSecond];
}

- (NSDate *)_qbDateByAdding:(NSInteger)value ofUnit:(NSCalendarUnit)unit {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    switch (unit) {
        case NSCalendarUnitYear:
            [components setYear:value];
            break;
        case NSCalendarUnitMonth:
            [components setMonth:value];
            break;
        case NSCalendarUnitDay:
            [components setDay:value];
            break;
        case NSCalendarUnitHour:
            [components setHour:value];
            break;
        case NSCalendarUnitMinute:
            [components setMinute:value];
            break;
        case NSCalendarUnitSecond:
            [components setSecond:value];
            break;
        default:
            break;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateByAddingComponents:components toDate:self options:0];
    return date;
}

- (NSInteger)qbDifferenceInDaysToDate:(NSDate *)toDate {
    return [self _qbDifferenceInUnit:NSCalendarUnitDay toDate:toDate];
}

- (NSInteger)qbDifferenceInMonthsToDate:(NSDate *)toDate {
    return [self _qbDifferenceInUnit:NSCalendarUnitMonth toDate:toDate];
}

- (NSInteger)qbDifferenceInYearsToDate:(NSDate *)toDate {
    return [self _qbDifferenceInUnit:NSCalendarUnitYear toDate:toDate];
}

- (NSInteger)qbDifferenceInHoursToDate:(NSDate *)toDate {
    return [self _qbDifferenceInUnit:NSCalendarUnitHour toDate:toDate];
}

- (NSInteger)qbDifferenceInMinutesToDate:(NSDate *)toDate {
    return [self _qbDifferenceInUnit:NSCalendarUnitMinute toDate:toDate];
}

- (NSInteger)qbDifferenceInSecondsToDate:(NSDate *)toDate {
    return [self _qbDifferenceInUnit:NSCalendarUnitSecond toDate:toDate];
}

- (NSInteger)_qbDifferenceInUnit:(NSCalendarUnit)unit toDate:(NSDate *)toDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unit
                                               fromDate:self toDate:toDate options:0];
    
    switch (unit) {
        case NSCalendarUnitYear:
            return [components year];
            break;
        case NSCalendarUnitMonth:
            return [components month];
            break;
        case NSCalendarUnitDay:
            return [components day];
            break;
        case NSCalendarUnitHour:
            return [components hour];
            break;
        case NSCalendarUnitMinute:
            return [components minute];
            break;
        case NSCalendarUnitSecond:
            return [components second];
            break;
        default:
            return [components year];
            break;
    }
}

#pragma mark - TimeStamp
+ (double)qbCurrentDateTimeStamp {
    return [[NSDate date] timeIntervalSince1970];
}

+ (UInt64)qbCurrentDateMillisecondTimeStamp {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}




@end
