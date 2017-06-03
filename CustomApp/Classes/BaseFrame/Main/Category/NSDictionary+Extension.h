//
//  NSDictionary+Extension.h
//  YiYunMi
//
//  Created by litao on 15/9/9.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
/**
 *  安全的数组
 */
- (id)objectForKeyForSafetyArray:(id)aKey;

/**
 *  安全的字典
 */
- (id)objectForKeyForSafetyDictionary:(id)aKey;

/**
 *  安全的值
 */
- (id)objectForKeyForSafetyValue:(id)aKey;
@end


#pragma mark - 扩展setObject:  forKey:
@interface NSMutableDictionary (Extension)
/**
 *  校验设置object是否object为nil
 */
- (void)setObjectJudgeNil:(id)anObject forKey:(id)aKey;
@end