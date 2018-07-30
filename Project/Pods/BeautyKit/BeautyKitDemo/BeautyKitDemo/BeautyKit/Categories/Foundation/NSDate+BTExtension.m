//
//  NSDate+BTExtension.m
//  BTExtension
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 BTExtension. All rights reserved.
//

#import "NSDate+BTExtension.h"

static const unsigned componentFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
/**
 相关ISO8601规则详见 http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 */
static NSString * const kISO8601DateFormatter = @"EEE, d MMM yyyy HH:mm:ss Z";
static NSString * const kDefaultDateFormatter = @"YYYY-MM-dd";

@implementation NSDate (BTExtension)
    
- (NSDateComponents *)union_components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:componentFlags fromDate:self];
}
    
- (NSDate *)union_dateByAddingUnit:(NSCalendarUnit)unit withOffset:(NSInteger)offset {
    NSDateComponents *compo = [[NSDateComponents alloc] init];
    [compo setValue:offset forComponent:unit];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:compo toDate:self options:0];
}
    
- (NSDate *)union_dateByAddingDays:(NSInteger)days {
    return [self union_dateByAddingUnit:NSCalendarUnitDay withOffset:days];
}
    
- (NSDate *)union_dateByAddingMonths:(NSInteger)months {
    return [self union_dateByAddingUnit:NSCalendarUnitMonth withOffset:months];
}
    
- (NSDate *)union_dateByAddingYears:(NSInteger)years {
    return [self union_dateByAddingUnit:NSCalendarUnitYear withOffset:years];
}
    
+ (NSDate *)union_yesterday {
    return [[NSDate date] union_dateByAddingUnit:NSCalendarUnitDay withOffset:-1];
}
    
+ (NSDate *)union_tomorrow {
    return [[NSDate date] union_dateByAddingUnit:NSCalendarUnitDay withOffset:1];
}
    
- (NSString *)union_weekend {
    NSDictionary *dict = @{@"Mon" : @"周一",
                           @"Tues": @"周二",
                           @"Wed" : @"周三",
                           @"Thur": @"周四",
                           @"Fir" : @"周五",
                           @"Sat" : @"周六",
                           @"Sun" : @"周日"};
    
    NSString *weekText = [self union_toStringWithFormatter:@"EEE"];
    if ([dict.allKeys containsObject:weekText]) {
        return [dict objectForKey:weekText];
    }
    return nil;
}
    
- (NSString *)union_toStringWithFormatter:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}
    
- (NSString *)union_toStringWithFormatterType:(BTDateFormatType)type {
    NSArray *types = @[@"HH:mm",
                       @"MM-dd",
                       @"YYYY-MM-dd",
                       @"YYYY-MM-dd HH:mm"];
    if (types.count > type) {
        return [self union_toStringWithFormatter:types[type]];
    }
    return nil;
}
    
+ (NSDate *)union_dateFromDateString:(NSString *)dateString withFormatter:(NSString *)format {
    NSDateFormatter *dFormat = [[NSDateFormatter alloc] init];
    dFormat.dateFormat = format ? : kDefaultDateFormatter;
    dFormat.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    return [dFormat dateFromString:dateString];
}
    
+ (BOOL)union_isDate:(NSDate *)aDate withDate:(NSDate *)bDate equalWithUnits:(unsigned int)units {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:units fromDate:aDate];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:units fromDate:bDate];
    
    NSArray *flags = @[@(NSCalendarUnitDay),@(NSCalendarUnitMonth),@(NSCalendarUnitYear)];
    for (int i = 0; i < flags.count; i++) {
        unsigned int flag = [flags[i] intValue];
        if ((units & flag) == flag) {
            if ([components1 valueForComponent:flag] != [components2 valueForComponent:flag]) {
                return NO;
            }
        }
    }
    return YES;
}
    
- (BOOL)union_isYMDEqualToDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
    
- (BOOL)union_isYEqualToDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month));
}
    
- (BOOL)union_isDateToday {
    return [self union_isYMDEqualToDate:[NSDate date]];
}
    
- (BOOL)union_isDateTomorrow {
    return [self union_isYMDEqualToDate:[NSDate union_tomorrow]];
}
    
- (BOOL)union_isDateYesterday {
    return [self union_isYMDEqualToDate:[NSDate union_yesterday]];
}
    
- (NSDate *)union_endOfDay {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate: self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [cal dateFromComponents:components];
}
    
- (NSDate *)union_startOfDay {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate: self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [cal dateFromComponents:components];
}
    
- (NSDate *)union_startDayOfMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate: self];
    components.day = 1;
    return [cal dateFromComponents:components];
}
    
- (NSDate *)union_endDayOfMonth {
    return [[[self union_startDayOfMonth] union_dateByAddingDays:[self union_daysOfMonth] - 1] union_endOfDay];
}
    
- (NSInteger)union_daysOfMonth {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange days = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return days.length;
}
    
+ (NSDate *)union_todayAtMidnight {
    return [[NSDate date] union_endOfDay];
}
    
+ (NSDate *)union_todayAtStart {
    return [[NSDate date] union_startOfDay];
}
    
+ (NSInteger)union_compareDaysWithDate:(NSDate *)date toOtherDate:(NSDate *)otherDate {
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:date];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:otherDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


@end
