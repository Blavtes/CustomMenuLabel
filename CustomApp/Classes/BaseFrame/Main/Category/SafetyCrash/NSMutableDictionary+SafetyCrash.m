//
//  NSMutableDictionary+SafetyCrash.m
//  safetyCrash
//
//  Created by Blavtes on 16/9/22.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSMutableDictionary+SafetyCrash.h"

#import "SafetyCrash.h"

@implementation NSMutableDictionary (safetyCrash)

+ (void)safetyCrashExchangeMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
        
        //setObject:forKey:
        [SafetyCrash exchangeInstanceMethod:dictionaryM method1Sel:@selector(setObject:forKey:) method2Sel:@selector(safetyCrashSetObject:forKey:)];
        
        //removeObjectForKey:
        Method removeObjectForKey = class_getInstanceMethod(dictionaryM, @selector(removeObjectForKey:));
        Method safetyCrashRemoveObjectForKey = class_getInstanceMethod(dictionaryM, @selector(safetyCrashRemoveObjectForKey:));
        method_exchangeImplementations(removeObjectForKey, safetyCrashRemoveObjectForKey);
    });
}

//=================================================================
//                       setObject:forKey:
//=================================================================
#pragma mark - setObject:forKey:

- (void)safetyCrashSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    @try {
        [self safetyCrashSetObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [SafetyCrash noteErrorWithException:exception defaultToDo:SafetyCrashDefaultIgnore];
    } @finally {
        
    }
}

//=================================================================
//                       removeObjectForKey:
//=================================================================
#pragma mark - removeObjectForKey:

- (void)safetyCrashRemoveObjectForKey:(id)aKey
{
    
    @try {
        [self safetyCrashRemoveObjectForKey:aKey];
    } @catch (NSException *exception) {
        [SafetyCrash noteErrorWithException:exception defaultToDo:SafetyCrashDefaultIgnore];
    } @finally {
        
    }
}

@end
