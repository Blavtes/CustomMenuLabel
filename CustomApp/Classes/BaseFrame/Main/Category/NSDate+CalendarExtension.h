//
//  NSDate+CalendarExtension.h
//  HX_GJS
//
//  Created by litao on 15/12/13.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarExtension)
//  当前小时
- (NSInteger)hour;
//  当前分钟
- (NSInteger)minute;

//  当前所在天
- (NSInteger)day;

//  当前所在月份
- (NSInteger)month;

//  当前所在年份
- (NSInteger)year;

//  本月第一天周几
- (NSInteger)firstWeekdayInMonth;

//  本月一共多少天
- (NSInteger)totaldaysInMonth;

//  下年
- (NSDate*)nextYear;

//  上年
- (NSDate *)lastYear;

//  下月
- (NSDate*)nextMonth;

//  上月
- (NSDate *)lastMonth;

//  指定月份
- (NSDate *)setTargetDate:(NSInteger)year withMonth:(NSInteger)month;
@end
