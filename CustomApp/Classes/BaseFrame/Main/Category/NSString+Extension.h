//
//  NSString+Extension.h
//  HX_GJS
//
//  Created by litao on 16/1/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  计算字符串Size
 *
 *  @param sysFontSize 字体大小
 *  @param maxSize     MAX_SIZE
 *
 *  @return 字符串大小
 */
- (CGSize)strSizeWithFont:(CGFloat)sysFontSize maxSize:(CGSize)maxSize;

/**
 *  计算字符串Size （可含换行符）支持IOS 7以下
 *
 *  @param fontSize 字体大小
 *  @param maxWidth    字体最大宽度
 *
 *  @return 字符串大小
 */
- (CGSize)getTextSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth;

/**
 *  返回一个带千位符的字符串
 */
- (NSString *)formatStrTo10_4;
/**
 *  返回一个带千位符无小数的字符串
 */
- (NSString *)formatStrTo10_4WithNoDecimal;

/**
 *  返回一个标准的数字字符串 - 不带千分位
 */
- (NSString *)formatStrWithSignToNumberStr;

/**
 *  是否小数
 *
 *  @return BOOL
 */
- (BOOL)isDecimalNumStr;

/**
 *  隐藏电话号码中间5位数字
 */
- (NSString *)hidePhoneNumStr;

/**
 *  隐藏银行卡号前面的数字
 */
- (NSString *)hideBankCardNumStr;

/**
 *  隐藏用户名的姓
 */
- (NSString *)hideUserNameStr;

/**
 *  隐藏身份证号码
 */
- (NSString *)hideIdNumStr;

/**
 *  是否空字符串
 */
- (BOOL)isNullStr;

/**
 * 充值、提现和转让输入框规则
 1. 不允许输入任何符号，小数点除外
 2. 第一位不支持小数点
 3. 只允许出现一次小数点
 */
- (BOOL)isFilterRulesStr;
@end
