//
//  Created by SunX on 14-5-14.
//  Copyright (c) 2014年 SunX. All rights reserved.
//


#import <objc/runtime.h>

/**
 *  数据校验
 */
NSString* GJSToString(id obj);

NSArray* GJSToArray(id obj);

NSDictionary* GJSToDictionary(id obj);

NSMutableArray* GJSToMutableArray(id obj);

NSMutableDictionary* GJSToMutableDictionary(id obj);



@interface NSObject (GJSNSObjectAdditions)

/**
 *  通过NSDictionary初始化property
 *  为什么要增加这个，目的是避免服务器数据类型错误的问题
 *  @param item
 */
- (void)GJSAutoSetPropertySafety:(NSDictionary *)item;

/**
 *  重置所有property
 */
- (void)GJSResetAllProperty;

/**
 *  获取class的property和value
 */
- (NSMutableDictionary *)GJSAllPropertiestAndValues;

/**
 *  获取class 所有属性 Propertiest
 *
 *  @return 数组
 */
- (NSMutableArray *)GJSAllPropertiest;


- (void)GJSSetPropery:(NSString*)attriString
               value:(id)value
        propertyName:(NSString*)propertyName;


- (NSString*)GJSJsonEncode;

- (id)GJSObjectFortKeySafe:(NSString*)key;

- (id)GJSObjectIndexSafe:(NSUInteger)index;

@end
