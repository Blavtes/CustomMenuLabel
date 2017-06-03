//
//  NSString+Judgement.h
//  HX_GJS
//
//  Created by litao on 16/1/7.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  提供特定格式的字符串校验
 */
@interface NSString (Judgement)

/**
 *  是否是email格式
 */
- (BOOL)isEmailFormat;

/**
 *  是否是手机号码格式
 */
- (BOOL)isMobilePhoneNumFormat;

/**
 *  是否身份证格式
 */
- (BOOL)isIDCardFormat;

/**
 *  是否纯数字格式
 */
- (BOOL)isOnlyNumberFormat;

/**
 *  是否不带符号的密码格式[有字母数字组成]
 */
- (BOOL)isPasswordWithoutSymbolFormat;
@end
