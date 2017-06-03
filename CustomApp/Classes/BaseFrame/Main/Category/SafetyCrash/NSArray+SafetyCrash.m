//
//  NSArray+SafetyCrash.m
//  safetyCrash
//
//  Created by Blavtes on 16/9/21.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSArray+SafetyCrash.h"
#import "SafetyCrash.h"

@implementation NSArray (safetyCrash)

+ (void)safetyCrashExchangeMethod
{    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //=================
        //   class method
        //=================
        
        //instance array method exchange
        [SafetyCrash exchangeClassMethod:[self class] method1Sel:@selector(arrayWithObjects:count:) method2Sel:@selector(safetyCrashArrayWithObjects:count:)];
    
        //====================
        //   instance method
        //====================
        
        Class __NSArray = NSClassFromString(@"NSArray");
        Class __NSArrayI = NSClassFromString(@"__NSArrayI");
        Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
        Class __NSArray0 = NSClassFromString(@"__NSArray0");
        
        //objectsAtIndexes:
        [SafetyCrash exchangeInstanceMethod:__NSArray method1Sel:@selector(objectsAtIndexes:) method2Sel:@selector(safetyCrashObjectsAtIndexes:)];
        
        //objectAtIndex:
        
        [SafetyCrash exchangeInstanceMethod:__NSArrayI method1Sel:@selector(objectAtIndex:) method2Sel:@selector(__NSArrayISafetyCrashObjectAtIndex:)];
        
        [SafetyCrash exchangeInstanceMethod:__NSSingleObjectArrayI method1Sel:@selector(objectAtIndex:) method2Sel:@selector(__NSSingleObjectArrayISafetyCrashObjectAtIndex:)];
        
        [SafetyCrash exchangeInstanceMethod:__NSArray0 method1Sel:@selector(objectAtIndex:) method2Sel:@selector(__NSArray0SafetyCrashObjectAtIndex:)];
        
        //getObjects:range:
        [SafetyCrash exchangeInstanceMethod:__NSArray method1Sel:@selector(getObjects:range:) method2Sel:@selector(NSArraySafetyCrashGetObjects:range:)];
        
        [SafetyCrash exchangeInstanceMethod:__NSSingleObjectArrayI method1Sel:@selector(getObjects:range:) method2Sel:@selector(__NSSingleObjectArrayISafetyCrashGetObjects:range:)];
        
        [SafetyCrash exchangeInstanceMethod:__NSArrayI method1Sel:@selector(getObjects:range:) method2Sel:@selector(__NSArrayISafetyCrashGetObjects:range:)];
    });
}

//=================================================================
//                        instance array
//=================================================================
#pragma mark - instance array

+ (instancetype)safetyCrashArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    id instance = nil;
    
    @try {
        instance = [self safetyCrashArrayWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to remove nil object and instance a array.";
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
        //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self safetyCrashArrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}

//=================================================================
//                     objectAtIndexedSubscript:
//=================================================================
#pragma mark - objectAtIndexedSubscript:
- (id)safetyCrashObjectAtIndexedSubscript:(NSUInteger)idx
{
    id object = nil;
    
    @try {
        object = [self safetyCrashObjectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }

}

//=================================================================
//                       objectsAtIndexes:
//=================================================================
#pragma mark - objectsAtIndexes:

- (NSArray *)safetyCrashObjectsAtIndexes:(NSIndexSet *)indexes
{
    
    NSArray *returnArray = nil;
    @try {
        returnArray = [self safetyCrashObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        return returnArray;
    }
}

//=================================================================
//                         objectAtIndex:
//=================================================================
#pragma mark - objectAtIndex:

//__NSArrayI  objectAtIndex:
- (id)__NSArrayISafetyCrashObjectAtIndex:(NSUInteger)index
{
    id object = nil;
    
    @try {
        object = [self __NSArrayISafetyCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

//__NSSingleObjectArrayI objectAtIndex:
- (id)__NSSingleObjectArrayISafetyCrashObjectAtIndex:(NSUInteger)index
{
    id object = nil;
    
    @try {
        object = [self __NSSingleObjectArrayISafetyCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

//__NSArray0 objectAtIndex:
- (id)__NSArray0SafetyCrashObjectAtIndex:(NSUInteger)index
{
    id object = nil;
    
    @try {
        object = [self __NSArray0SafetyCrashObjectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

//=================================================================
//                           getObjects:range:
//=================================================================
#pragma mark - getObjects:range:

//NSArray getObjects:range:
- (void)NSArraySafetyCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
{
    
    @try {
        [self NSArraySafetyCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

//__NSSingleObjectArrayI  getObjects:range:
- (void)__NSSingleObjectArrayISafetyCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self __NSSingleObjectArrayISafetyCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

//__NSArrayI  getObjects:range:
- (void)__NSArrayISafetyCrashGetObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
{
    
    @try {
        [self __NSArrayISafetyCrashGetObjects:objects range:range];
    } @catch (NSException *exception) {
        
        NSString *defaultToDo = SafetyCrashDefaultIgnore;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
    } @finally {
        
    }
}

@end
