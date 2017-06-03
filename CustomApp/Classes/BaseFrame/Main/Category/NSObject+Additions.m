//
//  Created by SunX on 14-5-14.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "NSObject+Additions.h"
#import <CoreData/CoreData.h>


static NSSet *foundationClasses_;

@implementation NSObject (GJSNSObjectAdditions)


#pragma mark - 再封装方法

/**
 *  通过NSDictionary初始化property
 *  为什么要增加这个，目的是避免服务器数据类型错误的问题
 *  @param item
 */
- (void)GJSAutoSetPropertySafety:(NSDictionary *)item
{
    if (!item || ![item isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //获取所有property
    [[self class] GJSEnumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        
        [self setClassProperty:c withPropertyDic:item];

    }];
    
}

/**
 *  重置所有property
 */
- (void)GJSResetAllProperty
{
    //获取所有property
    [[self class] GJSEnumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        
        [self GJSCurClassResetAllProperty:c];
        
    }];
    
}

/**
 *  获取当前class的property和value
 */
- (NSMutableDictionary *)GJSAllPropertiestAndValues
{
    //  获取所有propertiest
    NSMutableDictionary *propertiestDic = [NSMutableDictionary dictionary];
    [[self class] GJSEnumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        
        [propertiestDic addEntriesFromDictionary:[self GJSCurClassAllPropertiestAndValues:c]];
    }];
    return propertiestDic;
}


/**
 *  获取class 所有属性 Propertiest
 *
 *  @return 数组
 */
- (NSMutableArray *)GJSAllPropertiest
{
    NSMutableArray *propertiestArray = [NSMutableArray array];
    [[self class] GJSEnumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
        
        [propertiestArray addObjectsFromArray:[c GJSCurClassAllPropertiest]];
    }];
    
    return propertiestArray;
}

#pragma mark - 基类方法


/**
 *  获取当前class中所有的property
 *
 *  @param class 类名
 *  @param item
 */
- (void)setClassProperty:(Class)class withPropertyDic:(NSDictionary *)item
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id valueItem = item[propertyName];
        if (valueItem) {
            //获取该property的数据类型
            const char *attries = property_getAttributes(property);
            NSString *attrString = [NSString stringWithUTF8String:attries];
            [self GJSSetPropery:attrString value:valueItem propertyName:propertyName];
        }
    }
    if(properties) free(properties);
}

/**
 *  重置当前class 所有property
 */
- (void)GJSCurClassResetAllProperty:(Class)class
{
    //获取所有property
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        //获取该property的数据类型
        const char *attries = property_getAttributes(property);
        NSString *attrString = [NSString stringWithUTF8String:attries];
    
        [self GJSSetPropery:attrString value:nil propertyName:propertyName];
    }
    if(properties) free(properties);
}

/**
 *  安全设置 value
 */
- (void)GJSSetPropery:(NSString *)attriString
                value:(id)value
         propertyName:(NSString *)propertyName
{
    //kvc不支持c的数据类型，所以只能NSNumber转化，NSNumber可以  64位是TB
    if ([attriString hasPrefix:@"T@\"NSString\""]) {
        [self setValue:GJSToString(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tc"] || [attriString hasPrefix:@"TB"]) {
        //32位Tc  64位TB
        [self setValue:[NSNumber numberWithBool:[value boolValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Ti"] || [attriString hasPrefix:@"Tq"]) {
        //32位 Ti是int 和 NSInteger  64位后，long 和  NSInteger 都是Tq， int 是Ti
        [self setValue:[NSNumber numberWithInteger:[GJSToString(value) integerValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"TQ"] || [attriString hasPrefix:@"TI"]) {
        [self setValue:[NSNumber numberWithInteger:[GJSToString(value) integerValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tl"]) { //32位 long
        [self setValue:[NSNumber numberWithLongLong:[GJSToString(value) longLongValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tf"]) { //float
        [self setValue:[NSNumber numberWithFloat:[GJSToString(value) floatValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Td"]) { //CGFloat
        [self setValue:[NSNumber numberWithDouble:[GJSToString(value) doubleValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableArray\""]) {
        [self setValue:GJSToMutableArray(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSArray\""]) {
        [self setValue:GJSToArray(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSDictionary\""]) {
        [self setValue:GJSToDictionary(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableDictionary\""]) {
        [self setValue:GJSToMutableDictionary(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSNumber\""]) {
        [self setValue:@([GJSToString(value) integerValue]) forKey:propertyName];
    }
}


/**
 *  获取当前class中所有的 key - value
 */
- (NSMutableDictionary *)GJSCurClassAllPropertiestAndValues:(Class)class
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([self valueForKey:propertyName]) {
            [props setObject:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    if(properties) free(properties);
    return props;
}

/**
 *  获取当前class 所有属性名 key
 *
 *  @return 数组
 */
- (NSMutableArray *)GJSCurClassAllPropertiest
{
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    if(properties) free(properties);
    return props;
}

#pragma mark - 

//  获取该之类下的所有父类 【第一个为 self class】
+ (void)GJSEnumerateAllClasses:(void (^)(Class c, BOOL *stop))enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    // 2.停止遍历的标记
    BOOL stop = NO;
    // 3.当前正在遍历的类
    Class c = self;
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        // 4.2.获得父类
        c = class_getSuperclass(c);
        //  如果是系统类 就终止
        if ([self GJSIsClassFromFoundation:c]) {
            break;
        }
    }
}

//  需要排除的系统类， 继承于NSOject
- (NSSet *)GJSFoundationClasses
{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

//  是否是 系统类
- (BOOL)GJSIsClassFromFoundation:(Class)c
{
    if (c == [NSObject class] ||
        c == [NSManagedObject class]) {
        return YES;
    }
    
    __block BOOL result = NO;
    [[self GJSFoundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

#pragma mark - 数据校验

- (NSString *)GJSJsonEncode
{
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSMutableArray class]] ||
        [self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSMutableDictionary class]])
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)GJSObjectFortKeySafe:(NSString *)key
{
    if ([self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSMutableDictionary class]])
    {
        return [(NSDictionary *)self objectForKey:key];
    }
    return nil;
}

- (id)GJSObjectIndexSafe:(NSUInteger)index
{
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSMutableArray class]])
    {
        if (index < [(NSArray *)self count]) {
            return [(NSArray *)self objectAtIndex:index];
        }
        return nil;
    }
    return nil;
}

@end


/**
 *  数据校验
 */
NSString* GJSToString(id obj)
{
    return [obj isKindOfClass:[NSObject class]] ? [NSString stringWithFormat:@"%@",obj] : @"";
}

NSArray* GJSToArray(id obj)
{
    return [obj isKindOfClass:[NSArray class]] ? obj : nil;
}

NSDictionary* GJSToDictionary(id obj)
{
    return [obj isKindOfClass:[NSDictionary class]] ? obj : nil;
}

NSMutableArray* GJSToMutableArray(id obj)
{
    return [obj isKindOfClass:[NSArray class]] ||
    [obj isKindOfClass:[NSMutableArray class]] ? [NSMutableArray arrayWithArray:obj] : nil;
}

NSMutableDictionary* GJSToMutableDictionary(id obj)
{
    return [obj isKindOfClass:[NSDictionary class]] ||
    [obj isKindOfClass:[NSMutableDictionary class]] ? [NSMutableDictionary dictionaryWithDictionary:obj] : nil;
}



