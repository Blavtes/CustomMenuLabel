//
//  NSDictionary+SafetyCrash.h
//  safetyCrash
//
//  Created by Blavtes on 16/9/21.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safetyCrash)

+ (void)safetyCrashExchangeMethod;

@end


/**
 *  Can Safety crash method
 *
 *  1. NSDictionary的快速创建方式 NSDictionary *dict = @{@"frameWork" : @"SafetyCrash"}; //这种创建方式其实调用的是2中的方法
 *  2. +(instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
 *
 */
