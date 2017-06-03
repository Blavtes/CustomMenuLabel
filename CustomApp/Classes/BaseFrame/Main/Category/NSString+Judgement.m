//
//  NSString+Judgement.m
//  HX_GJS
//
//  Created by litao on 16/1/7.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "NSString+Judgement.h"

@implementation NSString (Judgement)
- (BOOL)isEmailFormat
{
    NSString *judgeRole = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", judgeRole];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)isMobilePhoneNumFormat
{
    //  14x[数据卡号段] 17xx[虚拟运营商号段]
    /**
     * 手机号码
     * 移动：134[0-8] 13[5-9] 150 151 152 157 158 159 182 183 184 187 188
     * 联通：130 131 132 155 156 185 186
     * 电信：133 1349[卫通] 153 180 181 189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8] 13[5-9] 150 151 152 157 158 159 182 183 184 187 188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0-27-9]|8[2-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349[卫通],153,180,181,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        if([regextestcm evaluateWithObject:self] == YES) {
            DLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:self] == YES) {
            DLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:self] == YES) {
            DLog(@"China Unicom");
        } else {
            DLog(@"Unknow");
        }
        
        return YES;
    }
    
    return NO;
}

- (BOOL)isIDCardFormat
{
    if (self.length <= 0) {
        return NO;
    }
    
    NSString *judgeRole = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", judgeRole];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)isOnlyNumberFormat
{
    NSString *judgeRole = @"^[0-9]*[1-9][0-9]*$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", judgeRole];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)isPasswordWithoutSymbolFormat
{
    NSString *judgeRole = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", judgeRole];
    
    return [predicate evaluateWithObject:self];
}
@end
