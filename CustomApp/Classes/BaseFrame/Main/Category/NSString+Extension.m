//
//  NSString+Extension.m
//  HX_GJS
//
//  Created by litao on 16/1/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)strSizeWithFont:(CGFloat)sysFontSize maxSize:(CGSize)maxSize
{
    UIFont *sysFont = [UIFont systemFontOfSize:sysFontSize];
    
    NSDictionary *dict = @{NSFontAttributeName : sysFont};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size;
}

- (CGSize)getTextSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth {
    
    CGSize textSize;
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    if (IOS_VERSION >= 7.0) {
        textSize = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName: font}
                                      context:nil].size;
    }
    else {
        textSize = [self sizeWithFont:font
                    constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return textSize;
}

- (NSString *)formatStrTo10_4
{
    if ([self isNilObj]) {
        return @"--";
    }
    
    NSString *retStr = [self formatStrWithFormat:self positiveFormat:@"###,##0.00;"];
    
    return retStr;
}

- (NSString *)formatStrTo10_4WithNoDecimal
{
    if ([self isNilObj]) {
        return @"--";
    }
    
    NSString *retStr = [self formatStrWithFormat:self positiveFormat:@"###,##0;"];
    
    return retStr;
}

- (NSString *)formatStrWithFormat:(id)str positiveFormat:(NSString *)positiveFormat
{
    //  id类型转换成str
    NSString *srcStr = FMT_STR(@"%@", str);
    NSString *srcStrNoSign = srcStr;
    
    if ([srcStr isNullStr]) {
        return @"--";
    }
    //  在str判断是否有‘,’
    if ([srcStr rangeOfString:@"," options:NSLiteralSearch].location != NSNotFound) {
        //  如果源数据有千分位或者逗号 去掉千分位
        srcStrNoSign = [srcStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    //  format
    NSNumberFormatter* numFmt = [[NSNumberFormatter alloc] init];
    [numFmt setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numFmt setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numFmt setPositiveFormat:positiveFormat];
    NSString *retStr = [numFmt stringFromNumber:[NSNumber numberWithDouble: [(NSString*)srcStrNoSign doubleValue]]];
    
    return retStr;
}

- (NSString *)formatStrWithSignToNumberStr
{
    //  id类型转换成str
    NSString *srcStrNoSign = FMT_STR(@"%@", self);
    
    if ([self isNullStr]) {
        return @"0.0";
    }
    //  在str判断是否有‘,’
    if ([srcStrNoSign rangeOfString:@"," options:NSLiteralSearch].location != NSNotFound) {
        //  如果源数据有千分位或者逗号 去掉千分位
        srcStrNoSign = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    return srcStrNoSign;
}

- (BOOL)isDecimalNumStr
{
    if ([self isNullStr]) {
        return NO;
    }
    
    NSString *strNum = [[NSString alloc] initWithString:self];
    
    if([strNum rangeOfString:@"." options:NSLiteralSearch].location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)hidePhoneNumStr
{
    if ([self isNullStr]) {
        return @"--";
    }
    
    NSString *tempStr = [NSString stringWithString:self];
    
    if (tempStr.length == 11) {
        //  隐藏中间部分
        NSRange rang = NSMakeRange(3, 4);
        NSString *retStr = [tempStr stringByReplacingCharactersInRange:rang withString:@"****"];
        tempStr = [NSString stringWithString:retStr];
    }
    
    return tempStr;
}

- (NSString *)hideBankCardNumStr
{
    if ([self isNullStr]) {
        return @"--";
    }
    
    NSString *tempStr = [NSString stringWithString:self];
    
    if (tempStr.length < 4) {
        return tempStr;
    }
    
    //  隐藏中间部分
    NSRange rang = NSMakeRange(0, tempStr.length - 4);
    NSString *retStr = [tempStr stringByReplacingCharactersInRange:rang withString:@"***************"];
    tempStr = [NSString stringWithString:retStr];
    
    return tempStr;
}

- (NSString *)hideUserNameStr
{
    if ([self isNullStr]) {
        return @"--";
    }
    
    NSString *tempStr = FMT_STR(@"%@", self);
    
    if (tempStr.length < 1) {
        return tempStr;
    }
    
    //  隐藏中间部分
    NSRange rang = NSMakeRange(0, 1);
    NSString *retStr = [tempStr stringByReplacingCharactersInRange:rang withString:@"*"];
    tempStr = FMT_STR(@"%@", retStr);
    
    return tempStr;
}

- (NSString *)hideIdNumStr
{
    if ([self isNullStr]) {
        return @"--";
    }
    
    NSString *tempStr = FMT_STR(@"%@", self);
    
    if (tempStr.length < 18) {
        return tempStr;
    }
    
    //  隐藏中间部分
    NSRange rang = NSMakeRange(4, 10);
    NSString *retStr = [tempStr stringByReplacingCharactersInRange:rang withString:@"**********"];
    tempStr = FMT_STR(@"%@", retStr);
    
    return tempStr;
}

- (BOOL)isNullStr
{
    if ([self isNilObj]) {
        return YES;
    } else if (FMT_STR(@"%@", self).length <= 0) {
        return YES;
    } else if ([FMT_STR(@"%@", self) isEqualToString:@"<null>"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isFilterRulesStr
{
    //1.不允许输入任何符号,小数点除外
    //2.第一位不支持小数点
    //3.只允许出现一次小数点
    //6.类似001等,合法,自动提取转化
    NSString *rule = @"^[0-9]+([.]{0}|[.]{1}[0-9]*)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    
    return [predicate evaluateWithObject:self];
}
@end
