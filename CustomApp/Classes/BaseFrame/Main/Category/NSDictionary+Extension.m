//
//  NSDictionary+Extension.m
//  YiYunMi
//
//  Created by litao on 15/9/9.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "NSDictionary+Extension.h"

#import <objc/runtime.h>

@implementation NSDictionary (Extension)
/**
 *  安全的数组
 */
- (id)objectForKeyForSafetyArray:(id)aKey
{
    if ([self isNilObj] || self.count <= 0) {
#warning current dictionary is nil or empty
        return [NSArray array];
    }
    
    //  校验是否为空
    if ([self isKeyOrValueNil:aKey]) {
#warning current key or value is nil
        return [NSArray array];
    }
    
    return [self objectForKey:aKey];
}

/**
 *  安全的字典
 */
- (id)objectForKeyForSafetyDictionary:(id)aKey
{
    if ([self isNilObj] || self.count <= 0) {
#warning current dictionary is nil or empty
        return [NSDictionary dictionary];
    }
    
    //  校验是否为空
    if ([self isKeyOrValueNil:aKey]) {
#warning current key or value is nil
        return [NSDictionary dictionary];
    }
    
    return [self objectForKey:aKey];
}

/**
 *  安全的值
 */
- (id)objectForKeyForSafetyValue:(id)aKey
{
    if ([self isNilObj] || self.count <= 0) {
#warning current dictionary is nil or empty
        return @"";
    }
    
    //  校验是否为空
    if ([self isKeyOrValueNil:aKey]) {
#warning current key or value is nil
        return @"";
    }
    
    return [self objectForKey:aKey];
}

/**
 *  判断key 或 value 是否为nil
 */
- (BOOL)isKeyOrValueNil:(id)aKey
{
    //  判断key是否为空
    if (![self objectForKey:aKey]) {
        return YES;
    }
    //  得到key对应object
    id obj = [self objectForKey:aKey];
    
    return [obj isNilObj];
}

@end

@implementation NSMutableDictionary (Extension)
/**
 *  校验设置object是否object为nil
 */
- (void)setObjectJudgeNil:(id)anObject forKey:(id)aKey
{
    id aObject = anObject;
    
    if ([anObject isNilObj] || anObject == nil) {
        aObject = [NSNull null];
    }
    
    [self setObject:aObject forKey:aKey];
}
@end