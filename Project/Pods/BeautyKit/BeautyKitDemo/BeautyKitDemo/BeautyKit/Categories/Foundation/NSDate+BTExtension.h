//
//  NSDate+BTExtension.h
//  BTExtension
//
//  Created by Quincy Yan on 16/7/11.
//  Copyright © 2016年 BTExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,BTDateFormatType) {
    BTDateFormatTypeHm    = 0,
    BTDateFormatTypeMD    = 1,
    BTDateFormatTypeYMD   = 2,
    BTDateFormatTypeYMDHm = 3,
};

@interface NSDate (BTExtension)

/**
 获取时间的某个部分
*/
- (NSDateComponents *)union_components;
    
/**
 获取星期几
*/
- (NSString *)union_weekend;
    
/**
 根据值获取对应的间隔时间
 */
- (NSDate *)union_dateByAddingUnit:(NSCalendarUnit)unit withOffset:(NSInteger)offset;
- (NSDate *)union_dateByAddingDays:(NSInteger)days;
- (NSDate *)union_dateByAddingMonths:(NSInteger)months;
- (NSDate *)union_dateByAddingYears:(NSInteger)years;
    
/**
 根据类型获得对应的时间文本
 */
- (NSString *)union_toStringWithFormatterType:(BTDateFormatType)type;
- (NSString *)union_toStringWithFormatter:(NSString *)format;
    
/**
 根据时间文本获取时间
 */
+ (NSDate *)union_dateFromDateString:(NSString *)dateString withFormatter:(NSString *)format;
    
+ (NSDate *)union_yesterday;
+ (NSDate *)union_tomorrow;
    
- (BOOL)union_isDateToday;
- (BOOL)union_isDateTomorrow;
- (BOOL)union_isDateYesterday;
    
/**
 是否这个两个时间的对应部分相同
 */
+ (BOOL)union_isDate:(NSDate *)aDate withDate:(NSDate *)bDate equalWithUnits:(unsigned)units;
    
/**
 当前时间是否与对应时间相同
 有且只比较年、月、日
 */
- (BOOL)union_isYMDEqualToDate:(NSDate *)aDate;
- (BOOL)union_isYEqualToDate:(NSDate *)aDate;
    
/**
 获取这天的第一秒的时间
 */
- (NSDate *)union_startOfDay;

/**
 获取这天的最后一秒的时间
 */
- (NSDate *)union_endOfDay;
    
/**
 获取这个月的第一天的第一秒的时间
 */
- (NSDate *)union_startDayOfMonth;
    
/**
 获取这个月的最后一天的最后一秒的时间
 */
- (NSDate *)union_endDayOfMonth;
    
/**
 获取这个月总共有几天
 */
- (NSInteger)union_daysOfMonth;
    
+ (NSDate *)union_todayAtMidnight;
+ (NSDate *)union_todayAtStart;
    
/**
 比较两个时间的天数差值
 */
+ (NSInteger)union_compareDaysWithDate:(NSDate *)date toOtherDate:(NSDate *)otherDate;

@end
