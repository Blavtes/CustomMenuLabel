//
//  NSDictionary+SafetyCrash.m
//  safetyCrash
//
//  Created by Blavtes on 16/9/21.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSDictionary+SafetyCrash.h"

#import "SafetyCrash.h"

@implementation NSDictionary (safetyCrash)

+ (void)safetyCrashExchangeMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [SafetyCrash exchangeClassMethod:self method1Sel:@selector(dictionaryWithObjects:forKeys:count:) method2Sel:@selector(safetyCrashDictionaryWithObjects:forKeys:count:)];
    });
}


+ (instancetype)safetyCrashDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
{
    
    id instance = nil;
    
    @try {
        instance = [self safetyCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to remove nil key-values and instance a dictionary.";
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
        //处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self safetyCrashDictionaryWithObjects:newObjects forKeys:newkeys count:index];
    } @finally {
        return instance;
    }
}

@end
