//
//  NSObject+SafetyCrash.h
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/11.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (safetyCrash)

+ (void)safetyCrashExchangeMethod;

@end

/**
 *  Can Safety crash method
 *
 *  1.- (void)setValue:(id)value forKey:(NSString *)key
 *  2.- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
 *  3.- (void)setValue:(id)value forUndefinedKey:(NSString *)key //这个方法一般用来重写，不会主动调用
 *  4.- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
 *
 */

@interface SubObjectProxy : NSObject
void noFunctionResponse(id self, SEL _cmd);
@end
