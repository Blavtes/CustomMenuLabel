//
//  NSMutableArray+SafetyCrash.m
//  safetyCrash
//
//  Created by Blavtes on 16/9/21.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSMutableArray+SafetyCrash.h"

#import "SafetyCrash.h"

@implementation NSMutableArray (safetyCrash)

+ (void)safetyCrashExchangeMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class arrayMClass = NSClassFromString(@"__NSArrayM");
        
        //objectAtIndex:
        [SafetyCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(objectAtIndex:) method2Sel:@selector(safetyCrashObjectAtIndex:)];
        
        //setObject:atIndexedSubscript:
        [SafetyCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(setObject:atIndexedSubscript:) method2Sel:@selector(safetyCrashSetObject:atIndexedSubscript:)];
        
        
        //removeObjectAtIndex:
        [SafetyCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(removeObjectAtIndex:) method2Sel:@selector(safetyCrashRemoveObjectAtIndex:)];
        
        //insertObject:atIndex:
        [SafetyCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(insertObject:atIndex:) method2Sel:@selector(safetyCrashInsertObject:atIndex:)];
        
        //getObjects:range:
        [SafetyCrash exchangeInstanceMethod:arrayMClass method1Sel:@selector(getObjects:range:) method2Sel:@selector(safetyCrashGetObjects:range:)];
    });
}

//=================================================================
//                    array set object at index
//=================================================================
#pragma mark - get object from array


- (void)safetyCrashSetObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    
    @try {
        [self safetyCrashSetObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [SafetyCrash noteErrorWithException:exception defaultToDo:SafetyCrashDefaultIgnore];
    } @finally {
        
    }
}

//=================================================================
//                    removeObjectAtIndex:
//=================================================================
#pragma mark - removeObjectAtIndex:

- (void)safetyCrashRemoveObjectAtIndex:(NSUInteger)index
{
    @try {
        [self safetyCrashRemoveObjectAtIndex:index];
    } @catch (NSException *exception) {
        [SafetyCrash noteErrorWithException:exception defaultToDo:SafetyCrashDefaultIgnore];
    } @finally {
        
    }
}

//=================================================================
//                    insertObject:atIndex:
//=================================================================
#pragma mark - set方法
- (void)safetyCrashInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    @try {
        [self safetyCrashInsertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        [SafetyCrash noteErrorWithException:exception defaultToDo:SafetyCrashDefaultIgnore];
    } @finally {
        
    }
}

//=================================================================
//                           objectAtIndex:
//=================================================================
#pragma mark - objectAtIndex:

- (id)safetyCrashObjectAtIndex:(NSUInteger)index
{
    id object = nil;
    
    @try {
        object = [self safetyCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

//=================================================================
//                         getObjects:range:
//=================================================================
#pragma mark - getObjects:range:

- (void)safetyCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self safetyCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

@end
