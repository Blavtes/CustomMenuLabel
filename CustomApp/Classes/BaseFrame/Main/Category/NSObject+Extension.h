//
//  NSObject+Extension.h
//  HX_GJS
//
//  Created by litao on 15/9/28.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

+ (void)swizzleSelector:(SEL)originalSEL withSwizzledSelector:(SEL)swizzledSEL;
+ (void)swizzleSelector:(SEL)originalSEL withSwizzledSelector:(SEL)swizzledSEL withClass:(Class)theClass;
    
/**
 *  判断一个对象是否为nil
 */
- (BOOL)isNilObj;
@end
