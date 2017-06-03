//
//  NSObject+Extension.m
//  HX_GJS
//
//  Created by litao on 15/9/28.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

+ (void)swizzleSelector:(SEL)originalSEL withSwizzledSelector:(SEL)swizzledSEL
{
    [self swizzleSelector:originalSEL withSwizzledSelector:swizzledSEL withClass:nil];
}

+ (void)swizzleSelector:(SEL)originalSEL withSwizzledSelector:(SEL)swizzledSEL withClass:(Class)theClass
{
    Class aClass;
    
    if (theClass) {
        aClass = theClass;
    } else {
        aClass = [self class];
    }
    
    //  获取SEL 及 Method
    SEL originalSelector = originalSEL;
    SEL swizzledSelector = swizzledSEL;
    
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(aClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        //  替换
        class_replaceMethod(aClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        //  交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - 空对象判断

- (BOOL)isNilObj
{
    //  判断value是否为空
    //  1.空对象指针nil
    //  2.空类指针Nil
    //  3.空对象[NSNull null]<非nil> - 不会造成容器崩溃
    //  4.空基本数据类型NULL
    //  5.空类[NSNull class]
    if ([self isEqual:[NSNull null]] || nil == self || Nil == self || NULL == self) {
        //DLog(@"isNilObj - nil obj");
        return YES;
    } else if ([self isKindOfClass:[NSNull class]]) {
        //DLog(@"isNilObj - nil class");
        return YES;
    } else if ([self isKindOfClass:[NSString class]] && FMT_STR(@"%@", self).length <= 0) {
        //DLog(@"isNilObj - self is NSString && length <= 0");
        return YES;
    } else if ([FMT_STR(@"%@", self) isEqualToString:@"(null)"] || [FMT_STR(@"%@", self) isEqualToString:@"<null>"]) {
        //  服务器返回的特殊空字符
        return YES;
    }
    
    return NO;
}
@end
