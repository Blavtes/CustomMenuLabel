//
//  NSAttributedString+SafetyCrash.m
//  safetyCrashDemo
//
//  Created by Blavtes on 16/10/15.
//  Copyright © 2016年 Blavtes. All rights reserved.
//

#import "NSAttributedString+SafetyCrash.h"
#import "SafetyCrash.h"

@implementation NSAttributedString (safetyCrash)

+ (void)safetyCrashExchangeMethod
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class NSConcreteAttributedString = NSClassFromString(@"NSConcreteAttributedString");
        
        //initWithString:
        [SafetyCrash exchangeInstanceMethod:NSConcreteAttributedString method1Sel:@selector(initWithString:) method2Sel:@selector(safetyCrashInitWithString:)];
        
        //initWithAttributedString
        [SafetyCrash exchangeInstanceMethod:NSConcreteAttributedString method1Sel:@selector(initWithAttributedString:) method2Sel:@selector(safetyCrashInitWithAttributedString:)];
        
        //initWithString:attributes:
        [SafetyCrash exchangeInstanceMethod:NSConcreteAttributedString method1Sel:@selector(initWithString:attributes:) method2Sel:@selector(safetyCrashInitWithString:attributes:)];
    });
}

//=================================================================
//                           initWithString:
//=================================================================
#pragma mark - initWithString:

- (instancetype)safetyCrashInitWithString:(NSString *)str
{
    id object = nil;
    
    @try {
        object = [self safetyCrashInitWithString:str];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

//=================================================================
//                          initWithAttributedString
//=================================================================
#pragma mark - initWithAttributedString

- (instancetype)safetyCrashInitWithAttributedString:(NSAttributedString *)attrStr
{
    id object = nil;
    
    @try {
        object = [self safetyCrashInitWithAttributedString:attrStr];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

//=================================================================
//                      initWithString:attributes:
//=================================================================
#pragma mark - initWithString:attributes:

- (instancetype)safetyCrashInitWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs
{
    id object = nil;
    
    @try {
        object = [self safetyCrashInitWithString:str attributes:attrs];
    } @catch (NSException *exception) {
        NSString *defaultToDo = SafetyCrashDefaultReturnNil;
        [SafetyCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    } @finally {
        return object;
    }
}

@end
